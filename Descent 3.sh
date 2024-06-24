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
GAME="Descent3"

cd $GAMEDIR

if [ -f "${controlfolder}/libgl_${CFW_NAME}.txt" ]; then 
  source "${controlfolder}/libgl_${CFW_NAME}.txt"
else
  source "${controlfolder}/libgl_default.txt"
fi

# Create config dir
rm -rf "$XDG_DATA_HOME/Outrage Entertainment/Descent 3"
ln -s $GAMEDIR "$XDG_DATA_HOME/Outrage Entertainment/Descent 3"

# Setup gl4es environment
export LIBGL_ES=2
export LIBGL_GL=21
export LIBGL_FB=4

export SDL_VIDEO_GL_DRIVER="$GAMEDIR/gl4es.$DEVICE_ARCH/libGL.so.1"
export LIBGL_DRIVERS_PATH="$GAMEDIR/gl4es.$DEVICE_ARCH/libGL.so.1"
export LD_LIBRARY_PATH="$GAMEDIR/libs.$DEVICE_ARCH:/usr/lib:$LD_LIBRARY_PATH"

# Setup controls
$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput

$GPTOKEYB "$GAME" -c "joy.gptk" & 
SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
./$GAME -setdir "$GAMEDIR/gamedata" -pilot Player -nomotionblur -g $LIBGL_DRIVERS_PATH

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events & 
printf "\033c" >> /dev/tty1