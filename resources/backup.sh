#!/bin/ash

# Specify the absolute backup path
backup_path="/Backup_volumes/"

# Delete all 15 days old files
find $backup_path -type f -mtime +15 -exec rm {} \;

# Create a new backup then change it's permissions
tar -czf $backup_path/$(date -I).tar.gz /Nextcloud /volumes
chown root:root $backup_path/$(date -I).tar.gz
chmod 400 $backup_path/$(date -I).tar.gz		
