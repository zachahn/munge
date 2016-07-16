.PHONY: all coverage-test coverage-open seeds-build seeds-open seeds-clean test release contents current-version

all:
	@echo "usage:"
	@echo
	@echo "make coverage-test  runs tests and logs coverage"
	@echo "make coverage-open  starts webserver in coverage directory"
	@echo "make seeds-build    runs munge-build on seeds"
	@echo "make seeds-open     runs munge-view on seeds"
	@echo "make seeds-clean    removes built seeds files"
	@echo "make test           runs tests"
	@echo "make release        releases gem (dangerous)"

coverage-test:
	RUN_FILESYSTEM_INTEGRATION_TESTS=1 COVERAGE=1 script/test

coverage-open:
	cd coverage && adsf

seeds-build:
	cd seeds && ../exe/munge build

seeds-open:
	cd seeds && ../exe/munge view

seeds-clean:
	rm -r seeds/dest seeds/.sass-cache

test:
	script/test

release:
	bundle exec rake release

build:
	bundle exec rake build ; $(MAKE) contents

contents:
	CV="$(shell make version)"; echo; tar -zxOf pkg/munge-$${CV}.gem data.tar.gz | tar -tf -

version:
	@sed -n -e '/VERSION/ s/[^0-1\.]//g;s/\.$$//p' lib/munge/version.rb
