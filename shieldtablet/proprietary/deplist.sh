#!/bin/bash

finddep()
{
  echo $1 >> deplist_checked.txt;
  deploc=$(find . |grep $1.so);
  if [ -z "${deploc}" ]; then
    #if grep "^${dep}$" deplist_known_targets.txt >/dev/null; then
    #  echo "                    $1 \\" >> deplist_targets.txt;
    #else
      echo "                    $1 \\" >> deplist_notfound.txt;
    #fi;
  else
    echo "                    $1 \\" >> deplist.txt;
  fi;
}

getdeps()
{
  if [ -z "${1}" ]; then return; fi;

  for dep in $(objdump -x $1 |grep NEEDED |awk '{ print $2 }' |rev |cut -d. -f2- |rev); do
    if ! grep "^${dep}$" deplist_checked.txt >/dev/null; then
      finddep $dep
      getdeps ${deploc}
    fi;
  done;
}

> deplist_checked.txt

echo "PRODUCT_PACKAGES += \\" > deplist.txt
echo "PRODUCT_PACKAGES += \\" > deplist_targets.txt
echo "PRODUCT_PACKAGES += \\" > deplist_notfound.txt

getdeps vendor/lib/libnvomx.so
getdeps vendor/lib/libnvomxilclient.so
getdeps vendor/lib/libnvomxadaptor.so
getdeps vendor/lib/libstagefrighthw.so

getdeps vendor/lib/hw/audio.primary.tegra.so
getdeps vendor/lib/hw/camera.tegra.so
getdeps vendor/lib/hw/gralloc.tegra.so
getdeps vendor/lib/hw/hwcomposer.tegra.so
getdeps vendor/lib/hw/keystore.tegra.so
getdeps vendor/lib/hw/memtrack.tegra.so
getdeps vendor/lib/hw/vulkan.tegra.so
getdeps lib/hw/sensors.default.mpl520.nvs.so

getdeps vendor/lib/libril-icera.so
getdeps vendor/bin/icera-switcherd

getdeps vendor/bin/tlk_daemon
getdeps vendor/bin/ss_status

getdeps vendor/bin/rm_ts_server
getdeps vendor/lib/hw/ts.default.so
getdeps vendor/lib/librm31080.so

getdeps vendor/lib/egl/libEGL_tegra.so
getdeps vendor/lib/egl/libGLESv1_CM_tegra.so
getdeps vendor/lib/egl/libGLESv2_tegra.so

getdeps bin/glgps_nvidiaTegra2android
getdeps lib/hw/gps.tegra.so

rm deplist_checked.txt
