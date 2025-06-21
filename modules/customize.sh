#!/bin/sh

#
# Copyright (C) 2024-2025 Zexshia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=false
LATESTARTSERVICE=true
REPLACE=""
MODVER=$(grep "^version=" "$MODPATH/module.prop" | cut -d '=' -f2)
# Check Bypass Path
checkpath() {
    if [ -e "$1" ]; then
        return 0 
    fi
    return 1  
}

# List of paths
bypasslist="
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
# Check if at least one valid path exists
bypasspath=""
for path in $bypasslist; do
    if checkpath "$path"; then
        bypasspath="$path"
        break  # Stop checking after finding one valid path
    fi
done

if [ -z "$bypasspath" ]; then
    ui_print "- Bypass unsupported. Installation aborted."
    exit 1
fi

# Notify if Found Path
ui_print "- Bypass path: $bypasspath"
sleep 3
ui_print "- Start installing..."

# Start Installation
ui_print
ui_print "       ZEPASSCHARGE Type4!        "
ui_print 
ui_print "- by : @Zexshia!"
ui_print "- Version           : ${MODVER}"
ui_print "- Device            : $(getprop ro.product.board)"
    ui_print "- Build Date    : $(getprop ro.build.date)"
ui_print "- Installing ZepassCharge..."
extract -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
extract -o "$ZIPFILE" 'service.sh' -d "$MODPATH" >&2

# Check Encore dependencies 
if [ ! -d /data/adb/modules/encore ]; then
  ui_print " "  
  ui_print "Please install Encore first!"
  abort
fi

# Set Permission
ui_print "- Setting Permissions"
set_perm_recursive "$MODPATH/system/bin" 0 2000 0777 0777
chmod +x "$MODPATH/system/bin/ZepassCharge" 
chmod +x "$MODPATH/system/bin/ZepassCHGProfiler" 
chmod +x "$MODPATH/system/bin/bypass" 
