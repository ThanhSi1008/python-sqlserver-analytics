import pymssql
import time

server = "sqlserver"
port = 1433
user = "sa"
password = "YourStrong!Passw0rd"
database = "ShopDB"

while True:
    try:
        conn = pymssql.connect(server=server, port=port, user=user, password=password, autocommit=True)
        print("Connected to SQL Server!")
        break
    except pymssql.OperationalError:
        print("SQL Server chưa sẵn sàng, retry sau 5s...")
        time.sleep(5)

cursor = conn.cursor()

with open("data-script.sql", "r") as f:
    sql_script = f.read()

for statement in sql_script.split("GO"):
    stmt = statement.strip()
    if stmt:
        try:
            cursor.execute(stmt)
        except pymssql.DatabaseError as e:
            print("Lỗi khi chạy câu lệnh, bỏ qua:", e)

cursor.execute("SELECT * FROM Customers;")
rows = cursor.fetchall()
print("Customers:")
for row in rows:
    print(row)

conn.close()
