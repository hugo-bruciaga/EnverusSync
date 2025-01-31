import pymssql

conn = pymssql.connect(
    server='biconnect.enverus.com',
    user='env_2866',
    password='YRwmC1u5XSDa',
    database='Drillinginfo_DIBI'
)

query = ("SELECT * FROM ENV.Foundations_Production"
         " WHERE ENVRegion in ('EASTERN','GULF_COAST','PERMIAN','ROCKIES')"
         " AND DeletedDate IS NULL"
         " AND 'Foundations_Production' = (select dataset from ENV.Dataset_Info where dataset = 'Foundations_Production' and last_updated_date > dateadd(day, -7, getdate()))"
         " AND producingmonth >= '1948-07-01'"
         " AND producingmonth < '1952-05-01'")

with conn.cursor() as cursor:
    cursor.execute(query)
    rows = cursor.fetchall()
    print(rows)
