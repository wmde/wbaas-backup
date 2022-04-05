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
DB_USER=<YOUR_USER> DB_PORT=3306 DB_HOST=127.0.0.1 DB_PASSWORD=<YOUR_PASSWORD> bash src/backup.sh 
```

The script should output a tar in the `/backups/` folder.

After that you can restore the backup by specify the following env vars and run `backup.sh`.

```sh
DB_USER=<YOUR_USER> DB_PORT=3306 DB_HOST=127.0.0.1 DB_PASSWORD=<YOUR_PASSWORD> bash src/restore.sh <THE_FOLDER_WITH_EXTRACTED_TAR>
```
## Decompressing archives

To decompress a downloaded encrypted archive use the following bash script

```
BACKUP_KEY=<FILL_OUT> ./decompress_archive.sh /home/user/Downloads/mydumper-backup-2022-03-18_150902.tar.gz /tmp/staging
```

## Disaster scenarios

## Re-install the SQL deployment and PVC:s

### Uninstall databases

Update the helmfile and mark the SQL chart as not installed

```yml
  - name: sql
    namespace: default
    installed: false
```

apply to the environment.

### Drop the PVC/PV:s

Delete claims.

```sh
kubectl delete -n default persistentvolumeclaim data-sql-mariadb-primary-0
kubectl delete -n default persistentvolumeclaim data-sql-mariadb-secondary-0
```

Usually, the above command removes the volumes as they become unbound, if that isn't the case delete them manually either through the UI or.

```sh
kubectl delete persistentvolume <VOLUME_ID_FOR_PRIMARY>
kubectl delete persistentvolume <VOLUME_ID_FOR_SECONDARY>
```

Update the helmfile and mark the SQL chart as installed and apply to the environment.
Simply removing `installed` will also default it to true.

```yml
  - name: sql
    namespace: default
    installed: true
```

After the installation has settled, get a mysql shell and drop the remaining databases on both primary/secondaries.

```sql
DROP DATABASE apidb; DROP DATABASE mediawiki; DROP DATABASE mysql; DROP DATABASE test; DROP DATABASE performance_schema; DROP DATABASE my_database;
```

The SQL deployment should now be completely empty and ready for a restore.

## Drop all databases on primary

Forward the primary SQL port to host

```sh
kubectl port-forward sql-mariadb-primary-0 3306:3306
```

One-liner to drop all existing databases

```sh
mysql -uroot -p<LOCAL_SQL_PASSWORD> --port=3306 --host=127.0.0.1 -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| gawk '{print "drop database `" $1 "`;select sleep(0.1);"}' | mysql -uroot -p<LOCAL_SQL_PASSWORD> --port=3306 --host=127.0.0.1 
```
