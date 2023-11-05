PLATFORM=avocado
BUILDER_IMAGE=plow-builder
EXAMPLE_PREFIX=plow-example

.PHONY: all
all: base-images builder

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
