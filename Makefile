.PHONY: all test testc openc release

all:
	@echo "usage:"
	@echo
	@echo "make test	runs tests"
	@echo "make testc	runs tests and logs coverage"
	@echo "make openc	starts webserver in coverage directory"
	@echo "make release	releases gem (dangerous)"

test:
	script/test

testc:
	COVERAGE=1 script/test

openc:
	cd coverage && adsf

release:
	bundle exec rake release
