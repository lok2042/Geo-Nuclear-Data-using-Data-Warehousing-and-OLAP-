import mysql.connector
import pycountry_convert as pc

config = {
    'user': 'root',
    'password': 'password',
    'host': 'localhost',
    'database': 'nuclear'
}

db = mysql.connector.connect(**config)
cursor = db.cursor()

# Fetch all country codes
sql = ("SELECT code FROM countries")
cursor.execute(sql)
country_codes = cursor.fetchall()

for country_code in country_codes:
    try:
        continent_code = pc.country_alpha2_to_continent_code(country_code[0])
    except:
        continent_code = None
    finally:
        sql = ("UPDATE countries SET continent_code = %s WHERE code = %s")
        cursor.execute(sql, (continent_code, country_code[0]))
        db.commit()
