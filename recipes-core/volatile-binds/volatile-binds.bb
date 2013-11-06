SUMMARY = "Volatile bind mount setup and configuration for read-only-rootfs"
DESCRIPTION = "${SUMMARY}"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://../COPYING.MIT;md5=5750f3aa4ea2b00c2bf21b2b2a7b714d"

SRC_URI = "\
    file://mount-copybind \
    file://COPYING.MIT \
    file://volatile-binds.service.in \
"

inherit allarch systemd

VOLATILE_BINDS ?= "\
    /var/volatile/lib /var/lib\n\
    /var/volatile/root-home ${ROOT_HOME}\n\
    /var/volatile/media /media\n\
"
VOLATILE_BINDS[type] = "list"
VOLATILE_BINDS[separator] = "\n"

def volatile_systemd_services(d):
    services = []
    for line in oe.data.typed_value("VOLATILE_BINDS", d):
        if not line:
            continue
        what, where = line.split(None, 1)
        services.append("%s.service" % what[1:].replace("/", "-"))
    return " ".join(services)

SYSTEMD_SERVICES = "${@volatile_systemd_services(d)}"

DEPENDS += "${@'systemd-systemctl-native' if 'systemd' in DISTRO_FEATURES.split() else ''}"
FILES_${PN} += "${systemd_unitdir}/system/*.service"

do_compile () {
    while read spec mountpoint; do
        if [ -z "$spec" ]; then
            continue
        fi

        servicefile="${spec#/}"
        servicefile="${servicefile//\//-}.service"
        sed -e "s#@what@#$spec#g; s#@where@#$mountpoint#g" \
            volatile-binds.service.in >$servicefile
    done <<END
${@d.getVar('VOLATILE_BINDS', True).replace("\\n", "\n")}
END

    if [ -e var-volatile-lib.service ]; then
        # As the seed is stored under /var/lib, ensure that this service runs
        # after the volatile /var/lib is mounted.
        sed -i -e "/^Before=/s/\$/ systemd-random-seed.service/" \
               -e "/^WantedBy=/s/\$/ systemd-random-seed.service/" \
               var-volatile-lib.service
    fi
}
do_compile[dirs] = "${WORKDIR}"

do_install () {
    install -d ${D}${base_sbindir}
    install -m 0755 mount-copybind ${D}${base_sbindir}/

    install -d ${D}${systemd_unitdir}/system
    for service in ${SYSTEMD_SERVICES}; do
        install -m 0644 $service ${D}${systemd_unitdir}/system/
    done
}
do_install[dirs] = "${WORKDIR}"

pkg_postinst_${PN} () {
    OPTS=""

    if [ -n "$D" ]; then
        OPTS="--root=$D"
    fi

    if "${@'true' if 'systemd' in d.getVar('DISTRO_FEATURES', True).split() else 'false'}"; then
        if type systemctl >/dev/null 2>/dev/null; then
            for service in ${SYSTEMD_SERVICES}; do
                systemctl $OPTS enable $service

                if [ -z "$D" ]; then
                    systemctl restart $service
                fi
            done
        fi
    fi
}

pkg_prerm_${PN} () {
    if "${@'true' if 'systemd' in d.getVar('DISTRO_FEATURES', True).split() else 'false'}"; then
        if type systemctl >/dev/null 2>/dev/null; then
            if [ -z "$D" ]; then
                for service in ${SYSTEMD_SERVICES}; do
                    systemctl stop $service
                done
            fi

            for service in ${SYSTEMD_SERVICES}; do
                systemctl disable $service
            done
        fi
    fi
}
