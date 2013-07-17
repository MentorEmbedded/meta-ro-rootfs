PACKAGES =+ "${PN}-tmpfiles"

FILES_${PN}-tmpfiles = "\
    ${base_bindir}/systemd-tmpfiles \
    ${sysconfdir}/tmpfiles.d \
    ${libdir}/tmpfiles.d \
    ${base_libdir}/systemd/system/systemd-tmpfiles* \
    ${base_libdir}/systemd/system/timers.target.wants/systemd-tmpfiles-clean.timer \
    ${base_libdir}/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service \
    ${base_libdir}/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev.service \
"

RDEPENDS_${PN} += "${PN}-tmpfiles"
