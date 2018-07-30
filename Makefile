# target: help - Display callable targets.
help:
	@echo "Available targets:"
	@egrep "^# target:" Makefile

# target: deps - Get deps with carthage.
deps:
	@scripts/deps.sh
