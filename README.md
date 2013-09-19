read-only-rootfs support enhancements Yocto layer
=================================================

This layer holds fixes for read-only-rootfs support that were needed by Mentor
Graphics Corporation. Currently, it contains a recipe which implements the
equivalent of the current sysvinit read-only-rootfs hook for systemd, to be
installed into read-only-rootfs images, a bbappend to fix lighttpd so it
doesn't try to write to /www, and a couple other misc changes. It also holds
remnants from an initial move toward consolidating the systemd tmpfiles.d and
sysvinit volatiles mechanisms.

This layer depends on:

URI: git://git.openembedded.org/openembedded-core
Branch: master

Contributing
------------

URL: https://github.com/MentorEmbedded/meta-ro-rootfs

To contribute to this layer, please fork and submit pull requests to the above
repository with github, or open issues for any bugs you find, or feature
requests you have.

Usage
-----

1. Add this layer to `BBLAYERS` in bblayers.conf
2. Enable read-only-rootfs for your images, by adding this to local.conf: `EXTRA_IMAGE_FEATURES += "read-only-rootfs"`
3. Set up the mount-binds recipe to be included in the image for
   read-only-rootfs images (this is a temporary mechanism, intended to be
   replaced either with changes to image.bbclass, or aligning more closely
   with what sysvinit is doing): `IMAGE_INSTALL_append = " ${@'ro-binds' if
   'read-only-rootfs' in IMAGE_FEATURES.split() and 'systemd'`
