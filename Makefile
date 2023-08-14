.PHONY: clean
# target: clean - Remove pyc and cache
clean:
	@find . -name "*.pyc" | xargs rm -rf
	@find . -name "*.pyo" | xargs rm -rf
	@find . -name "__pycache__" -type d | xargs rm -rf
	@find . -name ".cache" -type d | xargs rm -rf

run:
	@gunicorn kube_aiohttp_test:app --bind localhost:8080 --worker-class aiohttp.worker.GunicornUVLoopWebWorker -e SIMPLE_SETTINGS=kube_aiohttp_test.settings.development

requirements-test:
	@pip install -r requirements/test.txt

requirements-dev:
	@pip install -r requirements/dev.txt

test:
	@SIMPLE_SETTINGS=kube_aiohttp_test.settings.test py.test kube_aiohttp_test

test-matching:
	@SIMPLE_SETTINGS=kube_aiohttp_test.settings.test pytest -rxs -k${Q} kube_aiohttp_test

test-coverage:
	@SIMPLE_SETTINGS=kube_aiohttp_test.settings.test pytest --cov=kube_aiohttp_test kube_aiohttp_test --cov-report term-missing

lint:
	@flake8
	@isort --check

detect-outdated-dependencies:
	@sh -c 'output=$$(pip list --outdated); echo "$$output"; test -z "$$output"'

release-patch: ## Create patch release
	SIMPLE_SETTINGS=kube_aiohttp_test.settings.test bump2version patch --dry-run --no-tag --no-commit --list | grep new_version= | sed -e 's/new_version=//' | xargs -n 1 towncrier --yes --version
	git commit -am 'Update CHANGELOG'
	bump2version patch

release-minor: ## Create minor release
	SIMPLE_SETTINGS=kube_aiohttp_test.settings.test bump2version minor --dry-run --no-tag --no-commit --list | grep new_version= | sed -e 's/new_version=//' | xargs -n 1 towncrier --yes --version
	git commit -am 'Update CHANGELOG'
	bump2version minor

release-major: ## Create major release
	SIMPLE_SETTINGS=kube_aiohttp_test.settings.test bump2version major --dry-run --no-tag --no-commit --list | grep new_version= | sed -e 's/new_version=//' | xargs -n 1 towncrier --yes --version
	git commit -am 'Update CHANGELOG'
	bump2version major
