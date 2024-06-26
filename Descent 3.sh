#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/$directory/ports/descent3"
DEVICE_ARCH="${DEVICE_ARCH:-aarch64}"
DEBUGMODE=0

# Get the CFW to determine which binary to use
if [ $DEBUGMODE == 0 ]; then
  if [ $CFW_NAME == "ArkOS" ] || [ "$CFW_NAME" == 'ArkOS wuMMLe' ] || [ "$CFW_NAME" == "knulli" ]; then
    GAME="game_comp"
  else
    GAME="game"
  fi
else
  if [ $CFW_NAME == "ArkOS" ] || [ "$CFW_NAME" == 'ArkOS wuMMLe' ] || [ "$CFW_NAME" == "knulli" ]; then
    GAME="bin/dbg_comp"
  else
    GAME="bin/dbg"
  fi
fi

cd $GAMEDIR

# Create config dir
rm -rf "$XDG_DATA_HOME/Outrage Entertainment/Descent 3"
ln -s $GAMEDIR "$XDG_DATA_HOME/Outrage Entertainment/Descent 3"

# Delete everything in the cache directory
rm -rf "$GAMEDIR/gamedata/custom/cache/"
mkdir "$GAMEDIR/gamedata/custom/cache/"

# Setup gl4es environment
if [ -f "${controlfolder}/libgl_${CFW_NAME}.txt" ]; then 
  source "${controlfolder}/libgl_${CFW_NAME}.txt"
else
  source "${controlfolder}/libgl_default.txt"
fi

if [ "$LIBGL_FB" != "" ]; then
  export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es.aarch64/libGL.so.1"
  export LIBGL_DRIVERS_PATH="$GAMEDIR/gl4es.$DEVICE_ARCH/libGL.so.1"
  ARG="-g $LIBGL_DRIVERS_PATH"
fi 

export LD_LIBRARY_PATH="$GAMEDIR/libs.$DEVICE_ARCH:/usr/lib:$LD_LIBRARY_PATH"

# Setup controls
$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput

$GPTOKEYB "$GAME" -c "joy.gptk" & 
SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
./$GAME -setdir "$GAMEDIR/gamedata" -pilot Player -nomotionblur $ARG

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events & 
printf "\033c" >> /dev/tty1