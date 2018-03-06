#!/bin/bash

# Backup (r)ecursively
# Preserve (t)ime, (p)ermission, (o)wner and (g)roup
# Skip files that are newer ((u)pdate)
# No space (s)plitting, wildcard char only
# Turn on (v)erbose, show (progress) bar
# (Delete) file which is not in sourced

echo "start making backup.."
if [ ! -d /home/near/Dropbox/near/  ]; then
   mkdir -p /home/near/Dropbox/near/
fi
rsync -rtpogusv --progress --delete --exclude-from="/home/near/bin/rsync-backup-exclude.txt" /home/near/ /home/near/Dropbox/near/
echo "backup home dir completed"

if [ ! -d /home/near/Dropbox/root/terminal-colorshceme/  ]; then
   mkdir -p /home/near/Dropbox/root/terminal-colorshceme/
fi
rsync -rtpogusv --progress --delete /usr/share/xfce4/terminal/colorschemes/ /home/near/Dropbox/root/terminal-colorshceme
echo "backup music terminal colorshcmes done"

if [ ! -d /home/near/Dropbox/root/systemd/system/  ]; then
   mkdir -p /home/near/Dropbox/root/systemd/system/
fi
rsync -rtpogusv --progress --delete /etc/systemd/system/ /home/near/Dropbox/root/systemd/system
echo "backup music systemd files done"
echo "backup completed!"

# create pacman database backup
printf "Compressing pacman database.."
sudo tar -cjvf pacman_database.tar.bz2 /var/lib/pacman/local
# move to somewhere safe
sudo mv /pacman_database.tar.bz2 /home/near/Dropbox/

# restore pacman_database.tar.bz2
# mv /home/near/Dropbox/pacman_database.tar.bz2 /var/lib/pacman/local/
# tar -xjvf pacman_database.tar.bz2
