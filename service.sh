#!/bin/sh
while [ -z "$(getprop sys.boot_completed)" ]; do
    sleep 15
done
ZepassCharge >/dev/null 2>&1

#EndOfFile
