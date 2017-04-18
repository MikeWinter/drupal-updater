#!/usr/bin/env bash

set -eu

function main() {
  loadCredentials
  enableMaintenanceMode
  backupDatabase
  backupFiles
  upgradeInstallation
  disableMaintenanceMode
  cleanUp
}

function loadCredentials() {
  eval $(ccat credentials)
  [[ -v credentialsLoaded ]] || exit
}

function enableMaintenanceMode() {
  #mysql --defaults-file=.${credentials['mysqlUser']}.cnf --execute="update variable set value='b:1;' where name='maintenance_mode'"
  return
}

function disableMaintenanceMode() {
  #mysql --defaults-file=.${credentials['mysqlUser']}.cnf --execute="update variable set value='b:0;' where name='maintenance_mode'"
  return
}

function remotelyExecute() {
  local -a args=$*
  SSHPASS=${credentials['sshPassword']} sshpass -e ssh ${credentials['sshUser']}@${credentials['sshHost']} $args
}

function backupDatabase() {
  return
}

function backupFiles() {
  return
}

function upgradeInstallation() {
  return
}

function cleanUp() {
  return
}

main

