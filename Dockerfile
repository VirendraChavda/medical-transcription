# Use an official Python image as the base image
FROM python:3.10

# Set environment variables to prevent Python from generating .pyc files
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Install system dependencies for PyAudio and other packages
RUN apt-get update && apt-get install -y \
    build-essential \
    libffi-dev \
    libssl-dev \
    libjpeg-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    portaudio19-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file to the container
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code to the container
COPY . /app

# Expose port 5000 for Flask to run on
EXPOSE 5000

# Run the application using Gunicorn as the server, with 4 workers
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8080", "app:app"]
