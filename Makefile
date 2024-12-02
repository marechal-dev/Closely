.PHONY:	clean

clean:
	rm -rf build

build: create-build-dir
	go build -o build/closely.so cmd/closely/main.go

run: build
	build/closely

run-dev:
	go run cmd/closely/main.go

create-build-dir:
	mkdir -p build
