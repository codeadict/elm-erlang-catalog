APPNAME=catalog
FE_DIR=frontend
FE_OUTPUT_DIR=priv/assets
RELPATH=./_build/default/rel/$(APPNAME)

REBAR=./rebar3
ERL=erl
ELM_MAKE=elm-make
ELM_PACKAGE=elm-package

CONFIG=rel/sys.config

.PHONY: all install compile release clean

all: release

$(REBAR):
	$(ERL) \
		-noshell -s inets start -s ssl start \
		-eval 'httpc:request(get, {"https://s3.amazonaws.com/rebar3/rebar3", []}, [], [{stream, "./rebar3"}])' \
		-s inets stop -s init stop
	chmod +x $(REBAR)

install:
	$(ELM_PACKAGE) install -y

$(FE_OUTPUT_DIR)/Main.js: $(FE_DIR)/Main.elm
	$(ELM_MAKE) $(FE_DIR)/Main.elm --output $(FE_OUTPUT_DIR)/Main.js

compile: $(FE_OUTPUT_DIR)/Main.js
	$(REBAR) compile

clean: $(REBAR)
	$(REBAR) clean
	rm -rvf $(FE_OUTPUT_DIR)/Main.js

release: compile
	$(REBAR) release

run: release
	$(RELPATH)/bin/$(APPNAME) console
