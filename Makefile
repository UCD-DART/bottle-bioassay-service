init:
	pip install pipenv
	pipenv install --dev

test:
	pycodestyle .
	pipenv run py.test

ci: 
	pycodestyle .
	pipenv run py.test
