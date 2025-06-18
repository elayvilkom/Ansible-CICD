# Use official Python image
FROM python:3.11-slim

# Create a system user named 'appuser'
RUN useradd --system --create-home appuser

# Set working directory
WORKDIR /home/appuser/app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire application code
COPY . .

# Set environment variables (optional)
ENV FLASK_APP=run.py
ENV PYTHONUNBUFFERED=1
ENV export DATABASE_URL="postgresql://dbuser:123456@172.22.73.146:5432/dbapp"

# Copy default config file (if exists)
RUN cp configuration_example.py configuration.py || true

# Change ownership of the working directory
RUN chown -R appuser:appuser /home/appuser/app

# Use the new user
USER appuser

# Start the application
CMD ["python", "run.py"]
