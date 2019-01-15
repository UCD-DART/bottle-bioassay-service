from service import app
import json


def test_search():
    url = '/bottletests'
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


def test_search_limits():
    url = '/bottletests?limit=1'
    client = app.app.test_client()
    response = client.get(url)
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) == 1

    url = '/bottletests?limit=2'
    response = client.get(url)
    data = json.loads(response.data)
    assert isinstance(data, list)
    assert len(data) == 2


def test_search_offset():
    url = '/bottletests'
    client = app.app.test_client()
    response = client.get(url)
    first = json.loads(response.data)
    assert isinstance(first, list)
    
    url = '/bottletests?offset=1'
    response = client.get(url)
    second = json.loads(response.data)
    assert isinstance(second, list)
    assert first != second
    assert first[1] == second[0]


def test_search_offset_and_limit():
    url = '/bottletests?offset=0&limit=3'
    client = app.app.test_client()
    response = client.get(url)
    first = json.loads(response.data)
    assert isinstance(first, list)
    
    url = '/bottletests?offset=1&limit=3'
    response = client.get(url)
    second = json.loads(response.data)
    assert isinstance(second, list)
    assert first != second
    assert first[1] == second[0]
