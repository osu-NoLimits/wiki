.PHONY: install venv clean-venv run deploy

venv:
	@python3 -m venv .venv 2>/dev/null || \
	( echo "python3 venv creation failed — trying to install python3-venv via apt (requires sudo)" && \
	  sudo apt update && sudo apt install -y python3-venv && \
	  python3 -m venv .venv )
	.venv/bin/python -m pip install --upgrade pip setuptools wheel

install: venv
	.venv/bin/pip install mkdocs mkdocs-material
	.venv/bin/mkdocs --version

run:
	.venv/bin/mkdocs serve -a 0.0.0.0:8010

deploy:
	.venv/bin/mkdocs build
	git add .
	git commit -m "Deploy documentation"
	git push origin main
	.venv/bin/mkdocs gh-deploy

clean-venv:
	rm -rf .venv