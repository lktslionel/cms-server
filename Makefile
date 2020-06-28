

# METADATA


PROJECT_DIR  = $(shell pwd)
PROJECT_NAME = cms-server

DUMB_INIT_PKG_VERSION ?= 1.2.2

DOCKER_REGISTRY = REGISTRY_DOMAIN
DOCKER_ORG_NAME = ORG
DOCKER_REPO_NAME = REPO_NAME

DOCKER_IMAGE_REPO_URL = "$(DOCKER_REGISTRY)/$(DOCKER_ORG_NAME)/$(DOCKER_REPO_NAME)"

ENVS = 	X_PROJECT_DIR="$(PROJECT_DIR)"\
		X_PROJECT_NAME="$(PROJECT_NAME)"

# TASKS

.PHONY: assemble
assemble: 
	$(ENVS) tasks/assemble.sh


.PHONY: package
package:
	$(ENVS) tasks/package.sh


.PHONY: tag
tag:
	$(ENVS) tasks/tag.sh


.PHONY: publish
publish:
	$(ENVS) tasks/publish.sh


.PHONY: run
run:
	$(ENVS) tasks/run.sh

.PHONY = help
help: 
	@echo "assemble	: build, test code"
	@echo "package		: create a package bundle as a zip file"
	@echo "tag		: tag the package with a given version"	
	@echo "publish		: publish a release to a artificat repository"	
	