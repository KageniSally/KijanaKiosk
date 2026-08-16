# Use a lightweight official Python runtime base image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Copy dependency definitions and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your local application code into the container
COPY . .

# Expose the application port (matching your k8s containerPort config)
EXPOSE 3000

# Command to run the application
CMD ["python", "app.py"]
