build:
	@gleam build

run:
	@gleam run

clean:
	gleam clean
	rm -rf build

.PHONY: build run clean