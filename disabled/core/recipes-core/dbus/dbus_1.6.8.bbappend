FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-dbus-ro-rootfs-volatile.conf', '', d)} \
"

do_install_append() {
    rm -rf ${D}${localstatedir}/run ${D}${localstatedir}/var/volatile

    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        rm -rf ${D}${localstatedir}/lib/dbus
        ln -sf ${localstatedir}/volatile/lib/dbus ${D}${localstatedir}/lib/dbus

        install -D -m 0644 ${WORKDIR}/02-dbus-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-dbus-ro-rootfs-volatile.conf
    fi
}
