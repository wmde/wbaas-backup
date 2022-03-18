# wbaas-backup

## Running scripts locally

To run these scripts locally the easiest way is probably to manually trigger the backup CronJob in the ui.

However, when developing it can be nice to run individual scripts on the host system.

***This will however require you to install the dependencies locally and have the `/backup` folder on your filesystem.***

To take a full logical backup using the [src/backup.sh](src/backup.sh) you can forward a port to the host.

```sh
kubectl port-forward sql-mariadb-secondary-0 3306:3306
```

After that you can specify the following env vars and run `backup.sh`.

```sh
DB_USER=root DB_PORT=3306 DB_HOST=127.0.0.1 DB_PASSWORD=<YOUR_PASSWORD> bash src/backup.sh 
```

The script should output a tar in the `/backups/` folder.

After that you can restore the backup by specify the following env vars and run `backup.sh`.

```sh
DB_USER=root DB_PORT=3306 DB_HOST=127.0.0.1 DB_PASSWORD=<YOUR_PASSWORD> bash src/restore.sh <THE_FOLDER_WITH_EXTRACTED_TAR>
```
## Decompressing archives

To decompress a downloaded encrypted archive use the following bash script

```
BACKUP_KEY=<FILL_OUT> ./decompress_archive.sh /home/user/Downloads/mydumper-backup-2022-03-18_150902.tar.gz /tmp/staging
```

## Disaster scenarios

## All databases gone on primary

Forward the primary SQL port to host

```sh
kubectl port-forward sql-mariadb-primary-0 3306:3306
```

One-liner to drop all existing databases

```sh
mysql -uroot -p<LOCAL_SQL_PASSWORD> --port=3306 --host=127.0.0.1 -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| gawk '{print "drop database `" $1 "`;select sleep(0.1);"}' | mysql -uroot -p<LOCAL_SQL_PASSWORD> --port=3306 --host=127.0.0.1 
```