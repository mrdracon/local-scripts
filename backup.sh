#!/bin/bash
BACKUP_STORAGE=/mnt/backup

case "$1" in
 'daily')
  BACKUP_TARGET=$BACKUP_STORAGE/daily
 ;;

 'weekly')
  BACKUP_TARGET=$BACKUP_STORAGE/weekly
 ;;

 'monthly')
  BACKUP_TARGET=$BACKUP_STORAGE/monthly
 ;;

 *) print "Invalid option in backup schedule parameter\n"
 exit 1
 ;;
esac

cd /var/lib/vz-sync2ftp/dump
if [[ "$?" -ne 0 ]] ; then
  printf "Couldn't change directory to vz dumps\n"
  exit 1
fi

mount "$BACKUP_STORAGE"
if [[ "$?" -ne 0 ]] ; then
  printf "Mount failed\n"
  exit 1
fi

rm -rf $BACKUP_TARGET/*

rsync -avh --no-R --files-from=<(find . -type f -mtime -1) \
       ./ "$BACKUP_TARGET"

#for file in vzdump-qemu-* ; do
#  echo "$file" 
#  if [[ ! -s  "$file" ]] ; then
#    printf "File $file has zero size, someting broke in Proxmox\n"
#    umount "$BACKUP_STORAGE"
#    exit 1
#  fi
#done

umount "$BACKUP_STORAGE"
printf "Backup completed\n"

cat /tmp/backup.out | mail -s "Proxmox backup finished" -r hetzner@sapiens.solutions yurafrol@mail.ru

#/usr/bin/lftp -u u104994,5z6PFGsi6sO6SXnx \
#    -e "set net:reconnect-interval-base 60; set net:max-retries 3; \
#        set net:timeout 60; set ssl:verify-certificate no; \
#        mirror --ignore-time --reverse --delete --verbose \
#        /var/lib/vz-sync2ftp/dump /vz-sync2ftp; \
#        bye;" \
#    u104994.your-backup.de > /tmp/lftp.out 2>&1

#if [ $? -ne 0 ]; then
#  exit 1;
#fi

#err=`/bin/cat /tmp/lftp.out | /bin/grep "error detected" | wc -l`
#if [ $err -ne 0 ]; then
#  exit 1;
#fi
