# Hướng dẫn sử dụng Jupyter Notebook với SQL Server

## 🚀 Bước 1: Truy cập Jupyter Notebook

### Cách 1: Sử dụng service Jupyter có sẵn
```bash
# Khởi động Jupyter service
docker-compose up jupyter

# Hoặc chạy tất cả services
docker-compose up -d
```

Sau đó mở trình duyệt và truy cập: **http://localhost:8888**

### Cách 2: Chạy Jupyter từ Python container
```bash
# Truy cập vào Python container
docker exec -it python_data_analysis bash

# Khởi động Jupyter Lab
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''
```

## 🔧 Bước 2: Thiết lập môi trường trong Notebook

### Cài đặt thư viện cần thiết (nếu chưa có)
```python
# Chạy trong notebook cell
!pip install sqlalchemy pandas matplotlib seaborn plotly
```

### Import các thư viện cần thiết
```python
import sys
sys.path.append('/app')

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
import warnings
warnings.filterwarnings('ignore')

# Import database helper
from db_connection import get_db_connection

# Thiết lập style cho biểu đồ
plt.style.use('default')
sns.set_palette("husl")
%matplotlib inline

print("✅ Đã import thành công tất cả thư viện!")
```

## 📊 Bước 3: Kết nối Database và khám phá dữ liệu

### Kết nối cơ sở dữ liệu
```python
# Kết nối đến SQL Server
db = get_db_connection()
print("✅ Đã kết nối thành công đến SQL Server!")

# Xem danh sách bảng
tables = db.get_table_info()
print("\n📋 Danh sách bảng trong database:")
display(tables)
```

### Tải dữ liệu từ các bảng
```python
# Tải dữ liệu từ tất cả các bảng
customers = db.query_to_dataframe("SELECT * FROM Customers")
products = db.query_to_dataframe("SELECT * FROM Products")
orders = db.query_to_dataframe("SELECT * FROM Orders")
order_details = db.query_to_dataframe("SELECT * FROM OrderDetails")

print("📊 Thông tin dữ liệu:")
print(f"Khách hàng: {len(customers)} records")
print(f"Sản phẩm: {len(products)} records")
print(f"Đơn hàng: {len(orders)} records")
print(f"Chi tiết đơn hàng: {len(order_details)} records")

# Hiển thị mẫu dữ liệu
print("\n👥 Mẫu dữ liệu khách hàng:")
display(customers.head())

print("\n🛍️ Mẫu dữ liệu sản phẩm:")
display(products.head())
```

## 📈 Bước 4: Phân tích dữ liệu chi tiết

### 1. Phân tích khách hàng mua nhiều nhất
```python
# Query phân tích khách hàng
customer_analysis_query = """
SELECT 
    c.CustomerName,
    c.City,
    COUNT(DISTINCT o.OrderID) as SoLuongDonHang,
    SUM(od.Quantity) as TongSoLuongSanPham,
    SUM(od.Quantity * p.Price) as TongGiaTriMuaHang,
    AVG(od.Quantity * p.Price) as GiaTriTrungBinhMoiDon
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
LEFT JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.City
ORDER BY TongGiaTriMuaHang DESC
"""

customer_analysis = db.query_to_dataframe(customer_analysis_query)
print("🏆 Top khách hàng mua nhiều nhất:")
display(customer_analysis)

# Biểu đồ doanh thu theo khách hàng
plt.figure(figsize=(12, 6))
plt.subplot(1, 2, 1)
sns.barplot(data=customer_analysis, x='TongGiaTriMuaHang', y='CustomerName')
plt.title('Doanh thu theo khách hàng')
plt.xlabel('Tổng giá trị mua hàng ($)')

plt.subplot(1, 2, 2)
city_revenue = customer_analysis.groupby('City')['TongGiaTriMuaHang'].sum()
plt.pie(city_revenue.values, labels=city_revenue.index, autopct='%1.1f%%')
plt.title('Doanh thu theo thành phố')

plt.tight_layout()
plt.show()
```

### 2. Phân tích sản phẩm bán chạy nhất
```python
# Query phân tích sản phẩm
product_analysis_query = """
SELECT 
    p.ProductName,
    p.Category,
    p.Price,
    SUM(od.Quantity) as TongSoLuongBan,
    SUM(od.Quantity * p.Price) as TongDoanhThu,
    COUNT(DISTINCT od.OrderID) as SoLuongDonHang,
    AVG(od.Quantity) as SoLuongTrungBinhMoiDon
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category, p.Price
ORDER BY TongDoanhThu DESC
"""

product_analysis = db.query_to_dataframe(product_analysis_query)
print("🛍️ Phân tích sản phẩm bán chạy:")
display(product_analysis)

# Biểu đồ phân tích sản phẩm
fig, axes = plt.subplots(2, 2, figsize=(15, 12))

# Doanh thu theo sản phẩm
sns.barplot(data=product_analysis, x='TongDoanhThu', y='ProductName', ax=axes[0,0])
axes[0,0].set_title('Doanh thu theo sản phẩm')
axes[0,0].set_xlabel('Tổng doanh thu ($)')

# Số lượng bán theo sản phẩm
sns.barplot(data=product_analysis, x='TongSoLuongBan', y='ProductName', ax=axes[0,1])
axes[0,1].set_title('Số lượng bán theo sản phẩm')
axes[0,1].set_xlabel('Tổng số lượng bán')

# Doanh thu theo danh mục
category_revenue = product_analysis.groupby('Category')['TongDoanhThu'].sum()
axes[1,0].pie(category_revenue.values, labels=category_revenue.index, autopct='%1.1f%%')
axes[1,0].set_title('Doanh thu theo danh mục sản phẩm')

# Giá vs Số lượng bán
sns.scatterplot(data=product_analysis, x='Price', y='TongSoLuongBan', 
                hue='Category', size='TongDoanhThu', ax=axes[1,1])
axes[1,1].set_title('Mối quan hệ giá và số lượng bán')
axes[1,1].set_xlabel('Giá ($)')
axes[1,1].set_ylabel('Tổng số lượng bán')

plt.tight_layout()
plt.show()
```

