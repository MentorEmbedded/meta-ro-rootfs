do_install_append () {
    rm -rf ${D}/www/logs
    ln -sf ${localstatedir}/log ${D}/www/logs
    rm -rf ${D}/www/var
    ln -sf ${localstatedir}/tmp ${D}/www/var
}
