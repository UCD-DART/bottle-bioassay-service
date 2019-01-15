import configparser
import psycopg2
import psycopg2.extras
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

__all__ = ['cursor', 'connection', 'session']

config = configparser.ConfigParser()
config.read('credentials.conf')
db_string = "postgresql://%s:%s@%s/%s" % (config.get('db', 'user'),
                                        config.get('db', 'pass'),
                                        config.get('db', 'host'),
                                        config.get('db', 'dbname'))

connection = psycopg2.connect(db_string)
cursor = connection.cursor(cursor_factory=psycopg2.extras.DictCursor)

engine = create_engine(db_string)
session = sessionmaker(bind=engine)()
