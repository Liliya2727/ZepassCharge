#!/system/bin/sh
MODDIR=${0%/*}
MODULE_PROP="$MODDIR/module.prop"
bypassflag="/data/local/tmp/tempbypass"

# Function to print messages with delay
zepassprint() {
    echo ""
    echo "        ZEPASSCHARGE          "
    echo ""
    sleep 1
}

zepassprint

if [ -f "$bypassflag" ]; then
    echo "Enabling bypass charge..."
    sleep 4
    rm -f "$bypassflag"
    echo "Bypass is now Enabled!"
    sleep 3
    sed -i "s|^description=.*|description=Status • Enabled✅|" "$MODULE_PROP"
else
    echo "Disabling bypass charge..."
    sleep 4
    touch "$bypassflag"
    echo "Bypass is now Disabled!"
    sleep 3
    sed -i "s|^description=.*|description=Status • Disabled❌|" "$MODULE_PROP"
fi

sleep 1
echo ""
echo "Done..."
sleep 2
