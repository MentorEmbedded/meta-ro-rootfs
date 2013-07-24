inherit volatile

volatile_var_dirs += "lib/${PN}"

FILES_${PN} += "${prefix}/lib/tmpfiles.d"
