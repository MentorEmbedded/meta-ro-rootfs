do_install_append() {
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        rm -rf ${D}${localstatedir}/lib/alsa
        ln -sf ${localstatedir}/volatile/lib/alsa ${D}${localstatedir}/lib/alsa
    fi
}
