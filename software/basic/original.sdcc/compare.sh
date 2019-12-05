#!/bin/bash

hexdump -v -e '8/1 "%02X " "\n"' 8kbasic.bin |tr 'abcdef' 'ABCDEF' > 8kbasic.hex

md5sum 8kbasic.hex

cut -c 6-28 ../original/Basic.nas |sed '/^$/d' > 8kbasic.orig.hex

md5sum 8kbasic.orig.hex
