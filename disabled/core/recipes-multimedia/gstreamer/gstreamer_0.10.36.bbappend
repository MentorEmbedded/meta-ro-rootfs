FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-gstreamer-ro-rootfs-volatile.conf', '', d)} \
"

FILES_${PN} += " \
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', '/home/root', '', d)} \
"

do_install_append() {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"* ]]
    then
        install -D -m 0644 ${WORKDIR}/02-gstreamer-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-gstreamer-ro-rootfs-volatile.conf
        install -d -m 0755 ${D}/home/root/
        ln -sf ${localstatedir}/volatile/.gstreamer-0.10 ${D}/home/root/.gstreamer-0.10
    fi
}
