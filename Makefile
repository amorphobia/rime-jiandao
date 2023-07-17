ifndef VERSION
VERSION=latest
endif

dicts:
	bash scripts/make_dicts.sh --append dicts/cizu_append.txt --delete dicts/cizu_delete.txt --modify dicts/cizu_modify.txt --version $(VERSION)

deweight:
	bash scripts/make_dicts.sh --append dicts/cizu_append.txt --delete dicts/cizu_delete.txt --modify dicts/cizu_modify.txt --version $(VERSION) --deweight

clean:
	mv dicts/cizu_raw.txt.bak dicts/cizu_raw.txt
	rm -rf dicts/02.cizu.txt schema/*.dict.yaml
