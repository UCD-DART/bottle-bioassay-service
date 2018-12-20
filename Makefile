init:
	pip install pipenv
	pipenv install --dev

test:
	pipenv run py.test

ci: 
	pipenv run py.test
