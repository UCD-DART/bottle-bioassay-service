from service import app
from bottle_bioassay import Bottle
from sqlalchemy import inspect
import json


def test_search():
    url = '/bottles'
    client = app.app.test_client()
    response = client.get(url)
    assert response.status_code == 200
    assert 'Content-Type' in response.headers
    assert response.headers['Content-Type'] == 'application/json'
    assert 'X-total-count' in response.headers
    count = int(response.headers['X-total-count'])
    assert isinstance(count, int)
    assert count >= 0
    data = json.loads(response.data)
    assert isinstance(data, list)

    mapper = inspect(Bottle)
    for column in mapper.attrs:
        assert column.key in data[0]


def test_search_limits():
    url = '/bottles'
    client = app.app.test_client()
    response = client.get(url, query_string={'limit': 1})
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) == 1

    url = '/bottles'
    response = client.get(url, query_string={'limit': 2})
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) == 2


def test_search_offset():
    url = '/bottles'
    client = app.app.test_client()
    response = client.get(url)
    first = json.loads(response.data)
    assert isinstance(first, list)

    url = '/bottles'
    response = client.get(url, query_string={'offset': 1})
    second = json.loads(response.data)
    assert isinstance(second, list)
    assert first != second
    assert first[1] == second[0]


def test_search_offset_and_limit():
    url = '/bottles'
    client = app.app.test_client()
    response = client.get(url, query_string={'offset': 0, 'limit': 3})
    first = json.loads(response.data)
    assert isinstance(first, list)

    url = '/bottles'
    response = client.get(url, query_string={'offset': 1, 'limit': 3})
    second = json.loads(response.data)
    assert isinstance(second, list)
    assert first != second
    assert first[1] == second[0]


def test_search_filters():
    2 == 3


def test_get():
    url = '/bottles'
    client = app.app.test_client()
    response = client.get(url)
    sample = json.loads(response.data)[0]
    assert sample['id']

    url = '/bottles/%i' % sample['id']
    response = client.get(url)
    item = json.loads(response.data)
    assert response.status_code == 200
    assert 'Content-Type' in response.headers
    assert response.headers['Content-Type'] == 'application/json'
    assert item == sample