### 3. Phân tích xu hướng bán hàng theo thời gian
```python
# Query phân tích theo thời gian
time_analysis_query = """
SELECT 
    o.OrderDate,
    COUNT(o.OrderID) as SoLuongDonHang,
    SUM(od.Quantity) as TongSoLuongSanPham,
    SUM(od.Quantity * p.Price) as DoanhThuNgay,
    AVG(od.Quantity * p.Price) as GiaTriTrungBinhDon
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderDate
ORDER BY o.OrderDate
"""

time_analysis = db.query_to_dataframe(time_analysis_query)
print("📅 Phân tích xu hướng theo thời gian:")
display(time_analysis)

# Biểu đồ xu hướng thời gian
plt.figure(figsize=(15, 8))

plt.subplot(2, 2, 1)
plt.plot(time_analysis['OrderDate'], time_analysis['DoanhThuNgay'], marker='o')
plt.title('Doanh thu theo ngày')
plt.xlabel('Ngày')
plt.ylabel('Doanh thu ($)')
plt.xticks(rotation=45)

plt.subplot(2, 2, 2)
plt.plot(time_analysis['OrderDate'], time_analysis['SoLuongDonHang'], marker='s', color='orange')
plt.title('Số lượng đơn hàng theo ngày')
plt.xlabel('Ngày')
plt.ylabel('Số đơn hàng')
plt.xticks(rotation=45)

plt.subplot(2, 2, 3)
plt.plot(time_analysis['OrderDate'], time_analysis['GiaTriTrungBinhDon'], marker='^', color='green')
plt.title('Giá trị trung bình đơn hàng')
plt.xlabel('Ngày')
plt.ylabel('Giá trị TB ($)')
plt.xticks(rotation=45)

plt.subplot(2, 2, 4)
plt.bar(time_analysis['OrderDate'], time_analysis['TongSoLuongSanPham'], color='red', alpha=0.7)
plt.title('Tổng số lượng sản phẩm bán')
plt.xlabel('Ngày')
plt.ylabel('Số lượng sản phẩm')
plt.xticks(rotation=45)

plt.tight_layout()
plt.show()
```

## 🎯 Bước 5: Phân tích nâng cao với Plotly

### Biểu đồ tương tác với Plotly
```python
# Tạo dashboard tương tác
fig = make_subplots(
    rows=2, cols=2,
    subplot_titles=('Doanh thu theo khách hàng', 'Sản phẩm bán chạy', 
                   'Doanh thu theo danh mục', 'Xu hướng theo thời gian'),
    specs=[[{"type": "bar"}, {"type": "bar"}],
           [{"type": "pie"}, {"type": "scatter"}]]
)

# Doanh thu theo khách hàng
fig.add_trace(
    go.Bar(x=customer_analysis['TongGiaTriMuaHang'], 
           y=customer_analysis['CustomerName'],
           orientation='h',
           name='Doanh thu KH'),
    row=1, col=1
)

# Sản phẩm bán chạy
fig.add_trace(
    go.Bar(x=product_analysis['TongSoLuongBan'], 
           y=product_analysis['ProductName'],
           orientation='h',
           name='Số lượng bán'),
    row=1, col=2
)

# Doanh thu theo danh mục
category_revenue = product_analysis.groupby('Category')['TongDoanhThu'].sum()
fig.add_trace(
    go.Pie(labels=category_revenue.index, 
           values=category_revenue.values,
           name="Danh mục"),
    row=2, col=1
)

# Xu hướng thời gian
fig.add_trace(
    go.Scatter(x=time_analysis['OrderDate'], 
               y=time_analysis['DoanhThuNgay'],
               mode='lines+markers',
               name='Doanh thu'),
    row=2, col=2
)

fig.update_layout(height=800, showlegend=True, 
                  title_text="Dashboard Phân tích Bán hàng")
fig.show()
```

## 💾 Bước 6: Lưu kết quả phân tích

```python
# Lưu kết quả phân tích ra file
customer_analysis.to_csv('/app/data/customer_analysis.csv', index=False)
product_analysis.to_csv('/app/data/product_analysis.csv', index=False)
time_analysis.to_csv('/app/data/time_analysis.csv', index=False)

print("✅ Đã lưu kết quả phân tích vào thư mục /app/data/")

# Đóng kết nối database
db.close()
print("🔌 Đã đóng kết nối database")
```

## 🔧 Các lệnh hữu ích

### Khởi động lại Jupyter
```bash
# Nếu Jupyter bị lỗi, restart container
docker-compose restart jupyter

# Hoặc truy cập container và chạy lại
docker exec -it python_data_analysis jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
```

### Cài đặt thêm thư viện
```python
# Trong notebook
!pip install plotly dash streamlit openpyxl xlsxwriter
```

### Xuất notebook ra PDF/HTML
```python
# Trong notebook
!jupyter nbconvert --to html your_notebook.ipynb
!jupyter nbconvert --to pdf your_notebook.ipynb
```
