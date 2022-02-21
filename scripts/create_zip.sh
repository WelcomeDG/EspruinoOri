#!/bin/bash

# This file is part of Espruino, a JavaScript interpreter for Microcontrollers
#
# Copyright (C) 2013 Gordon Williams <gw@pur3.co.uk>
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# ----------------------------------------------------------------------------------------
# Creates a Zip file of all common Espruino builds
# ----------------------------------------------------------------------------------------

cd `dirname $0`
cd .. # Espruino

VERSION=`sed -ne "s/^.*JS_VERSION.*\"\(.*\)\"/\1/p" src/jsutils.h | head -1`
echo "VERSION $VERSION"
DIR=`pwd`
ZIPDIR=$DIR/zipcontents
ZIPFILE=$DIR/archives/espruino_${VERSION}.zip
rm -rf $ZIPDIR
mkdir $ZIPDIR

# Tidy up
# Binaries
rm bin/*.hex bin/*.zip bin/*.app_hex
# ESP8266
#rm -rf esp_iot_sdk_v2.0.0*
#rm -rf xtensa-lx106-elf
# ESP32
#rm -rf esp-idf
#rm -rf app
#rm -rf xtensa-esp32-elf
# Install everything
source scripts/provision.sh ALL



echo ------------------------------------------------------
echo                          Building Version $VERSION
echo ------------------------------------------------------

read -r -d '' BOARDS <<'EOF'
ESPRUINO_1V3
ESPRUINO_1V3_AT
ESPRUINO_1V3_WIZ
PICO_1V3
PICO_1V3_CC3000
PICO_1V3_WIZ
ESPRUINOWIFI
PUCKJS
PIXLJS
BANGLEJS
BANGLEJS2
MDBT42Q
NUCLEOF401RE
NUCLEOF411RE
STM32VLDISCOVERY
STM32F4DISCOVERY
STM32L496GDISCOVERY
MICROBIT2
ESP8266_BOARD
ESP8266_4MB
ESP32
WIO_LTE
RAK5010
SMARTIBOT
MICROBIT1
EOF

THREADS=1
echo $BOARDS | xargs -I{} -d " " -P $THREADS scripts/create_zip_board.sh {} 
exit 1
cd $DIR

sed 's/$/\r/' dist_readme.txt | sed "s/#v##/$VERSION/" > $ZIPDIR/readme.txt
bash scripts/extract_changelog.sh | sed 's/$/\r/' > $ZIPDIR/changelog.txt
#bash scripts/extract_todo.sh  >  $ZIPDIR/todo.txt
python scripts/build_docs.py  || { echo 'Build failed' ; exit 1; }
mv $DIR/functions.html $ZIPDIR/functions.html
cp $DIR/dist_licences.txt $ZIPDIR/licences.txt

rm -f $ZIPFILE
cd zipcontents
echo zip -r $ZIPFILE *
zip -r $ZIPFILE *
