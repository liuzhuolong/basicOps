## sshfs

```shell
# mount
sshfs [user@]hostname:[directory] mountpoint

# configure: allow other user access the mounted files
-o allow_other 

# unmount
fusermount -u mountpoint
```

