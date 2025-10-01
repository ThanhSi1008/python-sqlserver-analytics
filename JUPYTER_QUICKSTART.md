# 🚀 Hướng dẫn Nhanh sử dụng Jupyter Notebook với SQL Server

## ✅ Kiểm tra Trạng thái Hệ thống

Trước tiên, hãy kiểm tra tất cả containers đang chạy:

```bash
docker-compose ps
```

Bạn sẽ thấy 3 containers:
- ✅ `sqlserver_data_analysis` - SQL Server (port 1433)
- ✅ `python_data_analysis` - Python container
- ✅ `jupyter_data_analysis` - Jupyter Lab (port 8888)

## 🌐 Truy cập Jupyter Lab

### Cách 1: Mở trình duyệt
Mở trình duyệt và truy cập: **http://localhost:8888**

### Cách 2: Sử dụng lệnh
```bash
# Mở Jupyter Lab trong trình duyệt mặc định
open http://localhost:8888  # macOS
# hoặc
xdg-open http://localhost:8888  # Linux
```

## 📚 Notebooks Có sẵn

Trong thư mục `notebooks/`, bạn sẽ tìm thấy 3 notebooks đã được chuẩn bị:

### 1. **01_Database_Connection_and_Basic_Analysis.ipynb**
- 🔌 Kết nối cơ sở dữ liệu
- 📊 Khám phá cấu trúc dữ liệu
- 📈 Phân tích cơ bản về khách hàng và sản phẩm
- 💾 Lưu dữ liệu để phân tích tiếp

### 2. **02_Advanced_Sales_Analysis.ipynb**
- 🏆 Phân tích khách hàng VIP
- 🛍️ Phân tích sản phẩm bán chạy
- 📅 Xu hướng bán hàng theo thời gian
- 🎯 Phân đoạn khách hàng (RFM Analysis)

### 3. **03_Interactive_Dashboard_with_Plotly.ipynb**
- 📊 Dashboard tương tác với Plotly
- 🛍️ Biểu đồ bubble và sunburst
- 👥 Treemap và scatter 3D
- 🔥 Heatmap và correlation analysis

## 🎯 Bắt đầu Nhanh - 5 phút

### Bước 1: Mở Jupyter Lab
```bash
# Truy cập http://localhost:8888
```

### Bước 2: Chạy Notebook đầu tiên
1. Mở `notebooks/01_Database_Connection_and_Basic_Analysis.ipynb`
2. Chạy từng cell bằng cách nhấn `Shift + Enter`
3. Xem kết quả phân tích cơ bản

### Bước 3: Khám phá dữ liệu
```python
# Code mẫu để bắt đầu nhanh
import sys
sys.path.append('/app')
from db_connection import get_db_connection
import pandas as pd

# Kết nối database
db = get_db_connection()

# Truy vấn dữ liệu
customers = db.query_to_dataframe("SELECT * FROM Customers")
print(f"Có {len(customers)} khách hàng")
customers.head()
```

## 📊 Các Truy vấn Mẫu Hữu ích

### 1. Top khách hàng mua nhiều nhất
```sql
SELECT 
    c.CustomerName,
    c.City,
    SUM(od.Quantity * p.Price) as TotalRevenue
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, c.City
ORDER BY TotalRevenue DESC
```

### 2. Sản phẩm bán chạy nhất
```sql
SELECT 
    p.ProductName,
    p.Category,
    SUM(od.Quantity) as TotalSold,
    SUM(od.Quantity * p.Price) as Revenue
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY Revenue DESC
```

### 3. Doanh thu theo ngày
```sql
SELECT 
    o.OrderDate,
    COUNT(o.OrderID) as OrderCount,
    SUM(od.Quantity * p.Price) as DailyRevenue
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY o.OrderDate
ORDER BY o.OrderDate
```

## 🎨 Tạo Biểu đồ Nhanh

### Biểu đồ cơ bản với Matplotlib
```python
import matplotlib.pyplot as plt
import seaborn as sns

# Doanh thu theo thành phố
city_revenue = df.groupby('City')['Revenue'].sum()
plt.figure(figsize=(10, 6))
city_revenue.plot(kind='bar')
plt.title('Doanh thu theo thành phố')
plt.show()
```

### Biểu đồ tương tác với Plotly
```python
import plotly.express as px

# Bubble chart
fig = px.scatter(df, x='Price', y='Quantity', 
                size='Revenue', color='Category',
                hover_name='ProductName',
                title='Phân tích Sản phẩm')
fig.show()
```

## 🔧 Các Lệnh Hữu ích

### Quản lý Containers
```bash
# Xem logs Jupyter
docker logs jupyter_data_analysis

# Restart Jupyter nếu cần
docker-compose restart jupyter

# Truy cập Python container
docker exec -it python_data_analysis bash

# Kiểm tra kết nối SQL Server
docker exec -it python_data_analysis python -c "from db_connection import get_db_connection; db = get_db_connection(); print('✅ Connected!')"
```

### Cài đặt thêm thư viện
```python
# Trong notebook
!pip install plotly dash streamlit openpyxl

# Hoặc trong terminal
docker exec -it python_data_analysis pip install package_name
```

## 📁 Cấu trúc Thư mục

```
/app/
├── data/                    # Dữ liệu CSV và kết quả phân tích
├── notebooks/               # Jupyter notebooks
├── scripts/                 # Python scripts
├── output/                  # Kết quả xuất ra
├── db_connection.py         # Helper kết nối database
└── test.py                  # Script test kết nối
```

## 🚨 Xử lý Sự cố

### Jupyter không mở được
```bash
# Kiểm tra container
docker-compose ps

# Restart Jupyter
docker-compose restart jupyter

# Xem logs
docker logs jupyter_data_analysis
```

### Lỗi kết nối Database
```bash
# Kiểm tra SQL Server
docker exec sqlserver_data_analysis /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd' -Q 'SELECT 1' -C

# Test từ Python container
docker exec python_data_analysis python test.py
```

### Jupyter chạy chậm
```bash
# Tăng memory cho Docker Desktop
# Settings > Resources > Memory > 4GB+

# Hoặc restart containers
docker-compose down && docker-compose up -d
```

## 🎯 Mục tiêu Phân tích

Với môi trường này, bạn có thể:

1. **📊 Phân tích Doanh thu**: Theo thời gian, sản phẩm, khách hàng
2. **👥 Phân đoạn Khách hàng**: RFM analysis, customer lifetime value
3. **🛍️ Tối ưu Sản phẩm**: Sản phẩm bán chạy, cross-selling
4. **📈 Dự báo**: Xu hướng bán hàng, seasonal patterns
5. **🎨 Visualization**: Dashboard tương tác, reports

## 🔗 Tài nguyên Tham khảo

- **Pandas**: https://pandas.pydata.org/docs/
- **Plotly**: https://plotly.com/python/
- **Seaborn**: https://seaborn.pydata.org/
- **SQL Server**: https://docs.microsoft.com/en-us/sql/

---

🎉 **Chúc bạn phân tích dữ liệu thành công!** 

Nếu gặp vấn đề, hãy kiểm tra logs hoặc restart containers. Môi trường này được thiết kế để phát triển và học tập, dữ liệu sẽ được tái tạo mỗi khi restart containers.
