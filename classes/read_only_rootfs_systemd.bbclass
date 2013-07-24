read_only_rootfs_hook_append () {
    if ${@base_contains("DISTRO_FEATURES", "systemd", "true", "false", d)}; then
        update-tmpfiles ${IMAGE_ROOTFS}
        systemd-tmpfiles --sysroot=${IMAGE_ROOTFS} --remove --create

        # Tweak the mount option and fs_passno for rootfs in fstab
        sed -i -e '/^[#[:space:]]*rootfs/{s/defaults/ro/;s/\([[:space:]]*[[:digit:]]\)\([[:space:]]*\)[[:digit:]]$/\1\20/}' ${IMAGE_ROOTFS}/etc/fstab
    fi
}

EXTRA_IMAGEDEPENDS_append = " ${@base_contains("DISTRO_FEATURES", "systemd", "systemd-tmpfiles-native", "", d)}"
