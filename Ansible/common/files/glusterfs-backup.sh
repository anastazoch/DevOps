#!/bin/bash

tar --acls --xattr /root/glusterfs-backup.tar.gz /etc/glusterfs /var/lib/glusterd 

exit 0
