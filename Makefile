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
	rm -rf dicts/02.cizu.txt dicts/cizu_raw_work.txt schema/*.dict.yaml temp.txt xiaoxiao/mb/jiandao*.txt

.PHONY: all dicts deweight check clean
