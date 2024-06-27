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

# Variables
GAMEDIR="/$directory/ports/descent3"
DEVICE_ARCH="${DEVICE_ARCH:-aarch64}"
INIFILE="$GAMEDIR/d3.ini"
REGFILE="$GAMEDIR/.Descent3Registry"
DEBUGMODE=0

cd $GAMEDIR

# Setup permissions
$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput
echo "Loading, please wait... (might take a while!)" > /dev/tty0

# Declare key mapping and types
declare -A key_mapping
key_mapping=(
    ["ProceduralTextures"]="DetailProcedurals"
    ["Fog"]="DetailFog"
    ["LightCoronas"]="DetailCoronas"
    ["WeaponCoronas"]="DetailWeaponCoronas"
    ["ObjectComplexity"]="DetailObjectComp"
    ["PowerupHalos"]="DetailPowerupHalos"
    ["ScorchMarks"]="DetailScorchMarks"
    ["DynamicLighting"]="Dynamic_Lighting"
    ["ForceFeedback"]="EnableJoystickFF"
    ["SimpleHeadlight"]="FastHeadlight"
    ["Gamma"]="RS_gamma"
    ["TerrainDetail"]="RS_pixelerror"
    ["MipMapping"]="RS_mipping"
    ["ShaderType"]="RS_light"
    ["RenderDistance"]="RS_terraindist"
    ["TextureQuality"]="RS_texture_quality"
    ["VSync"]="RS_vsync"
    ["BilinearFiltering"]="RS_bilear"
    ["GuidedMissileView"]="MissileView"
    ["MusicVolume"]="MUS_mastervol"
    ["MirrorSurfaces"]="MirrorSurfaces"
    ["MineAutoleveling"]="RoomLeveling"
    ["SoundQuality"]="SoundQuality"
    ["SoundQuantity"]="SoundQuantity"
    ["SoundVolume"]="SND_mastervol"
    ["SpecularMapping"]="Specmapping"
    ["TerrainAutoleveling"]="TerrLeveling"
)

declare -A key_types
key_types=(
    ["RS_gamma"]="string"
    ["RS_terraindist"]="string"
    ["Dynamic_Lighting"]="dword"
    ["RS_vsync"]="dword"
    ["RS_bilear"]="dword"
    ["RS_mipping"]="dword"
    ["RS_light"]="dword"
    ["RS_texture_quality"]="dword"
    ["SND_mastervol"]="string"
    ["MUS_mastervol"]="string"
    ["EnableJoystickFF"]="dword"
    ["SoundQuality"]="dword"
    ["SoundQuantity"]="dword"
    ["DetailObjectComp"]="dword"
    ["RS_pixelerror"]="string"
    ["TerrLeveling"]="dword"
    ["RoomLeveling"]="dword"
    ["DetailScorchMarks"]="dword"
    ["DetailFog"]="dword"
    ["DetailCoronas"]="dword"
    ["DetailWeaponCoronas"]="dword"
    ["DetailProcedurals"]="dword"
    ["DetailPowerupHalos"]="dword"
    ["Specmapping"]="dword"
    ["MirrorSurfaces"]="dword"
    ["FastHeadlight"]="dword"
    ["MissileView"]="dword"
)

# Function to update the .Descent3Registry file based on user-friendly ini values
parse_ini() {
  local key=$1
  local value=$2
  local type=$3
  local file=$4
  
  local entry
  
  if [[ "$type" == "dword" ]]; then
    # Check if value is integer or float
    if [[ "$value" =~ ^[0-9]+$ ]]; then
      value=$(printf "%X" "$value")  # Convert integer to hexadecimal
    elif [[ "$value" =~ ^[0-9]+\.[0-9]+$ ]]; then
      value=$(printf "%X" "${value%.*}")  # Convert float to hexadecimal (integer part)
    fi
    entry="\"$key\"=dword:$value"
  elif [[ "$type" == "string" ]]; then
    # Trim leading and trailing whitespace from value
    value=$(echo "$value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    entry="\"$key\"=\"$value\""  # Treat value as a string, wrap in double quotes
  else
    echo "Unsupported registry type for key: $key"
    return 1
  fi
  
  # Check if key exists, if not add it
  if grep -q "^\"$key\"=\".*\"" "$file"; then
    sed -i "s|^\"$key\"=\".*\"|$entry|" "$file" || echo "Failed to update $file"
  else
    echo "$entry" >> "$file" || echo "Failed to append to $file"
  fi
}

# Read the ini file and update settings
while IFS='=' read -r key value_comment; do
  # Trim spaces and remove comments
  key=$(echo "$key" | sed 's/^[ \t]*//;s/[ \t]*$//')  # Trim spaces
  value=$(echo "$value_comment" | sed 's/^[ \t]*//;s/[ \t]*$//' | sed 's/;.*$//' | tr -d '\r')  # Trim spaces, remove comments, and remove carriage return characters
  
  # Skip empty lines or lines starting with [
  [[ -z "$key" || "$key" =~ ^\[ ]] && continue
  
  # Map key to registry key
  registry_key=${key_mapping[$key]}
  
  if [[ -n "$registry_key" ]]; then
    # Get registry type (assuming it exists in key_types array)
    registry_type=${key_types[$registry_key]}

    # If a mapping exists, update the registry file
    parse_ini "$registry_key" "$value" "$registry_type" "$REGFILE"
  else
    echo "No mapping found for key: $key"
  fi
done < "$INIFILE"

#####################
# PORTMASTER SCRIPT #
#####################

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

# Run the game
$GPTOKEYB "$GAME" -c "joy.gptk" & 
SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
./$GAME -setdir "$GAMEDIR/gamedata" -pilot Player -nomotionblur $ARG

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events & 
printf "\033c" >> /dev/tty1