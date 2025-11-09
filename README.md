# ETL Python Project

A robust ETL (Extract, Transform, Load) pipeline built with Python, designed to process data from multiple sources and load it into a PostgreSQL database.

## Project Structure

```
etl-python-project/
├── config/
│   ├── logging.yaml     # Logging configuration
│   └── settings.yaml    # ETL settings
├── logs/
│   └── etl.json        # JSON formatted logs
├── src/
│   ├── etl/
│   │   ├── extract/    # Data extraction modules
│   │   ├── transform/  # Transformation logic
│   │   └── load/       # Database loading modules
│   ├── config.py       # Configuration management
│   ├── logging_setup.py # Logging initialization
│   ├── main.py         # CLI entry point
│   └── models.py       # Pydantic data models
├── docker/
│   └── docker-compose.yml  # Docker services config
├── tests/              # Test files
├── .env               # Environment variables
├── .gitignore
├── Makefile           # Development commands
├── pyproject.toml     # Project metadata and dependencies
└── README.md          # This file
```


## Features

- **Multiple Data Sources**:
  - API data extraction (supports pagination)
  - File-based data import (CSV, JSON, XLSX, Parquet)
  - Database data extraction
  
- **Data Transformation**:
  - Data validation using Pydantic models
  - Email normalization
  - Name capitalization

- **Flexible Loading**:
  - Bulk copy mode for performance
  - Upsert mode for data updates
  - Configurable batch sizes

- **Robust Architecture**:
  - JSON logging with rotation
  - Configurable settings via YAML
  - Environment variable support
  - Automatic retries with exponential backoff
  - Rate limiting for API calls

## Prerequisites

- Python 3.10 or higher
- PostgreSQL database
- Docker (optional, for running PostgreSQL)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd etl-python-project
```

2. Create and activate a virtual environment:
```bash
make venv
source .venv/bin/activate
```

3. Install dependencies:
```bash
# For runtime dependencies only
make install

# For development dependencies (includes testing tools)
make install-dev
```

4. Set up the database:
```bash
# Using Docker
cd docker
docker-compose up -d
```

5. Database Table
```bash
# Run SQL query to create table
CREATE TABLE users (
    id serial PRIMARY KEY,
    email varchar(255),
    first_name varchar(50),
    last_name varchar(50),
    avatar varchar(255)
);
CREATE TABLE latest_users (LIKE users INCLUDING ALL);
```
## Configuration

### Environment Variables

Create a `.env` file with the following variables:
```env
POSTGRES_DSN=postgresql+psycopg2://postgres:postgres@localhost:5432/etl_db
API_BASE_URL=https://api.example.com
API_KEY=your-api-key  # If required
```

### Settings

Configure data sources and processing options in `config/settings.yaml`:
```yaml
run:
  batch_size: 100
  target_table: public.users

sources:
  file:
    path: "./data/users.csv"
  api:
    endpoint: "users"
    per_page: 50
  db:
    query: "SELECT * FROM source_table LIMIT :limit OFFSET :offset"
```

### Logging

Logging configuration in `config/logging.yaml`:
- JSON formatted logs
- Console and file output
- Log rotation (10MB files, keeps last 5)
- Logs stored in `logs/etl.json`

## Usage
```bash
# Clean temporary files and virtualenv
make clean

# See all available commands
make help
```
### Running the ETL Pipeline


1. **API Source** (Copy Mode):
```bash
make run-api
# or
python -m src.main --source api --load-mode copy
```
2. **API Source** (Upsert Mode):
```bash
make run-api-upsert
# or
python -m src.main --source api --load-mode upsert
```
3. ** Generate users data
```
make generate-users
# or
python src/generateusers.py
```

2. **File Source** (Copy Mode):
```bash
make run-file
# or
python -m src.main --source file --load-mode copy
```
3. **File Source** (Upsert Mode):
```bash
make run-file-upsert
# or
python -m src.main --source file --load-mode upsert
```
3. **Database Source** (Copy Mode):
```bash
make run-db
# or
python -m src.main --source db --load-mode copy
```
3. **Database Source** (Upsert Mode):
```bash
make run-db-upsert
# or
python -m src.main --source db --load-mode upsert
```
### Development Commands

```bash
# Clean temporary files and virtualenv
make clean

# See all available commands
make help
```


## Docker Support

Start the PostgreSQL database:
```bash
docker-compose -f docker/docker-compose.yml up -d postgres
```

Database will be available at:
- Host: localhost
- Port: 5432
- User: postgres
- Password: postgres
- Database: etl_db

## Error Handling

The pipeline includes:
- Automatic retries for API calls
- Rate limiting
- Transaction support for database operations
- Detailed error logging

## License

This project is licensed under the MIT License - see the LICENSE file for details.