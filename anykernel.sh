#!/system/bin/sh
# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=KSU Kernel by deepongi @ deepongi-labs
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=shiba
device.name2=husky
device.name3=akita
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel boot install
split_boot;

# Detect boot header version
HEADER_VER=$(grep "HEADER_VER" /tmp/anykernel/split_img/boot.img-header_version 2>/dev/null || echo "0")
RAMDISK_SIZE=$(grep "RAMDISK_SZ" /tmp/anykernel/ramdisk_size 2>/dev/null || echo "0")

ui_print " ";
ui_print "Boot Image Information:";
ui_print "  Header Version: v${HEADER_VER}";
ui_print "  Ramdisk Size: ${RAMDISK_SIZE} bytes";
ui_print " ";

# Check if we should skip ramdisk operations (Android 16 / boot header v4)
if [ "$HEADER_VER" -ge "4" ] || [ "$RAMDISK_SIZE" -lt "1024" ]; then
  ui_print "Boot header v4 detected (Android 16)";
  ui_print "Ramdisk is in boot_dlkm partition";
  ui_print "Skipping ramdisk operations...";
  ui_print " ";
  SKIP_RAMDISK=1;
else
  ui_print "Processing ramdisk (header v${HEADER_VER})...";
  ui_print " ";
  SKIP_RAMDISK=0;
fi

# Only modify ramdisk if not v4
if [ "$SKIP_RAMDISK" != "1" ]; then
  ui_print "Extracting ramdisk...";
  # Add any ramdisk modifications here if needed
  # For kernel-only flash, this section can remain empty
fi

# Flash kernel (always done regardless of header version)
ui_print "Installing kernel image...";
flash_boot;

ui_print " ";
ui_print "Installation complete!";
ui_print " ";

## end boot install
