# Simple Database Connection Module

## Installation and Usage

### 1. Start containers
```bash
docker-compose up -d
```

### 2. Use the module
```python
from db_connection import connect_to_database

# Connect to database
conn = connect_to_database('database_name')

# Work with database
cursor = conn.cursor()
cursor.execute("SELECT COUNT(*) FROM Products")
result = cursor.fetchone()

# Close connection
cursor.close()
conn.close()
```

## Configuration

### .env File
```env
# Database Connection
DB_SERVER=sqlserver
DB_PORT=1433
DB_USER=sa
DB_PASSWORD=YourStrong!Passw0rd

# SQL Server Configuration
ACCEPT_EULA=Y
SA_PASSWORD=YourStrong!Passw0rd
MSSQL_PID=Developer
MSSQL_TCP_PORT=1433
SQL_SERVER_HOST_PORT=1433
```

**Note:** No need for `DB_NAME` variable anymore since database name is passed directly to the function.

## Project Structure

```
statistics-docker/
├── .env                    # Environment configuration
├── docker-compose.yml     # Docker services definition
├── README.md              # This file
├── app/                   # Python code
│   ├── Dockerfile         # Docker image for Python
│   └── db_connection.py   # Database connection module
└── notebooks/             # Jupyter notebooks
    └── database_connection_example.ipynb  # Example notebook
```

## API Reference

### `connect_to_database(database_name, username=None, password=None, server=None, port=None)`

Connect to SQL Server database.

**Parameters:**
- `database_name` (str): Database name to connect to (required)
- `username` (str): SQL Server username (defaults to .env)
- `password` (str): SQL Server password (defaults to .env)
- `server` (str): Server address (defaults to .env)
- `port` (int): Connection port (defaults to .env)

**Returns:**
- `pymssql.Connection`: Database connection object

**Examples:**
```python
# Use configuration from .env
conn = connect_to_database('database_name')

# Or specify connection details
conn = connect_to_database(
    database_name='database_name',
    server='localhost',
    port=1433,
    username='sa',
    password='my_password'
)
```

## Use in Jupyter Notebooks
```python
# In a Jupyter notebook cell
from db_connection import connect_to_database
import pandas as pd

# Connect and read data into DataFrame
conn = connect_to_database('database_name')
df = pd.read_sql("SELECT * FROM sys.tables", conn)
print(df)
conn.close()
```

**Note**: The `db_connection` module is automatically available in Jupyter notebooks because the `/app` directory (containing `db_connection.py`) is mounted and set as the working directory.

## Docker Services

### SQL Server
- **Container**: `sqlserver_data_analysis`
- **Port**: `1433`
- **Username**: `sa`
- **Password**: From `.env` file

### Python App
- **Container**: `python_data_analysis`
- **Libraries**: pymssql, pandas, numpy

### Jupyter Lab
- **Container**: `jupyter_data_analysis`
- **URL**: http://localhost:8888
- **Features**: Interactive notebooks with database access

## Testing and Debug

### Access Jupyter Lab
```bash
# Start all services
docker-compose up -d

# Open Jupyter Lab in your browser
open http://localhost:8888
```

### Test specific connection
```bash
docker-compose exec python-app python -c "
from db_connection import connect_to_database
conn = connect_to_database('database_name')
print('Connection successful!')
conn.close()
"
```

### Check containers
```bash
# View container status
docker-compose ps

# View SQL Server logs
docker-compose logs sqlserver

# Enter Python container
docker-compose exec python-app bash
```

## Create Database

Use Azure Data Studio to create databases:

1. **Connect to SQL Server**:
   - Server: `localhost,1433`
   - Username: `sa`
   - Password: `YourStrong!Passw0rd`

2. **Create databases**:
   ```sql
   CREATE DATABASE database_name;
   CREATE DATABASE StudentDB;
   ```

## Important Notes

- **READ-ONLY**: This module is ONLY for reading data
- **NO CREATE**: Does not automatically create databases or tables
- **NO MODIFY**: No data modification functionality
- **NO DELETE**: No data deletion functionality

## Quick Start

```bash
# 1. Start services
docker-compose up -d

# 2. Open Jupyter Lab
open http://localhost:8888

# 3. Test connection in terminal
docker-compose exec python-app python -c "
from db_connection import connect_to_database
conn = connect_to_database('database_name')
print('Ready to work!')
conn.close()
"
```

**Module ready to use!** 

### Getting Started with Jupyter Lab

1. **Start the services**: `docker-compose up -d`
2. **Open Jupyter Lab**: Navigate to http://localhost:8888 in your browser
3. **Open the example notebook**: `notebooks/database_connection_example.ipynb`
4. **Create databases**: Use Azure Data Studio to create your databases first
5. **Start analyzing**: Use the `connect_to_database()` function in your notebooks
