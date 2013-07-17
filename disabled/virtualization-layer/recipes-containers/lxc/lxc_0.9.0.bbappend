FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-lxc-ro-rootfs-volatile.conf', '', d)}"

do_install_append() {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        rm -rf ${D}${localstatedir}/lib/lxc
        ln -sf ${localstatedir}/volatile/lib/lxc ${D}${localstatedir}/lib/lxc

        install -D -m 0644 ${WORKDIR}/02-lxc-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-lxc-ro-rootfs-volatile.conf
    fi
}

