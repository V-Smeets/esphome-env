#
ESPHOME_NAME	= environment
CONFIGURATION	= ${ESPHOME_NAME}.yaml
DEVICE		= ${ESPHOME_NAME}

# Targets
all::
clean::

# venv
all:: bin/activate
clean::
	$(RM) --recursive bin include lib lib64 pyvenv.cfg
bin/activate:
	python3 -m venv .

# esphome
all:: bin/esphome
clean::
	$(RM) --recursive share
bin/esphome: bin/activate
	. bin/activate; \
	pip install esphome

# Compile
all:: compile
clean::
	$(RM) --recursive .esphome
FIRMWARE_BIN	= .esphome/build/$(ESPHOME_NAME)/.pioenvs/$(ESPHOME_NAME)/firmware.bin
compile: ${FIRMWARE_BIN}
${FIRMWARE_BIN}: bin/esphome ${CONFIGURATION}
	. bin/activate; \
	esphome compile ${CONFIGURATION}
${CONFIGURATION}: secrets.yaml

# Upload
upload: compile
	. bin/activate; \
	esphome upload --device $(DEVICE) ${CONFIGURATION}
