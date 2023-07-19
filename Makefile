ifndef VERSION
VERSION=latest
endif

all: deweight

dicts:
	bash scripts/make_dicts.sh --append dicts/cizu_append.txt --delete dicts/cizu_delete.txt --modify dicts/cizu_modify.txt --version $(VERSION)

deweight:
	bash scripts/make_dicts.sh --append dicts/cizu_append.txt --delete dicts/cizu_delete.txt --modify dicts/cizu_modify.txt --version $(VERSION) --deweight

check:
	bash scripts/sanity_check.sh

clean:
ifneq ("$(wildcard dicts/cizu_raw.txt.bak)", "")
	mv dicts/cizu_raw.txt.bak dicts/cizu_raw.txt
endif
	rm -rf dicts/02.cizu.txt schema/*.dict.yaml temp.txt

.PHONY: all dicts deweight check clean
