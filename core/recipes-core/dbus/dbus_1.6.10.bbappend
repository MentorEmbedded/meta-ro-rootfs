FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://tmpfiles-dbus.conf \
    file://tmpfiles-dbus-volatile.conf \
"

do_install_append () {
    rmdir ${D}${localstatedir}/lib/dbus
    rmdir ${D}${localstatedir}/lib
    rmdir --ignore-fail-on-non-empty ${D}${localstatedir}

    install -d ${D}${prefix}/lib/tmpfiles.d
    install -m 0644 ${WORKDIR}/tmpfiles-dbus.conf ${D}${prefix}/lib/tmpfiles.d/dbus.conf

    install -d ${D}${sysconfdir}/tmpfiles.d
    install -m 0644 ${WORKDIR}/tmpfiles-dbus-volatile.conf ${D}${sysconfdir}/tmpfiles.d/dbus.conf
}

PACKAGES =+ "${PN}-volatile"
FILES_${PN} += "${prefix}/lib/tmpfiles.d"
FILES_${PN}-volatile += "${sysconfdir}/tmpfiles.d"
