#!/bin/bash

SCRIPT_PATH="scripts/config_api.sh"
SCRIPT_PATH_REL="./config_api.sh"

bash "scripts/config_api.sh" wasmtime
sh "scripts/config_api.sh" wasmtime
source "scripts/config_api.sh" wasmtime
/bin/bash "scripts/config_api.sh" wasmtime
. "scripts/config_api.sh" wasmtime
bash $SCRIPT_PATH wasmtime
sh $SCRIPT_PATH wasmtime
source $SCRIPT_PATH wasmtime
/bin/bash $SCRIPT_PATH wasmtime
. $SCRIPT_PATH wasmtime

bash $SCRIPT_PATH_REL wasmtime
sh $SCRIPT_PATH_REL wasmtime
source $SCRIPT_PATH_REL wasmtime
/bin/bash $SCRIPT_PATH_REL wasmtime
. $SCRIPT_PATH_REL wasmtime

chmod +x scripts/config_api.sh
chmod a+x scripts/config_api.sh
dos2unix scripts/config_api.sh
chmod +x $SCRIPT_PATH
chmod a+x $SCRIPT_PATH
dos2unix $SCRIPT_PATH
chmod +x $SCRIPT_PATH_REL
chmod a+x $SCRIPT_PATH_REL
dos2unix $SCRIPT_PATH_REL

bash "scripts/config_api.sh" wasmtime
sh "scripts/config_api.sh" wasmtime
source "scripts/config_api.sh" wasmtime
/bin/bash "scripts/config_api.sh" wasmtime
. "scripts/config_api.sh" wasmtime
bash $SCRIPT_PATH wasmtime
sh $SCRIPT_PATH wasmtime
source $SCRIPT_PATH wasmtime
/bin/bash $SCRIPT_PATH wasmtime
. $SCRIPT_PATH wasmtime

bash $SCRIPT_PATH_REL wasmtime
sh $SCRIPT_PATH_REL wasmtime
source $SCRIPT_PATH_REL wasmtime
/bin/bash $SCRIPT_PATH_REL wasmtime
. $SCRIPT_PATH_REL wasmtime
