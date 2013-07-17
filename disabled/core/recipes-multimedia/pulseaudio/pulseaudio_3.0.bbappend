FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://use-var-volatile-read-only-rootfs.patch"

pkg_postinst_${PN}-server() {
        if [ -z "$D" ] && [ -e ${sysconfdir}/init.d/populate-volatile.sh ] ; then
            ${sysconfdir}/init.d/populate-volatile.sh update
        fi
}
