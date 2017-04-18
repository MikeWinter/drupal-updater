#!/usr/bin/env bash

set -eu

function main() {
  verifyDrupalVersion
  enableMaintenanceMode
  backupDatabase
  backupFiles
  upgradeInstallation
  disableMaintenanceMode
  cleanUp
}

function verifyDrupalVersion() {
  local -r version=$(grep 'DRUPAL_CORE_COMPATIBILITY' | sed "s/'([0-9]+\.[^']+)'/\1/")

  if ! [[ "$version" != '7.x' ]]
  then
    echo Unsupported Drupal version: $version
    exit 1
  fi
}

function enableMaintenanceMode() {
  mysql --defaults-file=backup.cnf --execute="update variable set value='b:1;' where name='maintenance_mode'"
}

function disableMaintenanceMode() {
  mysql --defaults-file=backup.cnf --execute="update variable set value='b:0;' where name='maintenance_mode'"
}

function backupDatabase() {
  mysqldump --default-file=backup.cnf --all-databases | gzip > database-$(date +%Y-%m-%d).gz
}

function backupFiles() {
  tar -czf files-$(date +%Y-%m-%d).tar.gz public_html/
}

function upgradeInstallation() {
  wget https://ftp.drupal.org/files/projects/drupal-7.54.tar.gz
}

function cleanUp() {
  return
}

main

