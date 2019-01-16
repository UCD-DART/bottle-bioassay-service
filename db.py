import os
import psycopg2
import psycopg2.extras
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

__all__ = ['cursor', 'connection', 'session']

db_string = "postgresql://%s:%s@%s/%s" % (os.environ['DBUSER'],
                                          os.environ['DBPASS'],
                                          os.environ['DBHOST'],
                                          os.environ['DBNAME'])

connection = psycopg2.connect(db_string)
cursor = connection.cursor(cursor_factory=psycopg2.extras.DictCursor)

engine = create_engine(db_string)
session = sessionmaker(bind=engine)()
