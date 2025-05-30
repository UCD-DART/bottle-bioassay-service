FROM python:3.13-alpine
EXPOSE 3031

WORKDIR /app

COPY . .

RUN apk update \
    && apk add --no-cache \
        postgresql-dev \
        R-dev \ 
        R \
    && sh -c 'echo "install.packages(\"survival\", repos=\"https://cran.rstudio.com\")" | R --no-save' \
    && pip install -r requirements.txt

CMD [ "sh", "-c", \
        "uwsgi --http :3031 --wsgi service:app" ] 
