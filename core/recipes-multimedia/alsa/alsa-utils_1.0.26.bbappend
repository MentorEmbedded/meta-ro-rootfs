# Aside: in an r/o environment, unless the volatile mount is non-tmpfs,
# alsactl's services to save and restore state have no real benefit.

inherit volatile

volatile_var_dirs += "lib/alsa"

# Both alsaconf and alsactl need /var/lib/alsa, to store state
PACKAGES =+ "${PN}-common"
FILES_${PN}-common += "${prefix}/lib/tmpfiles.d"
RDEPENDS_${PN}-alsactl += "${PN}-common"
