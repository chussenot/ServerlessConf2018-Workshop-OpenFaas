.PHONY: invoke

FILE=functions.yml

all:
	faas-cli build -f ${FILE}
	faas-cli push -f ${FILE}
	faas-cli remove hello -f ${FILE}
	faas-cli deploy -f ${FILE}
	faas-cli invoke hello -f ${FILE}
