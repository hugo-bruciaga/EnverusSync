
from Enverus.enverus_sync import db_connect
import datetime

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
