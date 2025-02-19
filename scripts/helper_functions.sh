#!/bin/bash
# This file contains functions which can be used in multiple scripts

# Checks if a given path is a directory
# Returns 0 if the path is a directory
# Returns 1 if the path is not a directory or does not exists and produces an output message
dirExists() {
    local path="$1"
    local return_val=0
    if ! [ -d "${path}" ]; then
        echo "${path} does not exist."
        return_val=1
    fi
    return "$return_val"
}

# Checks if a given path is a regular file
# Returns 0 if the path is a regular file
# Returns 1 if the path is not a regular file or does not exists and produces an output message
fileExists() {
    local path="$1"
    local return_val=0
    if ! [ -f "${path}" ]; then
        echo "${path} does not exist."
        return_val=1
    fi
    return "$return_val"
}

# Checks if a given path exists and is readable
# Returns 0 if the path exists and is readable
# Returns 1 if the path is not readable or does not exists and produces an output message
isReadable() {
    local path="$1"
    local return_val=0
    if ! [ -e "${path}" ]; then
        echo "${path} is not readable."
        return_val=1
    fi
    return "$return_val"
}

# Checks if a given path is writable
# Returns 0 if the path is writable
# Returns 1 if the path is not writable or does not exists and produces an output message
isWritable() {
    local path="$1"
    local return_val=0
    # Directories may be writable but not deletable causing -w to return false
    if [ -d "${path}" ]; then
        temp_file=$(mktemp -q -p "${path}")
        if [ -n "${temp_file}" ]; then
            rm -f "${temp_file}"
        else
            echo "${path} is not writable."
            return_val=1
        fi
    # If it is a file it must be writable
    elif ! [ -w "${path}" ]; then
        echo "${path} is not writable."
        return_val=1
    fi
    return "$return_val"
}

# Checks if a given path is executable
# Returns 0 if the path is executable
# Returns 1 if the path is not executable or does not exists and produces an output message
isExecutable() {
    local path="$1"
    local return_val=0
    if ! [ -x "${path}" ]; then
        echo "${path} is not executable."
        return_val=1
    fi
    return "$return_val"
}

# Lists players
# Outputs nothing if RCON is not enabled and returns 1
# Outputs player list if RCON is enabled and returns 0
get_players_list() {
    local return_val=0
    if [ "${RCON_ENABLED,,}" != true ]; then
        return_val=1
    fi

    # tail -n +2 removes the header "name,playeruid,steamid"
    RCON "ShowPlayers" | tail -n +2
    return "$return_val"
}

# Checks how many players are currently connected
# Outputs 0 if RCON is not enabled and returns 1
# Outputs the player count if rcon is enabled and returns 0
get_player_count() {
    local player_list
    local return_val=0
    if ! player_list=$(get_players_list); then
        return_val=1
    fi
    
    echo -n "${player_list}" | wc -l
    return "$return_val"
}

#
# Log Definitions
#
export LINE='\n'
export RESET='\033[0m'       # Text Reset
export WhiteText='\033[0;37m'        # White

# Bold
export RedBoldText='\033[1;31m'         # Red
export GreenBoldText='\033[1;32m'       # Green
export YellowBoldText='\033[1;33m'      # Yellow
export CyanBoldText='\033[1;36m'        # Cyan

LogInfo() {
  Log "$1" "$WhiteText"
}
LogWarn() {
  Log "$1" "$YellowBoldText"
}
LogError() {
  Log "$1" "$RedBoldText"
}
LogSuccess() {
  Log "$1" "$GreenBoldText"
}
LogAction() {
  Log "$1" "$CyanBoldText" "****" "****"
}
Log() {
  local message="$1"
  local color="$2"
  local prefix="$3"
  local suffix="$4"
  printf "$color%s$RESET$LINE" "$prefix$message$suffix"
}

# Send Discord Message
# Level is optional variable defaulting to info
DiscordMessage() {
  local message="$1"
  local level="$2"
  if [ -z "$level" ]; then
    level="info"
  fi
  if [ -n "${DISCORD_WEBHOOK_URL}" ]; then
    /home/steam/server/discord.sh "$message" "$level" &
  fi
}

# RCON Call
RCON() {
  local args="$1"
  rcon-cli -c /home/steam/server/rcon.yaml "$args"
}

# Given a message this will broadcast in game
# Since RCON does not support spaces this will replace all spaces with underscores
# Returns 0 on success
# Returns 1 if not able to broadcast
broadcast_command() {
    local return_val=0
    # Replaces spaces with underscore
    local message="${1// /_}"
    if [[ $TEXT = *[![:ascii:]]* ]]; then
        LogWarn "Unable to broadcast since the message contains non-ascii characters: \"${message}\""
        return_val=1
    elif ! RCON "broadcast ${message}"; then
        return_val=1
    fi
    return "$return_val"
}

# Saves the server
# Returns 0 if it saves
# Returns 1 if it is not able to save
save_server() {
    local return_val=0
    if ! RCON save; then
        return_val=1
    fi
    return "$return_val"
}

# Saves then shutdowns the server
# Returns 0 if it is shutdown
# Returns 1 if it is not able to be shutdown
shutdown_server() {
    local return_val=0
    # Do not shutdown if not able to save
    if save_server; then
        if ! RCON "DoExit"; then
            return_val=1
        fi
    else
        return_val=1
    fi
    return "$return_val"
}
