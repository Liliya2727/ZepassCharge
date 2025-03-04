#!/bin/sh
while [ -z "$(getprop sys.boot_completed)" ]; do
    sleep 2
    su -lp 2000 -c "/system/bin/cmd notification post -S bigtext -t \"ZEPASSCHARGE\" \"$NOTIF_TAG\" \"Bypass Charging is Ready!\""
done
ZepassCharge >/dev/null 2>&1
