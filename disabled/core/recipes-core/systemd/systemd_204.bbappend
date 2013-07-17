FILESEXTRAPATHS_prepend := "${THISDIR}/systemd:"

SRC_URI += "\
    file://var-volatile.mount \
    ${@base_contains('IMAGE_FEATURES', 'read-only-rootfs', 'file://01-create-ro-rootfs-volatile.conf', '', d)} \
"

do_install_append() {
    install -D -m 0644 ${WORKDIR}/00-create-volatile.conf ${D}${sysconfdir}/tmpfiles.d/

    # /tmp is link to /var/volatile/tmp, but standard systemd unit tries to mount additional tmpfs at /tmp
    rm -f ${D}${base_libdir}/systemd/system/local-fs.target.wants/tmp.mount

    # The var-run.conf file cleans up /var/run which creates problems when used with tmpfs based systems
    rm -f ${D}${sysconfdir}/tmpfiles.d/var-run.conf

    install -m 0644 ${WORKDIR}/var-volatile.mount ${D}${base_libdir}/systemd/system/
    ln -sf ../var-volatile.mount \
      ${D}${base_libdir}/systemd/system/local-fs.target.wants/var-volatile.mount

    # /var/volatile is mount point for tmpfs created via base-files, keep it empty
    rm -rf ${D}${localstatedir}/log ${D}${localstatedir}/volatile

    if [[ "${IMAGE_FEATURES}" == *"read-only-rootfs"* ]]
    then
        rm -rf ${D}${localstatedir}/lib/systemd
        ln -sf ${localstatedir}/volatile/lib/systemd ${D}${localstatedir}/lib/systemd

        rm -rf ${D}${localstatedir}/lib/random-seed
        ln -sf ${localstatedir}/volatile/lib/random-seed ${D}${localstatedir}/lib/random-seed

        install -D -m 0644 ${WORKDIR}/01-create-ro-rootfs-volatile.conf ${D}${sysconfdir}/tmpfiles.d/01-create-ro-rootfs-volatile.conf

        sed -i '/After=/a After=systemd-tmpfiles-setup.service' ${D}${base_libdir}/systemd/system/systemd-random-seed-load.service
    fi
}
