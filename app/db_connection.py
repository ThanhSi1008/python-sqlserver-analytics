"""
Simple SQL Server database connection module.
Only used for connecting and reading data. Does NOT create/modify/delete databases.
"""

import os
import pymssql


def connect_to_database(database_name: str,
                       username: str = None,
                       password: str = None,
                       server: str = None,
                       port: int = None):
    """
    Connect to SQL Server database.

    Args:
        database_name (str): Database name to connect to (required)
        username (str): SQL Server username (defaults to .env)
        password (str): SQL Server password (defaults to .env)
        server (str): Server address (defaults to .env)
        port (int): Connection port (defaults to .env)

    Returns:
        pymssql.Connection: Database connection object

    Raises:
        Exception: If unable to connect to database
    """
    if not database_name:
        raise ValueError("database_name is a required parameter")

    # Read configuration from .env if not provided
    server = server or os.getenv('DB_SERVER', 'sqlserver')
    port = port or int(os.getenv('DB_PORT', '1433'))
    username = username or os.getenv('DB_USER', 'sa')
    password = password or os.getenv('DB_PASSWORD', 'YourStrong!Passw0rd')

    print(f"[INFO] Connecting to database: {database_name}")
    print(f"[INFO] Server: {server}:{port}")
    print(f"[INFO] User: {username}")

    try:
        # Create connection to SQL Server
        connection = pymssql.connect(
            server=server,
            port=port,
            user=username,
            password=password,
            database=database_name,
            timeout=30,
            login_timeout=30
        )

        print(f"[OK] Successfully connected to database: {database_name}")
        return connection

    except pymssql.OperationalError as e:
        error_msg = str(e)
        if "Cannot open database" in error_msg or "does not exist" in error_msg:
            print(f"[ERROR] Database '{database_name}' does not exist")
            print("[INFO] Please create database using Azure Data Studio:")
            print(f"[INFO]    CREATE DATABASE {database_name};")
        elif "Login failed" in error_msg:
            print(f"[ERROR] Login failed - check username/password")
        else:
            print(f"[ERROR] Connection error: {error_msg}")
        raise Exception(f"Unable to connect to database '{database_name}': {error_msg}")

    except Exception as e:
        print(f"[ERROR] Unknown error: {e}")
        raise Exception(f"Database connection error: {e}")


