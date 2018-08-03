# target: help - Display callable targets.
help:
	@echo "Available targets:"
	@egrep "^# target:" Makefile

# target: deps - Get deps with carthage.
deps:
	@scripts/deps.sh

# target: test - Run tests via fastlane.
test:
	@bundle exec fastlane tests
