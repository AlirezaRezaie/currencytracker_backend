# Use the official Python image as a parent image
FROM python:3.10.12

# Set the working directory in the container
WORKDIR /app

RUN apt-get update && \
    apt-get install -y locales && \
    sed -i -e 's/# fa_IR.UTF-8 UTF-8/fa_IR.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    locale-gen fa_IR.UTF-8

ENV LANG fa_IR.UTF-8
ENV LC_ALL fa_IR.UTF-8

# Copy the requirements file into the container
COPY requirements.txt .

# Create and activate a virtual environment
RUN python -m venv venv
RUN . venv/bin/activate

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Copy the rest of your app's source code into the container
COPY . .

# Expose the port your FastAPI app will run on (usually 8000)
EXPOSE 8000

# Define the command to run your FastAPI app
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]
