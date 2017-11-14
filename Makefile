all: compile

clean-devel: clean
	-rm -rf _build

clean:
	-rm -f .build_date
	./rebar3 clean

compile:
	./rebar3 compile

test:
	./rebar3 do xref, eunit, cover
	./covertool \
		-cover _build/test/cover/eunit.coverdata \
		-appname soxe \
		-output cobertura.xml > /dev/null

.PHONY: test compile all
