DESCRIPTION = "Systemd tmpfiles.d support"
HOMEPAGE = "http://www.freedesktop.org/wiki/Software/systemd"
SECTION = "base/shell"

LICENSE = "GPLv2 & LGPLv2.1 & MIT"
LIC_FILES_CHKSUM = "file://LICENSE.GPL2;md5=751419260aa954499f7abaabaa882bbe \
                    file://LICENSE.LGPL2.1;md5=4fbd65380cdd255951079008b364516c \
                    file://LICENSE.MIT;md5=544799d0b492f119fa04641d1b8868ed"

DEPENDS = "intltool-native dbus libcap"

SRC_URI = "http://www.freedesktop.org/software/systemd/systemd-${PV}.tar.xz \
           file://tmpfiles-sysroot.patch \
           file://configure-no-gperf.patch \
           file://configure-no-gcrypt.patch \
           file://update-tmpfiles"
SRC_URI[md5sum] = "a07619bb19f48164fbf0761d12fd39a8"
SRC_URI[sha256sum] = "072c393503c7c1e55ca7acf3db659cbd28c7fe5fa94fab3db95360bafd96731b"
S = "${WORKDIR}/systemd-${PV}"

FILESPATH_prepend := "${THISDIR}/systemd:"

inherit autotools pkgconfig

LDFLAGS_libc-uclibc_append = " -lrt"

# Helper variables to clarify locations.  This mirrors the logic in systemd's
# build system.
rootprefix ?= "${base_prefix}"
rootlibdir ?= "${base_libdir}"

EXTRA_OECONF = "--with-rootprefix=${rootprefix} \
                --with-rootlibdir=${rootlibdir} \
                --with-sysvrcnd-path=${sysconfdir} \
                --with-firmware-path=/lib/firmware \
                --without-python \
                --without-perl \
                --enable-split-usr \
                --disable-gcrypt \
                --disable-pam \
                --disable-audit \
                --disable-xz \
                --disable-manpages \
                --disable-coredump \
                --disable-introspection \
                --disable-tcpwrap \
                --disable-microhttpd \
                --disable-kmod \
                --disable-myhostname \
                --disable-keymap \
                --disable-gudev"

MANPAGES = "\
    man/systemd-tmpfiles.8 \
    man/systemd-tmpfiles-clean.service.8 \
    man/systemd-tmpfiles-clean.timer.8 \
    man/systemd-tmpfiles-setup-dev.service.8 \
    man/systemd-tmpfiles-setup.service.8 \
    man/tmpfiles.d.5 \
"

EXTRA_OEMAKE += "'man_MANS=${MANPAGES}' 'MANS=${MANPAGES}'"

do_configure_prepend() {
	export CPP="${HOST_PREFIX}cpp ${TOOLCHAIN_OPTIONS} ${HOST_CC_ARCH}"
	export GPERF="${HOST_PREFIX}gperf"

	sed -i -e 's:=/root:=${ROOT_HOME}:g' ${S}/units/*.service*
}

do_compile () {
    oe_runmake systemd-tmpfiles
    oe_runmake units/systemd-tmpfiles-setup-dev.service
    oe_runmake units/systemd-tmpfiles-setup.service
    oe_runmake units/systemd-tmpfiles-clean.service
    #oe_runmake ${MANPAGES}
}

do_install () {
    install -d ${D}${base_bindir}
    install -m 0755 systemd-tmpfiles ${D}${base_bindir}/

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 units/systemd-tmpfiles-setup.service ${D}${systemd_unitdir}/system/
    install -m 0644 units/systemd-tmpfiles-setup-dev.service ${D}${systemd_unitdir}/system/
    install -m 0644 units/systemd-tmpfiles-clean.timer ${D}${systemd_unitdir}/system/
    install -m 0644 units/systemd-tmpfiles-clean.service ${D}${systemd_unitdir}/system/

    install -d ${D}${sysconfdir}/tmpfiles.d
    install -d ${D}${prefix}/lib/tmpfiles.d
    for cfg in tmpfiles.d/*; do
        install -m 0644 $cfg ${D}${prefix}/lib/tmpfiles.d/
    done

    install -d ${D}${base_bindir}
    install -m 0755 ${WORKDIR}/update-tmpfiles ${D}${base_bindir}/
    #oe_runmake install-man8 install-man5
}

FILES_${PN} += "\
    ${prefix}/lib/tmpfiles.d \
    ${base_libdir}/systemd/system/systemd-tmpfiles* \
    ${base_libdir}/systemd/system/timers.target.wants/systemd-tmpfiles-clean.timer \
    ${base_libdir}/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service \
    ${base_libdir}/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup-dev.service \
"

BBCLASSEXTEND = "native"

python () {
    if d.getVar('CLASSOVERRIDE', True) == 'class-target' and 'systemd' in d.getVar('DISTRO_FEATURES', True).split():
        raise bb.parse.SkipPackage("target systemd-tmpfiles recipe isn't used for systemd builds, the main systemd recipe is")
}
