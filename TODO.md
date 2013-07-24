- Make /home a volatile path.  This would avoid issues with applications
  wanting to write to dotfiles and the like.  We'll need to determine how to
  prepopulate the contents of /home/root/ and the like, however.  If tmpfiles.d
  usage is sufficient, we can stick to that, otherwise we may need to set up
  something on boot to populate home dir(s) based on /etc/skel/, or use pam
  and have it populate at first login.

- Make /etc/resolv.conf volatile for the r/o case, and likely also for the
  resolvconf case, as it generates it from templates and other sources.

- Convert each bbappend in disabled/ to follow the same pattern as dbus.
  See [README.md](README.md) for the steps to follow.

  - base-files:
  I believe most of this is already handled by the /run changes that went in
  upstream, and the `read_only_rootfs_hook` (for the fstab bits). What remains
  is, I believe, handling of /var/lib/misc. We should determine whether we
  want to continue to do it there, or if we should alter the default configs
  in the tmpfiles packages. We can't put it in the recipe(s) themselves which
  use them, as there can only be a single definitive owner of a given volatile
  path.
