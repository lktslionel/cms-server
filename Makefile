

# METADATA


PROJECT_DIR  = $(shell pwd)
PROJECT_NAME = cms-server

DUMB_INIT_PKG_VERSION ?= 1.2.2

DOCKER_REGISTRY = REGISTRY_DOMAIN
DOCKER_ORG_NAME = ORG
DOCKER_REPO_NAME = REPO_NAME

DOCKER_IMAGE_REPO_URL = "$(DOCKER_REGISTRY)/$(DOCKER_ORG_NAME)/$(DOCKER_REPO_NAME)"


# TASKS

.PHONY: assemble
assemble:
	tasks/assemble.sh


.PHONY: package
package:
	tasks/package.sh


.PHONY: tag
tag:
	tasks/tag.sh


.PHONY: publish
publish:
	tasks/publish.sh


.PHONY: run
run:
	tasks/run.sh

.PHONY = help
help: 
	@echo "assemble	: build, test code"
	@echo "package		: create a package bundle as a zip file"
	@echo "tag		: tag the package with a given version"	
	@echo "publish		: publish a release to a artificat repository"	
	