.PHONY: all
all: stacks builder

.PHONY: stacks
stacks:
	docker build stacks/ubuntu22/ --target build -t plow/stack-ubuntu22:build
	docker build stacks/ubuntu22/ --target run -t plow/stack-ubuntu22:run

.PHONY: builder
builder:
	pack builder create plow/builder:ubuntu22 --config ./builder/builder.toml
