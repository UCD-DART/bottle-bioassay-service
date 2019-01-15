import db
from . import BottleTest
from sqlalchemy.orm.exc import NoResultFound
import connexion
from flask import jsonify


def get(id):
    bottle_test = db.session.query(BottleTest).get(id)
    if bottle_test:
        return bottle_test
    else:
        return "not found", 404


def search():
    limit = 1000
    offset = 0

    if 'limit' in connexion.request.args:
        limit = int(connexion.request.args['limit'])
    if limit > 1000 or limit < 0 or type(limit) is not int:
        limit = 1000

    if 'offset' in connexion.request.args:
        offset = int(connexion.request.args['offset'])
    if offset < 0 or type(offset) is not int:
        offset = 0

    bottle_tests = db.session.query(BottleTest) \
                     .limit(limit) \
                     .offset(offset) \
                     .all()
   
    count = db.session.query(BottleTest).count()
    return bottle_tests, 200, {'X-total-count': count}
