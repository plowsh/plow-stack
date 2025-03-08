PLATFORM=avocado
BUILDER_IMAGE=plow-builder
EXAMPLE_PREFIX=plow-example

PACK_VERSION=0.36.4

install: bin/pack

bin/pack:
	@mkdir -p bin
	@curl -sSL https://github.com/buildpacks/pack/releases/download/v$(PACK_VERSION)/pack-v$(PACK_VERSION)-linux.tgz | tar -xz -C bin pack

.PHONY: all
all: install base-images builder examples

.PHONY: base-images
base-images:
	./scripts/build.sh -t $(PLATFORM)

.PHONY: builder
builder:
	pack builder create $(BUILDER_IMAGE):$(PLATFORM) --config ./builder.toml

.PHONY: examples
examples: examples/*
	@for dir in $^ ; do \
		make $$(dir)
	done

.PHONY: examples/*
examples/*:
	@echo "Building example: $(notdir $@)"
	pack build $(EXAMPLE_PREFIX)-$(notdir $@):$(PLATFORM) --path $@ --builder $(BUILDER_IMAGE):$(PLATFORM)
