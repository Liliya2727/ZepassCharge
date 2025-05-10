#!/bin/sh
SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=true
LATESTARTSERVICE=true
REPLACE=""

# Function to check if a valid path exists
check_valid_path() {
    if [ -e "$1" ]; then
        return 0  # Path found, continue installation
    fi
    return 1  # Path not found
}

# List of paths
VALID_PATHS="
/sys/class/power_supply/battery/batt_slate_mode
/sys/class/power_supply/battery/battery_input_suspend
/sys/class/power_supply/battery/bd_trickle_cnt
/sys/class/power_supply/battery/device/Charging_Enable
/sys/class/power_supply/battery/charging_enabled
/sys/class/power_supply/battery/op_disable_charge
/sys/class/power_supply/battery/store_mode
/sys/class/power_supply/battery/test_mode
/sys/class/power_supply/battery/battery_ext/smart_charging_interruption
/sys/class/power_supply/battery/siop_level
/sys/class/power_supply/battery/battery_charging_enabled
/sys/class/power_supply/battery/mmi_charging_enable
/sys/class/power_supply/battery/stop_charging_enable
/sys/class/hw_power/charger/charge_data/enable_charger
/sys/class/qcom-battery/input_suspend
/sys/devices/platform/charger/bypass_charger
/sys/devices/platform/charger/tran_aichg_disable_charger
/sys/devices/platform/huawei_charger/enable_charger
/sys/devices/platform/lge-unified-nodes/charging_completed
/sys/devices/platform/lge-unified-nodes/charging_enable
/sys/devices/platform/mt-battery/disable_charger
/sys/devices/platform/soc/soc:google,charger/charge_disable
/sys/kernel/debug/google_charger/chg_suspend
/sys/kernel/debug/google_charger/input_suspend
/sys/kernel/nubia_charge/charger_bypass
/proc/mtk_battery_cmd/current_cmd
"
# Checking path
ui_print "- Checking device compatibility..."
sleep 3
# Check if at least one valid path exists
FOUND_PATH=""
for path in $VALID_PATHS; do
    if check_valid_path "$path"; then
        FOUND_PATH="$path"
        break  # Stop checking after finding one valid path
    fi
done

if [ -z "$FOUND_PATH" ]; then
    ui_print "- Bypass unsupported. Installation aborted."
    exit 1
fi

# Display the found path
ui_print "- Bypass path found: $FOUND_PATH"
sleep 2
ui_print "- Start installing..."
sleep 2
# Continue with installation
ui_print
ui_print "       ZEPASSCHARGE Type3!        "
ui_print 
ui_print "- by : @Zexshia!"
sleep 1
ui_print "- Device : $(getprop ro.product.board) "
sleep 2
ui_print "- Extracting module files"
touch "/data/local/tmp/tempbypass"
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'service.sh' -d "$MODPATH" >&2
unzip -o "$ZIPFILE" 'action.sh' -d $MODPATH >&2
if pm list packages | grep -q bellavita.toast; then
	ui_print "- The Bellavita Toast app is already installed."
else
	ui_print "- Bellavita Toast isn't installed"
	ui_print "- Installing bellavita toast"
	unzip -o "$ZIPFILE" 'toast.apk' -d $MODPATH >&2
	pm install $MODPATH/toast.apk
	rm $MODPATH/toast.apk
fi
set_perm_recursive $MODPATH 0 0 0777 0777
