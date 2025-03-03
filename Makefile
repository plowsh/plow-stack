PLATFORM=avocado
BUILDER_IMAGE=plow-builder
EXAMPLE_PREFIX=plow-example

install: bin/pack

bin/pack:
	@mkdir -p bin
	@curl -sSL https://github.com/buildpacks/pack/releases/download/v0.35.1/pack-v0.35.1-linux.tgz | tar -xz -C bin pack

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
		echo "Building example: $$(basename $$dir)"; \
		pack build $(EXAMPLE_PREFIX)-$$(basename $$dir):$(PLATFORM) --path $${dir} --builder $(BUILDER_IMAGE):$(PLATFORM); \
	done
