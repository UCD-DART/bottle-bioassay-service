import db
import json
from . import BottleTest
from sqlalchemy.orm.exc import NoResultFound
from sqlalchemy_filters import apply_filters
from sqlalchemy_filters.exceptions import BadSpec


def get(id):
    bottle_test = db.session.query(BottleTest).get(id)
    if bottle_test:
        return bottle_test
    else:
        return "not found", 404


def search(**kwargs):
    limit = 1000
    offset = 0

    query = db.session.query(BottleTest)

    if 'filter' in kwargs:
        try:
            filter = json.loads(kwargs['filter'])
            query = apply_filters(query, filter)
        except BadSpec:
            return "Invalid Filter", 500

    if 'limit' in kwargs:
        limit = kwargs['limit']
    if limit > 1000 or limit < 0:
        limit = 1000

    if 'offset' in kwargs:
        offset = kwargs['offset']
    if offset < 0:
        offset = 0

    query = query.limit(limit).offset(offset)
    bottle_tests = query.all()

    count = db.session.query(BottleTest).count()
    return bottle_tests, 200, {'X-total-count': count}
