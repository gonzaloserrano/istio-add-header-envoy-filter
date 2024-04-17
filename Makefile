NAME := add-header-filter
STATIC := $(NAME)-static

HUB ?= localhost:5000 # local kind
TAG ?= 1.0
PLATFORM ?= linux/amd64
GOOS ?= $(word 1, $(subst /, ,$(PLATFORM)))
GOARCH ?= $(word 2, $(subst /, ,$(PLATFORM)))

build: $(NAME)

$(NAME):
	go build -o $(NAME) main.go

$(STATIC):
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build \
		-ldflags '-s -w -extldflags "-static"' -tags "netgo" \
		-o $(STATIC) main.go

docker-build: $(STATIC)
	docker build --platform $(PLATFORM) -t $(HUB)/$(NAME):$(TAG) .

docker-push:
	docker push $(HUB)/$(NAME):$(TAG)

clean:
	rm -f $(NAME) $(STATIC)

all: clean $(STATIC) docker-build docker-push

.PHONY: build docker-build docker-push clean all
