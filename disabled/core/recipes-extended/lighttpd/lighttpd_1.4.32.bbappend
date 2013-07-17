do_install_append() {
    # read-only rootfs
    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"*  ]]
    then
        rm -rf ${D}/www/logs ${D}/www/var
        ln -sf ${localstatedir}/log ${D}/www/logs
        ln -sf ${localstatedir}/tmp ${D}/www/var
    fi
}
