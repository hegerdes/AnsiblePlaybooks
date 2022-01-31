#!/bin/bash

LOGFILE=/db_dumps/db_backup.log
echo -n "Creating db dump to: /db_dumps/$(date '+%Y-%m-%d')-${HOSTNAME}.tar.gz.dump..." >> $LOGFILE
mkdir -p /db_dumps/$(date '+%Y-%m-%d')-${HOSTNAME}
influx backup /db_dumps/$(date '+%Y-%m-%d')-${HOSTNAME}
tar -cvf /db_dumps/$(date '+%Y-%m-%d')-${HOSTNAME}.tar.gz.dump $(date '+%Y-%m-%d')-${HOSTNAME}/ >> $LOGFILE
rm -r /db_dumps/$(date '+%Y-%m-%d')-${HOSTNAME}
echo "done" >> $LOGFILE

# Restore
# tar -xzvf $(date '+%Y-%m-%d')-${HOSTNAME}.tar.gz
# influx restore <BACKUP_DIR>