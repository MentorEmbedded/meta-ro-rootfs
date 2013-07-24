# This is a class to simplify the common case of a volatile path in /var

PACKAGES =+ "${PN}-volatile"
FILES_${PN}-volatile += "${sysconfdir}/tmpfiles.d"

do_install_tmpfiles () {
    if [ -z "${volatile_var_dirs}" ]; then
        return 0
    fi

    for dir in ${volatile_var_dirs}; do
        rm -rf "${D}${localstatedir}/$dir"
    done

    install -d ${D}${prefix}/lib/tmpfiles.d
    for dir in ${volatile_var_dirs}; do
        printf "d %s 0755 root root - -\n" "${localstatedir}/$dir"
    done >${D}${prefix}/lib/tmpfiles.d/${PN}.conf

    install -d ${D}${sysconfdir}/tmpfiles.d
    for dir in ${volatile_var_dirs}; do
        printf "d %s 0755 root root - -\n" "${localstatedir}/volatile/$dir"
        printf "L %s - - - - %s\n" "${localstatedir}/$dir" "${localstatedir}/volatile/$dir"
    done >${D}${sysconfdir}/tmpfiles.d/${PN}.conf
}

do_install_append () {
    do_install_tmpfiles
}
