from python:3.6-alpine

EXPOSE 3031

RUN mkdir /app \
    && addgroup -S uwsgi \
    && adduser -S -h /app -G uwsgi uwsgi \
    && chown uwsgi:uwsgi /app -R \
    && chmod g+w /app -R \
    && apk update \
    && apk add --no-cache \
        uwsgi-python3 \
        gcc \
        musl-dev \
        postgresql-dev \  
    && pip install pipenv 

USER uwsgi
WORKDIR /app
COPY . .
RUN pipenv install
CMD [ "sh", "-c", \
        "uwsgi --socket 0.0.0.0:3031 --uid uwsgi --plugins python3 --protocol uwsgi --wsgi service:__main__ --venv $(pipenv --venv)" ] 
