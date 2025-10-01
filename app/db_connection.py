"""
Database connection helper for SQL Server
Provides easy connection management for data analysis tasks
"""

import os
import pymssql
import pandas as pd
from sqlalchemy import create_engine
import time
from typing import Optional, Any, Dict


class SQLServerConnection:
    """Helper class for managing SQL Server connections"""
    
    def __init__(self, 
                 server: str = None, 
                 port: int = None,
                 user: str = None, 
                 password: str = None, 
                 database: str = None):
        """
        Initialize connection parameters
        Uses environment variables as defaults if not provided
        """
        self.server = server or os.getenv('DB_SERVER', 'sqlserver')
        self.port = port or int(os.getenv('DB_PORT', '1433'))
        self.user = user or os.getenv('DB_USER', 'sa')
        self.password = password or os.getenv('DB_PASSWORD', 'YourStrong!Passw0rd')
        self.database = database or os.getenv('DB_NAME', 'ShopDB')
        
        self.connection = None
        self.engine = None
    
    def connect(self, max_retries: int = 10, retry_delay: int = 5) -> bool:
        """
        Establish connection to SQL Server with retry logic
        Returns True if successful, False otherwise
        """
        for attempt in range(max_retries):
            try:
                self.connection = pymssql.connect(
                    server=self.server,
                    port=self.port,
                    user=self.user,
                    password=self.password,
                    database=self.database,
                    autocommit=True
                )
                print(f"✅ Connected to SQL Server: {self.server}:{self.port}/{self.database}")
                return True
            except pymssql.OperationalError as e:
                print(f"❌ Connection attempt {attempt + 1}/{max_retries} failed: {e}")
                if attempt < max_retries - 1:
                    print(f"⏳ Retrying in {retry_delay} seconds...")
                    time.sleep(retry_delay)
        
        print("❌ Failed to connect to SQL Server after all retries")
        return False
    
    def get_sqlalchemy_engine(self):
        """Get SQLAlchemy engine for pandas integration"""
        if not self.engine:
            connection_string = (
                f"mssql+pymssql://{self.user}:{self.password}@"
                f"{self.server}:{self.port}/{self.database}"
            )
            self.engine = create_engine(connection_string)
        return self.engine
    
    def execute_query(self, query: str) -> list:
        """Execute a query and return results"""
        if not self.connection:
            raise Exception("Not connected to database. Call connect() first.")
        
        cursor = self.connection.cursor()
        cursor.execute(query)
        results = cursor.fetchall()
        cursor.close()
        return results
    
    def query_to_dataframe(self, query: str) -> pd.DataFrame:
        """Execute query and return results as pandas DataFrame"""
        engine = self.get_sqlalchemy_engine()
        return pd.read_sql(query, engine)
    
    def get_table_info(self, table_name: str = None) -> pd.DataFrame:
        """Get information about tables in the database"""
        if table_name:
            query = f"""
            SELECT 
                COLUMN_NAME,
                DATA_TYPE,
                IS_NULLABLE,
                COLUMN_DEFAULT
            FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_NAME = '{table_name}'
            ORDER BY ORDINAL_POSITION
            """
        else:
            query = """
            SELECT 
                TABLE_NAME,
                TABLE_TYPE
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_TYPE = 'BASE TABLE'
            ORDER BY TABLE_NAME
            """
        
        return self.query_to_dataframe(query)
    
    def close(self):
        """Close the database connection"""
        if self.connection:
            self.connection.close()
            print("🔌 Database connection closed")


# Convenience function for quick connections
def get_db_connection() -> SQLServerConnection:
    """Get a database connection using environment variables"""
    db = SQLServerConnection()
    if db.connect():
        return db
    else:
        raise Exception("Failed to connect to database")


# Example usage
if __name__ == "__main__":
    # Test the connection
    db = SQLServerConnection()
    
    if db.connect():
        # Show available tables
        print("\n📊 Available tables:")
        tables = db.get_table_info()
        print(tables)
        
        # Example query
        print("\n👥 Sample customers data:")
        customers = db.query_to_dataframe("SELECT TOP 5 * FROM Customers")
        print(customers)
        
        db.close()
    else:
        print("Failed to establish database connection")
