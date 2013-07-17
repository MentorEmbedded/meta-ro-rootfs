FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-alsa-ro-rootfs-volatile.conf', '', d)} \
"

FILES_${PN} += " \
    ${sysconfdir}/tmpfiles.d \
"

do_install_append() {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        rm -rf ${D}${localstatedir}

        install -D -m 0644 ${WORKDIR}/02-alsa-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-alsa-ro-rootfs-volatile.conf
    fi
}
