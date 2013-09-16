SUMMARY = "Perform bind mounts, copying the existing contents into the overlays."
DESCRIPTION = "${SUMMARY}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://../COPYING.MIT;md5=5750f3aa4ea2b00c2bf21b2b2a7b714d"

SRC_URI += "\
    file://COPYING.MIT \
    file://bind-mount-copy \
    file://mount-binds \
    file://mount-binds.service \
"

inherit allarch systemd

SYSTEMD_SERVICE_${PN} = "mount-binds.service"

do_install () {
    install -d ${D}${sysconfdir}/binds.d
    echo ${sysconfdir}/binds.d >${D}${sysconfdir}/bindpaths
    echo '/var/volatile/lib /var/lib' >${D}${sysconfdir}/binds.d/var-lib
    echo '/var/volatile/root-home ${ROOT_HOME}' >${D}${sysconfdir}/binds.d/var-lib

    install -d ${D}${base_sbindir}
    install -m 0755 bind-mount-copy ${D}${base_sbindir}/
    install -m 0755 mount-binds ${D}${base_sbindir}/

    install -d ${D}${systemd_unitdir}/system
    install -m 0755 mount-binds.service ${D}${systemd_unitdir}/system/
}
do_install[dirs] = "${WORKDIR}"
