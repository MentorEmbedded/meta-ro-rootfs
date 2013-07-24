- [ ] Make /home a volatile path.  This would avoid issues with applications
  wanting to write to dotfiles and the like.  We'll need to determine how to
  prepopulate the contents of /home/root/ and the like, however.  If tmpfiles.d
  usage is sufficient, we can stick to that, otherwise we may need to set up
  something on boot to populate home dir(s) based on /etc/skel/, or use pam
  and have it populate at first login.

- [ ] Make /etc/resolv.conf volatile for the r/o case, and likely also for the
  resolvconf case, as it generates it from templates and other sources.

- [ ] Convert each bbappend in disabled/ to follow the same pattern as dbus.
  See [README.md](README.md) for the steps to follow.
