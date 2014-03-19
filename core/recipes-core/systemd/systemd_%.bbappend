# Pull in the package which sets up writable areas when using read-only-rootfs
RDEPENDS_${PN} += "volatile-binds"
