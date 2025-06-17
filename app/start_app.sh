#!/bin/bash

echo "🔄 Activating virtual environment and running the app..."

cd "$(dirname "$0")"

source venv/bin/activate

export DATABASE_URL="postgresql://postgres:postgres@localhost:5432/appdb"

python run.py
