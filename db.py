import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

__all__ = ['cursor', 'connection', 'session']

db_string = "postgresql://%s:%s@%s/%s" % (os.environ['DBUSER'],
                                          os.environ['DBPASS'],
                                          os.environ['DBHOST'],
                                          os.environ['DBNAME'])

engine = create_engine(db_string)


class SessionManager(object):
    def __init__(self):
        self.session = sessionmaker(bind=engine)()
