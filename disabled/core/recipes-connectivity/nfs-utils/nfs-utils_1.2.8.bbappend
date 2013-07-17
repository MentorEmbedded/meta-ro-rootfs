FILESEXTRAPATHS_prepend := "${THISDIR}/${BPN}:"

SRC_URI += "\
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-nfs-ro-rootfs-volatile.conf', '', d)} \
"

do_install_append () {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        rm -rf ${D}${localstatedir}/lib/nfs
        ln -sf ${localstatedir}/volatile/lib/nfs ${D}${localstatedir}/lib/nfs

        install -D -m 0644 ${WORKDIR}/02-nfs-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-nfs-ro-rootfs-volatile.conf
    fi
}
