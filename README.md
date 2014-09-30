read-only-rootfs support enhancements Yocto layer
=================================================

This layer held fixes for read-only-rootfs support that were needed by Mentor
Graphics Corporation. This layer is no longer necessary given the support from
upstream oe-core.

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
2. Enable read-only-rootfs for your images, by adding this to local.conf:

    EXTRA_IMAGE_FEATURES += "read-only-rootfs"

If the default writable paths are insufficient, you can add additional bind
mounts for files or directories. Examples:

    VOLATILE_BINDS_append = "/var/volatile/www /www\n"
    VOLATILE_BINDS_append = "/var/volatile/rsyncd.conf /etc/rsyncd.conf\n"
