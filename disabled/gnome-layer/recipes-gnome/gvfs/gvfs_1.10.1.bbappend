# Find local "files" and "${PN}" directory
FILESEXTRAPATHS := "${THISDIR}/${PN}"

SRC_URI_append = "\
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-gvfs-ro-rootfs-volatile.conf', '', d)} \
"

FILES_${PN} += "\
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', '/home/root', '', d)} \
"

do_install_append() {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        install -d -m 0755 ${D}/home/root
        ln -sf ${localstatedir}/volatile/.gvfs ${D}/home/root/.gvfs

        install -D -m 0644 ${WORKDIR}/02-gvfs-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-gvfs-ro-rootfs-volatile.conf
    fi
}
