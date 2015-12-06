.PHONY: all coverage opencoverage test release

all:
	@echo "usage:"
	@echo
	@echo "make coverage		runs test and logs coverage"
	@echo "make opencoverage	starts webserver in coverage directory"
	@echo "make test		runs tests"
	@echo "make release		releases gem (dangerous)"

coverage:
	COVERAGE=1 script/test

opencoverage:
	cd coverage && adsf

test:
	script/test

release:
	bundle exec rake release
