#RELEASE := $(shell curl -s https://api.github.com/repos/NLnetLabs/nsd/releases/latest | jq -r .tag_name | grep -Ee '^NSD_([0-9]+)_([0-9]+)_([0-9]+)_REL$$')
#VERSION := $(shell echo "$(RELEASE)" | sed -E 's/NSD_([0-9]+)_([0-9]+)_([0-9]+)_REL/\1.\2.\3/')

REPO := dnesting/nsd
GIT_SHA := $(shell git rev-parse --short=7 HEAD)
GIT_DIRTY := $(shell test -n "$$(git status --porcelain)" && echo "-dirty")
#TAG := $(VERSION)-$(GIT_SHA)$(GIT_DIRTY)

dev: get-release
	docker build \
		--platform=linux/amd64 \
		--build-arg TAG=$(RELEASE) \
		-t $(REPO):$(TAG) \
		-t $(REPO):dev \
		.
push: get-release
	docker push $(REPO):$(TAG)
	docker push $(REPO):dev

NSD_RELEASE:
	curl -s https://api.github.com/repos/NLnetLabs/nsd/releases/latest | jq -r .tag_name | grep -Ee '^NSD_([0-9]+)_([0-9]+)_([0-9]+)_REL$$' >$@

get-release: NSD_RELEASE
	@$(eval RELEASE := $(shell cat NSD_RELEASE))
	@$(eval VERSION := $(shell echo "$(RELEASE)" | sed -E 's/NSD_([0-9]+)_([0-9]+)_([0-9]+)_REL/\1.\2.\3/'))
	@$(eval TAG := $(VERSION)-$(GIT_SHA)$(GIT_DIRTY))
	@echo "Using NSD: $(RELEASE)"
	@echo "Image Tag: $(TAG)"
	@echo

clean:
	rm -f NSD_RELEASE

act:
	act \
		--pull=false \
		--container-architecture=linux/amd64 \
		--secret-file=/Users/david/.config/.act-secrets \
		workflow_dispatch

.PHONY: dev push get-release clean act
