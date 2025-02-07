# .\pyinstaller --add-data 'C:\Users\hbruciaga\source\repos\EnverusSync\app\EnverusSync\data\EnverusSync.cfg:data' --add-data 'C:\Users\hbruciaga\source\repos\EnverusSync\app\EnverusSync\data\collectors.json:data' EnverusSync.py
# C:\Users\hbruciaga\source\repos\EnverusSync\app\EnverusSync\dist\EnverusSync\EnverusSync.exe Foundations_ActiveRigs
# C:\Users\hbruciaga\source\repos\EnverusSync\app\EnverusSync\dist\EnverusSync\EnverusSync.exe Foundations_Permits

import datetime, time, json, configparser, os, sys, smtplib

# import PyADO

import pyodbc


def load_data(file_path):
    try:
        with open(file_path, 'r') as file:
            data = file.read()
        return data
    except FileNotFoundError:
        return "File not found."


def resource_path(relative_path):
    base_path = getattr(sys, '_MEIPASS', os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_path, relative_path)


config_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), resource_path('data/EnverusSync.cfg'))
parser = configparser.ConfigParser()
parser.read(config_file)


def log_file(*args):
    stmt = ''
    with open(parser.get("logfiles", "logfile") + sync_tables + ".log", "a") as f:
        for param in args:
            stmt = stmt + ' ' + str(param)
        print(stmt, file=f)
        print(stmt)


env_srv = parser.get("database", "env_srv")
env_db = parser.get("database", "env_db")
env_user = parser.get("database", "env_user")
env_pw = parser.get("database", "env_pw")
ar_srv = parser.get("database", "ar_srv")
ar_db = parser.get("database", "ar_db")
schema_name = parser.get("database", "schema_name")
rolling_window = parser.get("input", "rolling_window")
# sync_tables = parser.get("input", "sync_tables")
sync_tables = ''
log_query = parser.get("input", "log_query")
write_json_to_file = parser.get("input", "write_json_to_file")


def db_connect(
        server: str,
        database: str,
        login_name: str = None,
        password: str = None,
        context: str = 'js.utils',
        driver_ver: int = 18
):
    database = 'master' if database is None or database == '' else database
    connection_string = f'DRIVER={{ODBC Driver {driver_ver} for SQL Server}};' \
                        f'SERVER={server};' \
                        f'DATABASE={database};' \
                        f'APP={context};' \
                        f'TrustServerCertificate=yes;'

    connection_string += 'Trusted_Connection=yes;' \
        if login_name is None or password is None or login_name == '' or password == '' \
        else f'UID={login_name};PWD={password}'

    return pyodbc.connect(connection_string)


def quotename(s: str):
    return s.replace("'", "''")


def rows_to_dict(data):
    if data:
        dtype_mapping = {
            datetime.datetime: datetime.datetime.isoformat,
            str: quotename
        }
        cols = [c for c in data[0].cursor_description]
        d_data = []

        for row in data:
            drow = {}
            for col in cols:
                val = row.__getattribute__(col[0])
                # val = row[0]

                if val is not None:
                    converter = dtype_mapping.get(col[1])
                    if converter:
                        val = converter(val)
                drow.update({col[0]: val})

            d_data.append(drow)
        return d_data
    else:
        log_file('No more records to process.')
        return None


def get_buckets_production(qry_filter):
    src_cn = db_connect(env_srv, env_db, env_user, env_pw)
    src_cr = src_cn.cursor()

    sql = (f" with partitions as ("
           f"      select producingmonth"
           f"     ,FLOOR((ROW_NUMBER()OVER(ORDER BY producingmonth)-1) /500000) +1 AS Bucket"
           f" from ENV.Foundations_Production "
           f"where {qry_filter}"
           f")"
           f"select Bucket, min(producingmonth), max(producingmonth)"
           f"  from partitions"
           f" group by Bucket"
           f" order by Bucket"
           )
    # 1948-07-01 00:00:00 through: 1952-05-01 00:00:00

    sql = ("select 0 Bucket, '' min, '' max union "
           "select 1, '1960-01-01' ,'1960-12-01 00:00:00' union "
           "select 2, '1960-12-01' ,'1961-11-01 00:00:00' union "
           "select 3, '1961-11-01' ,'1962-09-01 00:00:00' union "
           "select 4, '1962-09-01' ,'1963-06-01 00:00:00'"
           )

    data = src_cr.execute(sql).fetchall()

    return data


