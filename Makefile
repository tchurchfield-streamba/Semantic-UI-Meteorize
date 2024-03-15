IMAGE_NAME=semantic-ui-meteorize
SEMANTIC_UI_PACKAGE=dist/semantic-ui
SEMANTIC_UI_DATA_PACKAGE=dist/semantic-ui-data

docker-build:
	docker build -t $(IMAGE_NAME) .
.PHONY: docker-build

docker-shell:
	docker run --rm -it -v $(PWD):/app -v ~/.ssh:/home/node/.ssh:ro $(IMAGE_NAME) bash -c ". env.sh; bash"
.PHONY: docker-shell

docker-shell-windows:
	docker run --rm -it -v $(shell cd):/app -v ~/.ssh:/home/node/.ssh:ro $(IMAGE_NAME) bash -c ". env.sh; bash"
.PHONY: docker-shell-windows

deps:
	npm install
.PHONY: deps

generate:
	gulp
.PHONY: generate

publish: publish-ui-data publish-ui
.PHONY: publish

publish-windows: publish-ui-data-windows publish-ui-windows
.PHONY: publish-windows

publish-ui-data-windows:
	pwsh -Command "& './scripts/publish.ps1' -PACKAGE_PATH $(SEMANTIC_UI_DATA_PACKAGE)"
.PHONY: publish-ui-data-windows

publish-ui-data:
	PACKAGE_PATH=$(SEMANTIC_UI_DATA_PACKAGE) ./scripts/publish.sh
.PHONY: publish-ui-data

publish-ui-windows:
	pwsh -Command "& './scripts/publish.ps1' -PACKAGE_PATH $(SEMANTIC_UI_PACKAGE)"
.PHONY: publish-ui-windows

publish-ui:
	PACKAGE_PATH=$(SEMANTIC_UI_PACKAGE) ./scripts/publish.sh
.PHONY: publish-ui

clean:
	rm -fr tmp dist node_modules
.PHONY: clean
