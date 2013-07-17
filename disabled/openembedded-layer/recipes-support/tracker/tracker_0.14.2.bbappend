FILESEXTRAPATHS_prepend := "${THISDIR}/tracker:"

SRC_URI += "${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://02-xdg-ro-rootfs-volatile.conf', '', d)}"

do_install_append () {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"* ]]
    then
        install -D -m 0644 ${WORKDIR}/02-xdg-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/02-xdg-ro-rootfs-volatile.conf

        install -d -m 0755 ${D}/home/root
        install -d -m 0755 ${D}/home/root/.local

        ln -sf ${localstatedir}/volatile/.local/share ${D}/home/root/.local/share
        ln -sf ${localstatedir}/volatile/.config ${D}/home/root/.config
        ln -sf ${localstatedir}/volatile/.cache ${D}/home/root/.cache
    fi
}

FILES_${PN} += "${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', '/home/root', '', d)}"