def sp_save(batch_size, table_name, unique_cols, stored_procedure, qry_filter):
    log_file(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), 'Processing:', table_name)
    src_cn = db_connect(env_srv, env_db, env_user, env_pw)
    dst_cn = db_connect(ar_srv, ar_db)

    src_cr = src_cn.cursor()

    start_r = time.time()
    if table_name == 'Foundations_Production':
        buckets = get_buckets_production(qry_filter)
        for bucket in buckets:
            log_file('Processing Bucket (' + str(bucket[0]) + '):', bucket[1][:10], 'thru:', bucket[2][:10])
            sql = (f"SELECT * FROM {schema_name}.{table_name}\n "
                   f" WHERE {qry_filter}\n"
                   f"   AND DeletedDate IS NULL\n"
                   f"   AND producingmonth >= '{bucket[1]}'\n"
                   f"   AND producingmonth < '{bucket[2]}'\n"
                   )

            if log_query.lower() == 'yes':
                log_file(sql)
            data = json.dumps(rows_to_dict(src_cr.execute(sql).fetchall()))
            if data != 'null':
                log_file(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), bucket[1][:10], bucket[2][:10], 'Time Elapsed Reading:',
                         datetime.timedelta(seconds=time.time() - start_r))

                if write_json_to_file == 'Yes':
                    with open(f"c:\\temp\\{table_name}_{str(bucket[1])[:10]}.json", 'w') as f:
                        f.write(data)
                # log_file('len(data):', len(data))
                start_w = time.time()

                sql = f"EXEC {stored_procedure} @data=?, @NoOutput=1"

                dst_cr = dst_cn.cursor()

                try:
                    dst_cr.setinputsizes([(pyodbc.SQL_WVARCHAR, 0)])
                    dst_cr.execute(sql, data).commit()

                except Exception as e:
                    log_file('Errors Found:', str(e))

                log_file(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), bucket[1][:10], bucket[2][:10], 'Time Elapsed Writing:',
                         datetime.timedelta(seconds=time.time() - start_w))
            else:
                print('no records fetched; moving on...')
    else:
        log_file("this job only process: Foundations Production")

    log_file(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), 'Completed', f'{table_name}')


'''
def send_email_stats(ds):
    html_code = """
            <!doctype html>
        <html>
        <head>
        <meta charset="utf-8">
        <title>Untitled Document</title>
        <body>
            <table border='1'
            <tr>
                <th>Table Name</th>
                <th>Count</th>
            </tr>"""
    for r in ds:
        html_code = html_code + """
            <tr>
                <td>{}</td>
                <td>{}</td>
            </tr>""".format(r[0], r[1], r[2], r[3])
    html_code = html_code + "</table></body></html>"
    # log_file(html_code)

    if len(html_code) > 0:
        msg = MIMEMultipart('alternative')
        msg.attach(MIMEText(html_code, 'html'))

        msg['Subject'] = parser.get("email", "Subject")
        msg['From'] = parser.get("email", "From")
        msg['To'] = parser.get("email", "To")

        # Send the message via our own SMTP server.
        host = parser.get("email", "Host")
        s = smtplib.SMTP(host)
        s.send_message(msg)
        s.quit()
    else:
        log_file("No Message to send.")
'''


def sp_counts(table_name, filter):
    src_cn = db_connect(env_srv, env_db, env_user, env_pw)

    src_cr = src_cn.cursor()
    src_cr.setinputsizes([(pyodbc.SQL_WVARCHAR, 0)])
    is_empty = False
    data = []
    while is_empty is False:
        sql = (f"SELECT format(count(*),'###,###,###') FROM {table_name}\n "
               f" WHERE {filter}"
               f"   AND DeletedDate IS NULL"
               )

        data = json.dumps(rows_to_dict(src_cr.execute(sql).fetchall()))

        if data == 'null':
            break
    return data


def main():
    email_content = {}
    retcode = 0
    with open(resource_path('data/collectors.json'), 'r') as collectors:
        config = json.load(collectors)
        for v in config.values():
            if v['src_name'] in sync_tables:
                try:
                    sp_save(v['batch_size'], v['src_name'], v['keys'], v['sp'], v['filter'])
                    # email_content = email_content + sp_counts(collector.get("src_name"), collector.get("filter"))
                except Exception as e:
                    retcode = len(str(e))
                    log_file(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()), v['src_name'], 'Failed:', str(e))
    return retcode
    # send_email_stats()


if __name__ == "__main__":
    errcode = 0
    # if len(sys.argv) > 1:
    # sync_tables = sys.argv[1]
    sync_tables = 'Foundations_Production'
    log_file("------------------------------------------------------------")
    log_file('PROCESSING TABLE:', sync_tables)
    log_file("------------------------------------------------------------")

    try_count = 1
    passed = False
    while try_count <= 5 and passed is False:
        ret = main()
        if ret == 0:
            passed = True
        else:
            passed = False
            log_file('Failed waiting for 1 hour.')
            time.sleep(1 * 60 * 60)
            try_count += 1
