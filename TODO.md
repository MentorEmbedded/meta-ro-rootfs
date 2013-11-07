- Ensure that /etc/resolv.conf is writable for the r/o case, and likely also
  for the resolvconf case.
- Pursue pushing volatile-binds upstream for systemd r/o there, now that Yocto
  1.5 is released.
