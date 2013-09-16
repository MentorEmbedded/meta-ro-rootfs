FILESEXTRAPATHS_prepend := "${THISDIR}/systemd:"
SRC_URI += "\
    file://tmpfiles-sysroot.patch \
    file://update-tmpfiles \
"

do_install_append () {
    install -m 0755 ${WORKDIR}/update-tmpfiles ${D}${base_bindir}/
}

PACKAGES =+ "${PN}-tmpfiles"

FILES_${PN}-tmpfiles = "\
    ${base_bindir}/systemd-tmpfiles \
    ${base_bindir}/update-tmpfiles \
    ${sysconfdir}/tmpfiles.d \
    ${libdir}/tmpfiles.d \
    ${base_libdir}/systemd/system/systemd-tmpfiles* \
    ${base_libdir}/systemd/system/timers.target.wants/systemd-tmpfiles-clean.timer \
    ${base_libdir}/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service \
    ${base_libdir}/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev.service \
"

RDEPENDS_${PN} += "${PN}-tmpfiles"
