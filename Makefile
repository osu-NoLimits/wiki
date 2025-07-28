install:
	sudo apt update
	sudo apt install python3 python3-pip -y
	pip3 install mkdocs mkdocs-material
	mkdocs --version

run:
	mkdocs serve

deploy:
	mkdocs build
	git add .
	git commit -m "Deploy documentation"
	git push origin main
	mkdocs gh-deploy