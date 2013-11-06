read-only-rootfs support enhancements Yocto layer
=================================================

This layer holds fixes for read-only-rootfs support that were needed by Mentor
Graphics Corporation. The biggest change was handling read-only-rootfs for
systemd images.

We provide a `read_only_rootfs_systemd.bbclass`, which ensures that the fstab
in the image gets switched to 'ro', the way it does with sysvinit images.

We also provide a volatile-binds recipe, which generates service files for
bind mounts to ensure that certain areas are writable, much like the sysvinit
read-only-rootfs hook does. This is data driven, however, and also makes
/media writable by default. Note that changes written to these areas will not
persist, as the bind mounts utilize /var/volatile, which is tmpfs.

The final piece in here is recipe bbappends to fix behavior regarding
read-only-rootfs, and thus far we've only needed one: lighttpd.

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
2. If building systemd images, ensure that / is mounted r/o when using
   read-only-rootfs by adding this to local.conf, or your distro .conf:

    INHERIT += "read_only_rootfs_systemd"
3. Enable read-only-rootfs for your images, by adding this to local.conf:

    EXTRA_IMAGE_FEATURES += "read-only-rootfs"

If the default writable areas (/var/lib, /home/root, and /media) are
insufficient, you can add additional bind mount directories. For example:

    VOLATILE_BINDS_append = "/var/volatile/www /www\n"
