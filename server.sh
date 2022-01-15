#!/bin/bash

UNTURNED_DIRECTORY_ROOT="/home/heraclio/.local/share/Steam/steamapps/common/U3DS"

if ! command -v jq &> /dev/null
then
    echo "\"jq\" could not be found, please install library."
    exit
fi

#FETCH STEAMCMD
cd ${UNTURNED_DIRECTORY_ROOT} && curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -xz

#FETCH OPENMOD
cd ${UNTURNED_DIRECTORY_ROOT} && curl -s https://api.github.com/repos/openmod/OpenMod/releases/latest | jq -r ".assets[] | select(.name | contains(\"OpenMod.Unturned.Module\")) | .browser_download_url" | wget -i -
	unzip -o -q ./OpenMod.Unturned.Module*.zip -d ./Modules && rm ./OpenMod.Unturned.Module*.zip

#UPDATE
${UNTURNED_DIRECTORY_ROOT}/steamcmd.sh +force_install_dir ${UNTURNED_DIRECTORY_ROOT} +login anonymous +@sSteamCmdForcePlatformBitness 64 +app_update 1110390 +quit

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${UNTURNED_DIRECTORY_ROOT}/Unturned_Headless_Data/Plugins/x86_64/

# Terminal mode compatible with -logfile 2>&1 IO.
export TERM=xterm

#START
${UNTURNED_DIRECTORY_ROOT}/Unturned_Headless.x86_64 -batchmode -nographics +InternetServer/Development
