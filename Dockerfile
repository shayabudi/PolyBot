FROM python:3.8.12-slim-buster
WORKDIR /PolyBot
COPY bot.py bot.py
COPY utils.py utils.py
COPY .telegramToken .telegramToken
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
CMD ["python3", "bot.py"]

