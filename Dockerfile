FROM python:3.8-slim-buster

# Set the working directory to /app
WORKDIR /app

# Copy the requirements.txt file to the container
COPY requirements.txt .

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

#Run the command to start the bot

CMD ["python3", "bot.py"]
