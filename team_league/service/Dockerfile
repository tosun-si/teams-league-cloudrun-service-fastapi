FROM python:3.10-slim

ENV PYTHONUNBUFFERED True

COPY team_league/service/requirements.txt ./

RUN pip install -r requirements.txt

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY team_league $APP_HOME/team_league

CMD ["uvicorn", "team_league.service.main:app", "--host", "0.0.0.0", "--port", "8080"]
