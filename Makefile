TARGET=./target

$(TARGET)/badger: badger.nim nim.cfg panicoverride.nim teensy.nim keyboard.nim pgmspace.nim \
			layouts.nim mappings/dvorak.nim mappings/qwerty.nim mcp23017.nim
	mkdir -p $(TARGET)
	nim c -d:danger --opt:size --os:any badger
	mv badger $(TARGET)

$(TARGET)/badger.hex: $(TARGET)/badger
	avr-objcopy -O ihex -R .eeprom $(TARGET)/badger $(TARGET)/badger.hex

.PHONY: build clean disassemble size size-breakdown upload

build: $(TARGET)/badger.hex

clean:
	rm -rf $(TARGET) || true

disassemble: $(TARGET)/badger
	avr-objdump -d -S $(TARGET)/badger > $(TARGET)/badger.dis

size: $(TARGET)/badger
	avr-size -C --mcu=atmega32u4 $(TARGET)/badger

size-breakdown: $(TARGET)/badger
	avr-size -C --mcu=atmega32u4 $(TARGET)/badger
	@echo ".data section:"
	avr-nm -S --size-sort $(TARGET)/badger | grep " [Dd] " || echo "empty"
	@echo ""
	@echo ".bss section:"
	avr-nm -S --size-sort $(TARGET)/badger | grep " [Bb] " || echo "empty"
	@echo ""
	@echo ".text section:"
	avr-nm -S --size-sort $(TARGET)/badger | grep " [Tt] " || echo "empty"

upload: $(TARGET)/badger.hex
	teensy-loader-cli --mcu=TEENSY2 -v -w $(TARGET)/badger.hex
