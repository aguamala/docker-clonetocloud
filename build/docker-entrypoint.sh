#!/bin/bash

set -e

if [ "$1" = 'lsyncd' ]; then

    if [ ! -e /root/.rclone.conf ]; then
          if [[ -z "$RCLONE_ACCESS_KEY_ID" ]] || [ -z "$RCLONE_SECRET_ACCESS_KEY" ] || ["$RCLONE_TYPE"]; then
            echo >&2 'error: missing RCLONE_ACCESS_KEY_ID or RCLONE_SECRET_ACCESS_KEY or RCLONE_TYPE environment variables'
            exit 1
          fi

          if [ -n "$RCLONE_REMOTE_NAME" ]; then
            echo "[remote]" >> /root/.rclone.conf
          fi

          if [ "$RCLONE_TYPE" ! 's3' ]; then
            #FIXME: support more backends
            echo >&2 'sorry, only s3 quickstart is supported for the moment, please copy or share rclone.conf to /root/.rclone.conf'
            exit 1
          else
            #env auth false
            echo "type = s3" >> /root/.rclone.conf && \
            echo "env_auth = false" >> /root/.rclone.conf && \
            echo "access_key_id = $RCLONE_ACCESS_KEY_ID" >> /root/.rclone.conf && \
            echo "secret_access_key = $RCLONE_SECRET_ACCESS_KEY" >> /root/.rclone.conf

            if [ -n "$RCLONE_S3_REGION" ]; then
              echo "region = $RCLONE_S3_REGION" >> /root/.rclone.conf
            else
              echo "region =" >> /root/.rclone.conf
            fi

            if [ -n "$RCLONE_S3_ENDPOINT" ]; then
              echo "endpoint = $RCLONE_S3_ENDPOINT" >> /root/.rclone.conf
            else
              echo "endpoint =" >> /root/.rclone.conf
            fi

            if [ -n "$RCLONE_S3_LOCATION_CONSTRAINT" ]; then
              echo "location_constraint = $RCLONE_S3_LOCATION_CONSTRAINT" >> /root/.rclone.conf
            else
              echo "location_constraint =" >> /root/.rclone.conf
            fi
          fi
    fi

    if [ ! -e /lsyncd.conf ]; then

          if [ -n "$LSYNCD_SYNC" ]; then
            cat /lsyncd-sync.conf > /lsyncd.conf
          else
            cat /lsyncd-backup.conf > /lsyncd.conf
          fi


          if [[ -z "$LSYNCD_SOURCE" ]] || [ -z "$LSYNCD_TARGET" ]; then
            echo >&2 'error: missing LSYNCD_SOURCE or LSYNCD_TARGET environment variables'
            exit 1
          fi

          sed -i -e"s|source =|source = \"$LSYNCD_SOURCE\"|g" /lsyncd.conf && \
          sed -i -e"s|target =|target = \"$LSYNCD_TARGET\"|g" /lsyncd.conf

          if [ -n "$LSYNCD_DELAY" ]; then
            sed -i -e"s|delay = 5|delay = $LSYNCD_DELAY|g" /lsyncd.conf
          fi

          if [ -n "$LSYNCD_MAX_PROCESSES" ]; then
            sed -i -e"s|maxProcesses = 1|maxProcesses = $LSYNCD_MAX_PROCESSES|g" /lsyncd.conf
          fi

          if [ -n "$LSYNCD_ONSTARTUP_OFF" ]; then
            sed -i -e"s|onStartup = \"rclone sync \^source \^target\/\"\,||g" /lsyncd.conf
          fi
    fi
fi

exec "$@"
