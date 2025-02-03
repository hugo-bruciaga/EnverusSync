import datetime, pyodbc

def db_connect(
        server: str,
        database: str,
        login_name: str = None,
        password: str = None,
        context: str = 'js.utils',
        driver_ver: int = 17
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

cn = db_connect('biconnect.enverus.com', 'DrillingInfo_DIBI', 'env_2866', 'YRwmC1u5XSDa')
cr = cn.cursor()

sql = 'SELECT * FROM ENV.Foundations_Wells'
data = cr.execute(sql)
idx = 0
dur = None

while True:
    idx += 1
    print(f'{datetime.datetime.now()} | INFO | Getting rows - Batch Id {idx}')

    dts = datetime.datetime.now()
    myd = data.fetchmany(100000)
    dte = datetime.datetime.now()
    dur = dte - dts

    print(f'{datetime.datetime.now()} | INFO | Getting rows - Batch Id {idx}: duration {dur}')

    if not myd:
        break
