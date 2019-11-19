#!/bin/sh

# "to avoid continuing when errors or undefined variables are present"
set -eu

echo "Starting FTP Deploy"

WDEFAULT_LOCAL_DIR=${LOCAL_DIR:-"."}
WDEFAULT_REMOTE_DIR=${REMOTE_DIR:-"."}
WDEFAULT_ARGS=${ARGS:-""}
WDEFAULT_METHOD=${METHOD:-"ftp"}

if [ $WDEFAULT_METHOD = "sftp" ]; then
  WDEFAULT_PORT=${PORT:-"22"}
  echo "Establishing SFTP connection..."
  sshpass -p $FTP_PASSWORD sftp -o StrictHostKeyChecking=no -P $WDEFAULT_PORT $FTP_USERNAME@$FTP_SERVER
  echo "Connection established"
else
  WDEFAULT_PORT=${PORT:-"21"}
fi;

echo "Using $WDEFAULT_METHOD to connect to port $WDEFAULT_PORT"

echo "Uploading files..."

# lftp -u $FTP_USERNAME,$FTP_PASSWORD $WDEFAULT_METHOD://$FTP_SERVER:$WDEFAULT_PORT -e "set ftp:ssl-allow no; mirror $WDEFAULT_ARGS -R $WDEFAULT_LOCAL_DIR $WDEFAULT_REMOTE_DIR; quit"
lftp -u $FTP_USERNAME,$FTP_PASSWORD sftp://$FTP_SERVER -e "set ftp:ssl-allow no; mirror --delete --verbose --exclude='.*' --include='^wp-content\/(themes\/.*)?$' --include='^wp-content\/(plugins\/.*)?$' --exclude='^wp-content\/plugins\/jetpack\/.*' --exclude='^wp-content\/plugins\/woocommerce\/.*' -R ./wp-content/themes/soledad-child html/ html/wp-content/themes/soledad-child; quit"


echo "FTP Deploy Complete"
exit 0
