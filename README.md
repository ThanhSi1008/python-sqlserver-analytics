# Python + SQL Server Data Analysis Environment

A Docker-based development environment for data analysis using Python and SQL Server.

## 🚀 Quick Start

1. **Start the environment:**
   ```bash
   docker-compose up -d
   ```

2. **Access the Python container for interactive development:**
   ```bash
   docker exec -it python_data_analysis bash
   ```

3. **Run the test script:**
   ```bash
   docker exec -it python_data_analysis python test.py
   ```

4. **Access Jupyter Lab:**
   Open **http://localhost:8888** in your browser

## 📚 Jupyter Notebooks Available

### 🎯 Ready-to-use Analysis Notebooks:

1. **01_Database_Connection_and_Basic_Analysis.ipynb**
   - Database connection and exploration
   - Basic customer and product analysis
   - Data visualization with matplotlib/seaborn

2. **02_Advanced_Sales_Analysis.ipynb**
   - VIP customer analysis
   - Product performance analysis
   - Time-based sales trends
   - Customer segmentation (RFM Analysis)

3. **03_Interactive_Dashboard_with_Plotly.ipynb**
   - Interactive dashboards with Plotly
   - 3D visualizations and treemaps
   - Heatmaps and correlation analysis
   - Export to HTML dashboards

### 📖 Documentation:
- **JUPYTER_GUIDE.md** - Comprehensive Vietnamese guide
- **JUPYTER_QUICKSTART.md** - Quick start guide with examples

## 🏗️ Architecture

### Services

- **sqlserver**: SQL Server 2022 Developer Edition
  - Port: 1433
  - SA Password: `YourStrong!Passw0rd`
  - Database: `ShopDB`
  - Data persistence via Docker volumes

- **python-app**: Python 3.11 with data analysis packages
  - Live code reloading via volume mounts
  - Pre-installed packages: pandas, numpy, matplotlib, seaborn, pymssql, sqlalchemy
  - Interactive development ready

- **jupyter** (optional): Jupyter Lab for notebook-based analysis
  - Port: 8888
  - No authentication required (development only)

### Network
All containers communicate via the `data-analysis-network` bridge network.

## 📁 Directory Structure

```
.
├── app/                    # Python application code
│   ├── Dockerfile         # Python container definition
│   ├── test.py           # Sample test script
│   ├── db_connection.py  # Database helper utilities
│   └── data-script.sql   # Database initialization
├── data/                  # Data files (mounted to containers)
├── notebooks/            # Jupyter notebooks
├── scripts/              # Additional Python scripts
└── docker-compose.yml    # Docker Compose configuration
```

## 🔧 Development Workflow

### 1. Interactive Python Development

```bash
# Enter the Python container
docker exec -it python_data_analysis bash

# Run Python interactively
python

# Or run specific scripts
python your_script.py
```

### 2. Database Connection

Use the provided `db_connection.py` helper:

```python
from db_connection import get_db_connection
import pandas as pd

# Connect to database
db = get_db_connection()

# Query data into DataFrame
df = db.query_to_dataframe("SELECT * FROM Customers")
print(df.head())

# Close connection
db.close()
```

### 3. Direct SQL Server Access

Connect from your host machine or other tools:
- **Host**: localhost
- **Port**: 1433
- **User**: sa
- **Password**: YourStrong!Passw0rd
- **Database**: ShopDB

### 4. Jupyter Notebooks

1. Start Jupyter service: `docker-compose up jupyter`
2. Open http://localhost:8888
3. Create notebooks in the `/notebooks` directory

## 📦 Pre-installed Python Packages

### Database Connectivity
- `pymssql` - SQL Server driver
- `pyodbc` - ODBC database connectivity
- `sqlalchemy` - SQL toolkit and ORM

### Data Analysis
- `pandas` - Data manipulation and analysis
- `numpy` - Numerical computing
- `scipy` - Scientific computing
- `scikit-learn` - Machine learning

### Visualization
- `matplotlib` - Plotting library
- `seaborn` - Statistical visualization
- `plotly` - Interactive visualizations

### Development Tools
- `jupyter` / `jupyterlab` - Interactive notebooks
- `watchdog` - File system monitoring
- `python-dotenv` - Environment variable management

## 🔄 Live Code Reloading

The Python container automatically reflects changes made to files in the `./app` directory without requiring container rebuilds.

## 🗄️ Data Persistence

- SQL Server data is persisted in Docker volumes
- Your code changes are immediately reflected via volume mounts
- Database survives container restarts

## 🛠️ Useful Commands

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f python-app
docker-compose logs -f sqlserver

# Stop all services
docker-compose down

# Rebuild Python container (after Dockerfile changes)
docker-compose build python-app

# Access SQL Server directly
docker exec -it sqlserver_data_analysis /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'YourStrong!Passw0rd'

# Run a one-off Python command
docker-compose run --rm python-app python -c "import pandas as pd; print(pd.__version__)"
```

## 🔧 Environment Variables

The following environment variables are available in the Python container:

- `DB_SERVER=sqlserver`
- `DB_PORT=1433`
- `DB_USER=sa`
- `DB_PASSWORD=YourStrong!Passw0rd`
- `DB_NAME=ShopDB`
- `PYTHONUNBUFFERED=1`
- `DEVELOPMENT_MODE=true`

## 📊 Sample Data

The environment includes sample data with the following tables:
- `Customers` - Customer information
- `Products` - Product catalog
- `Orders` - Order records
- `OrderDetails` - Order line items

## 🚨 Security Note

This setup is designed for development only. The SQL Server uses a default password and has no authentication on Jupyter. Do not use in production environments.
