dirs755 += "/run"

do_install_append() {
       # systemd suggests that the /etc/mtab file should be a symlink to /proc/self/mounts
       ln -sf /proc/self/mounts ${D}${sysconfdir}/mtab

       if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
       then
           # Tweak the mount option and fs_passno for rootfs in fstab
           sed -i -e '/^[#[:space:]]*rootfs/{s/defaults/ro/;s/\([[:space:]]*[[:digit:]]\)\([[:space:]]*\)[[:digit:]]$/\1\20/}' '${D}${sysconfdir}/fstab'

           rm -rf ${D}${localstatedir}/lib/misc
           ln -sf ${localstatedir}/volatile/lib/misc ${D}${localstatedir}/lib/misc
       fi

       rm -rf ${D}${localstatedir}/run ${D}${localstatedir}/log \
              ${D}${localstatedir}/lock \
              ${D}${localstatedir}/tmp ${D}/tmp

       rm -rf ${D}${localstatedir}/volatile/*

       ln -sf /run              ${D}${localstatedir}/run
       ln -sf volatile/log      ${D}${localstatedir}/log
       ln -sf volatile/lock     ${D}${localstatedir}/lock
       ln -sf volatile/tmp      ${D}${localstatedir}/tmp
       ln -sf ${localstatedir}/volatile/tmp ${D}/tmp
}
