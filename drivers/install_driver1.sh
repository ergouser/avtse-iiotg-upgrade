#!/bin/bash

KVER=$(uname -r)
MODDESTDIR=/lib/modules/$KVER/kernel/drivers/i2c/
declare -a MODULE_NAME=("attiny-btn" "attiny-wdt" "attiny-led" "attiny-mfd")

if [ ! -d "$MODDESTDIR" ]; then
    mkdir "$MODDESTDIR"
fi

for i in "${MODULE_NAME[@]}"
do
    if [ ! -f "${i}_v${KVER}.ko" ]; then
        echo "Can't find ${i} driver matching ${KVER}"
        exit 0
    fi

    echo "Installing module ${i} to $MODDESTDIR"

    # install the pre-built driver
    cp ${i}_v${KVER}.ko ${i}.ko
    install -p -m 644 ${i}.ko $MODDESTDIR
    rm ${i}.ko
done

/sbin/depmod -a $KVER

