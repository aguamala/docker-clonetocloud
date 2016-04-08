# docker-clonetocloud

Backup or synchronize directories to cloud storage. Lsyncd + rclone

## USAGE

The following environment variables are honored for configuring clonetocloud:

-	`-e RCLONE_ACCESS_KEY_ID=...` (S3 ACCESS KEY )
-	`-e RCLONE_SECRET_ACCESS_KEY=...` (S3 SECRET KEY)
-	`-e RCLONE_TYPE=...` (Only s3 for now, override lsyncd and rclone config to use another backend)
-	`-e LSYNCD_SOURCE=...` (Source directory)
-	`-e LSYNCD_TARGET=...` (rclone remote) example: remote:bucket/path
-	`-e LSYNCD_SYNC=...` (Set to enable sync mode, deletes will take effect)
-	`-e LSYNCD_DELAY=...` (defaults to "5", lsyncd delay seconds)
-	`-e LSYNCD_ONSTARTUP_OFF=...` (Set to disable onStartup sync source target)

Quickstart:  

    $ docker run -d \
        --name=clonetocloud \
        -e "RCLONE_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        -e "RCLONE_SECRET_ACCESS_KEY=XXXXXXXXXXXXX" \
        -e "RCLONE_TYPE=s3" \
        -e "LSYNCD_SOURCE=/var/www/html" \
        -e "LSYNCD_TARGET=remote:bucket/path" \
        --volume=/etc/localtime:/etc/localtime \
        aguamala/clonetocloud:latest


By default clonetocloud starts in backup mode, this means
that removing local files won't take any action.
To enable sync mode, set LSYNCD_SYNC variable to any value.

## override lsyncd configuration

You can override lsyncd configuration by sharing or copying your own custom
configuration to /lsyncd.conf

Example:

    $ docker run -d \
        --name=clonetocloud \
        -e "RCLONE_ACCESS_KEY_ID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" \
        -e "RCLONE_SECRET_ACCESS_KEY=XXXXXXXXXXXXX" \
        -e "RCLONE_TYPE=s3" \
        --volume=lsyncd.conf:/lsyncd.conf \
        --volume=/etc/localtime:/etc/localtime \
        aguamala/clonetocloud:latest


## override rclone configuration

You can override rclone configuration by sharing or copying your own custom
configuration to /root/.rclone.conf

Example:

    $ docker run -d \
        --name=clonetocloud \
        -e "LSYNCD_SOURCE=/var/www/html" \
        -e "LSYNCD_TARGET=remote:bucket/path" \
        --volume=rclone.conf:/root/.rclone.conf \
        --volume=/etc/localtime:/etc/localtime \
        aguamala/clonetocloud:latest
