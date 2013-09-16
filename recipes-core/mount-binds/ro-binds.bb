SUMMARY = "R/O bind mount configuration"
DESCRIPTION = "${SUMMARY}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://../COPYING.MIT;md5=5750f3aa4ea2b00c2bf21b2b2a7b714d"

SRC_URI = "file://COPYING.MIT"

inherit allarch

RDEPENDS_${PN} += "mount-binds"
CONFFILES_${PN} = "${sysconfdir}/binds.d/var-lib ${sysconfdir}/binds.d/root-home"

do_install () {
    install -d ${D}${sysconfdir}/binds.d
    echo '/var/volatile/lib /var/lib' >${D}${sysconfdir}/binds.d/var-lib
    echo '/var/volatile/root-home ${ROOT_HOME}' >${D}${sysconfdir}/binds.d/root-home
}
