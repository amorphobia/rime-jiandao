ifndef APPEND
APPEND=dicts/cizu_append.txt
endif
ifndef DELETE
DELETE=dicts/cizu_delete.txt
endif
ifndef MODIFY
MODIFY=dicts/cizu_modify.txt
endif
ifndef VERSION
VERSION=latest
endif

all: dicts

dicts:
ifndef DEWEIGHT
	bash scripts/make_dicts.sh --append $(APPEND) --delete $(DELETE) --modify $(MODIFY) --version $(VERSION)
else
	bash scripts/make_dicts.sh --append $(APPEND) --delete $(DELETE) --modify $(MODIFY) --version $(VERSION) --deweight
endif

check:
	bash scripts/sanity_check.sh

clean:
ifneq ("$(wildcard dicts/cizu_raw.txt.bak)", "")
	mv dicts/cizu_raw.txt.bak dicts/cizu_raw.txt
endif
	rm -rf dicts/02.cizu.txt schema/*.dict.yaml temp.txt

.PHONY: all dicts deweight check clean
