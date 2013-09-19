- Ensure that /etc/resolv.conf is writable for the r/o case, and likely also
  for the resolvconf case.
- Either push mount-binds upstream, or merge in an equivalent into the systemd
  recipe the way sysvinit merges in their read_only_rootfs_hook.
