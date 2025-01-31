"""
    This file is the starting point of utilities and techniques being used by me. I will attempt to keep it
    up-to-date so that when I need to add one of the functions and what not from here the code is just copy
    and paste.

    At some point I'll learn more about creating packages and using pyinstaller or pysetup (I forget the real
    name) to get this added through normal methods like setup or pypy. For now since my Python skills are at
    about a scripter level this will have to do.
"""
import json
import pyodbc                       # pip install pyodbc
import datetime
from dateutil.tz import tzlocal     # pip install python-dateutil


def db_connect_oracle (
    driver_name: str,
    server: str,
    port: int,
    service: str,
    username: str,
    password: str
):
    driver_name = coalesce(driver_name, 'Oracle in instantclient_19_12')
    cn_str = f"DRIVER={{{driver_name}}}; DBQ={server}:{port}/{service}; UID={username}; PWD={password}"
    return pyodbc.connect(cn_str)


def db_connect(
    server: str,
    database: str,
    login_name: str = None,
    password: str = None,
    context: str = 'js.utils',
    driver_ver: int = 17
):
    """
    desc:   Connects to a sql server database server using the specified credentials or Windows Integrated if no
            username and password specified

    params: server      network name, network alias, IPv4 or IPv6 network address of the SQL Server optionally
                        including the port

            database    Name of the database the connection will be made to. The user must have connect permissions
                        in the database specified.

            login_name  The login name of SQL Server Login configured on the server being connected to

            password    The password of the specified login.

            context     Is the name of the application connecting to SQL Server. This value is used in the APP
                        parameter of the connection string. This will be the value found in program_name in the
                        sys.dm_exec_sessions dynamic management view.

            driver_ver  The version of the driver to be used. This has only been tested with 13 and 17. The
                        default is 17.

    return: pyodbc.Connection

    notes:  If login_name or password are empty or set to None then the connection is established using Integrated
            Security set to True
    """
    database = 'master' if database is None or database == '' else database
    connection_string = f'DRIVER={{ODBC Driver {driver_ver} for SQL Server}};' \
                        f'SERVER={server};' \
                        f'DATABASE={database};' \
                        f'APP={context};'

    connection_string += 'Trusted_Connection=yes;' \
        if login_name is None or password is None or login_name == '' or password == '' \
        else f'UID={login_name};PWD={password}'

    return pyodbc.connect(connection_string)


def coalesce(values: list, default=None):
    """
    desc:   Returns the first value in a list that is not None.

    params: values  The list of values to be evaluated. If the type of values is not a list than the entire object is
                    added as the only item in a newly created list to be evaluated. In this case if the values is None
                    then default is returned otherwise the entire values object is returned.

            default The value to return if no item in the values list object is not None.

    return: What ever the data type is of the first non None value found in the values list or the data type of
            default.
    """
    values = [values] if isinstance(values, list) is False else values

    for value in values:
        if value is not None:
            return value

    return default


def is_number(n):
    """
    Tests if a given input is valid number and returns true
    for numbers and false for everything else

    :param n: Value to be tested as a number
    :return: Bool
    """
    try:
        return True if float(n) else None
    except ValueError:
        return False


def convert_utc(utc_datetime: datetime.datetime):
    """
    desc:   Converts a datetime (in UTC) to the local time of the system the function is running on

    params: utc_datetime  The utc datetime object to be converted to local date and time

    return: datetime.datetime
    """
    now_tuple = (datetime.datetime.now(), datetime.datetime.utcnow())
    utc_offset = ((max(now_tuple) - min(now_tuple)).seconds + tzlocal().dst(
        datetime.datetime.now()).seconds) * -1 if datetime.datetime.now() < datetime.datetime.utcnow() else 1
    dst_offset = tzlocal().dst(utc_datetime + datetime.timedelta(seconds=utc_offset))

    return utc_datetime + datetime.timedelta(seconds=(utc_offset + dst_offset.seconds))


def str2bool(value: str):
    """
    Converts the string values 1, true, yes, y, 0, false, no and n to their boolean equivalents. If the input value is
    not in one of the preceding values then None is returned.

    params: value   The string value to be converted to a boolean

    return: Boolean/NoneType
    """
    return True if value.lower() in ['true', 'yes', 'y', '1'] else \
        False if value.lower() in ['false', 'no', 'n', '0'] else None


def rows_to_json(rows: list, return_dict: bool = False, keep_nulls: bool = False):
    """
        rows must be a list of rows returned by the pyodbc.Cursor.execute().fetchall() method

        Keep adding handlers for datatypes as you encounter data that can't be implicitly converted by the
        json.dumps function. Use the return_dict = True option to see datatypes as pyodbc returned them.
    """

    def dt_to_str(dt):
        return dt.isoformat()

    def bytes_to_hexstr(b):
        return str(b.hex())

    datatype_handlers = {
        datetime.datetime: dt_to_str,
        bytes: bytes_to_hexstr
    }

    cols = [c[0] for c in rows[0].cursor_description]
    j_data = []

    for row in rows:
        r_data = {}
        for c in cols:
            v = row.__getattribute__(c)
            f = datatype_handlers.get(type(v))

            if f is not None:
                v = f(v)

            if v is not None or keep_nulls is True:
                r_data.update({c: v})

        j_data.append(r_data)

    if return_dict is True:
        return j_data

    return json.dumps(j_data, sort_keys=True, indent=4)