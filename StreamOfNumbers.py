import psycopg2
import hidden
import time

secrets = hidden.secrets()
conn = psycopg2.connect(host=secrets['host'], port=secrets['port'], database=secrets['database'], user=secrets['user'], password=secrets['pass'], connect_timeout=3)

cur = conn.cursor()

sql = 'DROP TABLE IF EXISTS pythonseq CASCADE;'
print(sql)
cur.execute(sql)

sql = 'CREATE TABLE pythonseq (iter INTEGER, val INTEGER);'
print(sql)
cur.execute(sql)

conn.commit()

number = 293200
for i in range(300):
    print(i+1, number)
    sql = 'INSERT INTO pythonseq (iter, val) VALUES (%s, %s);'
    cur.execute(sql, (i+1, number))
    if (i+1) % 50 == 0: conn.commit()
    number = int((number * 22) / 7) % 1000000
    
conn.commit()


sql = 'select * from pythonseq limit 20'
cur.execute(sql)
conn.commit()
cur.close()
    