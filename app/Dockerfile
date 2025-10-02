# Dockerfile for Python Data Analysis Environment

FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies for SQL Server connectivity and data analysis
RUN apt-get update && apt-get install -y \
    # SQL Server dependencies
    gcc \
    g++ \
    unixodbc-dev \
    freetds-dev \
    # Additional utilities
    curl \
    wget \
    git \
    vim \
    nano \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages for data analysis and SQL Server connectivity
RUN pip install --no-cache-dir \
    # SQL Server connectivity
    pymssql \
    pyodbc \
    sqlalchemy \
    # Data analysis and visualization
    pandas \
    numpy \
    matplotlib \
    seaborn \
    plotly \
    scipy \
    scikit-learn \
    # Development tools
    jupyter \
    jupyterlab \
    ipykernel \
    watchdog \
    # Additional useful packages
    requests \
    openpyxl \
    xlsxwriter \
    python-dotenv

# Set working directory
WORKDIR /app

# Default command (can be overridden in docker-compose.yml)
CMD ["python", "-c", "print('Python data analysis environment ready!'); import time; time.sleep(3600)"]
