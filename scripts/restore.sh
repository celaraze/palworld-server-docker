#!/bin/bash
# shellcheck source=scripts/helper_functions.sh
source "/home/steam/server/helper_functions.sh"

# Backup file directory path
BACKUP_DIRECTORY_PATH="/palworld/backups"

# Restore path
RESTORE_PATH="/palworld/Pal"

# Copy the save file before restore temporary path
TMP_SAVE_PATH="/palworld/backups/restore-"$(date +"%Y-%m-%d_%H-%M-%S")

# shellcheck disable=SC2317
term_error_handler() {
    LogError "An error occurred during server shutdown."
    exit 1
}

# shellcheck disable=SC2317
restore_error_handler() {
    LogError "Error occurred during restore."
    if [ -d "$TMP_SAVE_PATH/Saved" ]; then
        read -rp "I have a backup before recovery can proceed. Do you want to recovery it? (y/n): " RUN_ANSWER
        if [[ ${RUN_ANSWER,,} == "y" ]]; then
            rm -rf "$RESTORE_PATH/Saved"
            mv "$TMP_SAVE_PATH/Saved" "$RESTORE_PATH"
            PrintSuccess "Recovery Complete"
        fi
    fi

    LogInfo "Clean up the temporary directory."
    rm -rf "$TMP_PATH" "$TMP_SAVE_PATH"

    exit 1
}

if [ "${RCON_ENABLED}" != true ]; then
    LogWarn "RCON is not enabled. Please enable RCON to use this feature."
    exit 1
fi

# Show up backup list
LogInfo "Backup List:"
mapfile -t BACKUP_FILES < <(find "$BACKUP_DIRECTORY_PATH" -type f -name "*.tar.gz" | sort)
select BACKUP_FILE in "${BACKUP_FILES[@]}"; do
    if [ -n "$BACKUP_FILE" ]; then
        LogInfo "Selected backup: $BACKUP_FILE"
        break
    else
        LogWarn "Invalid selection. Please try again."
    fi
done

if [ -f "$BACKUP_FILE" ]; then
    LogInfo "This script has been designed to help you restore; however, I am not responsible for any data loss. It is recommended that you create a backup beforehand, and in the event of script failure, be prepared to restore it manually."
    LogInfo "Do you understand the above and would you like to proceed with this command?"
    read -rp "When you run it, the server will be stopped and the recovery will proceed. (y/n): " RUN_ANSWER
    if [[ ${RUN_ANSWER,,} == "y" ]]; then
        LogAction "Starting Recovery Process"
        # Shutdown server
        trap 'term_error_handler' ERR

        if [ "${RCON_ENABLED}" = true ]; then
            LogAction "Shutting Down Server"
            shutdown_server
        else
            LogWarn "RCON is not enabled. Please enable RCON to use this feature. Unable to restore backup."
            exit 1
        fi

        mapfile -t server_pids < <(pgrep PalServer-Linux-Test)
        if [ "${#server_pids[@]}" -ne 0 ]; then
            LogInfo "Waiting for Palworld to exit.."
            for pid in "${server_pids[@]}"; do
                tail --pid="$pid" -f 2>/dev/null
            done
        fi
          LogSuccess "Shutdown Complete"

        trap - ERR

        trap 'restore_error_handler' ERR

        LogAction "Starting Restore"

        # Recheck the backup file
        if [ -f "$BACKUP_FILE" ]; then
            # Copy the save file before restore
            if [ -d "$RESTORE_PATH/Saved" ]; then
                LogInfo "Saves the current state before the restore proceeds."
                LogInfo "$TMP_SAVE_PATH"
                mkdir -p "$TMP_SAVE_PATH"
                if [ "$(id -u)" -eq 0 ]; then
                    chown steam:steam "$TMP_SAVE_PATH"
                fi
                \cp -rf "$RESTORE_PATH/Saved" "$TMP_SAVE_PATH/Saved"

                while [ ! -d "$TMP_SAVE_PATH/Saved" ]; do
                    sleep 1
                done
                LogSuccess "Save Complete"
            fi
            
            # Create tmp directory
            TMP_PATH=$(mktemp -d -p "/palworld/backups")
            if [ "$(id -u)" -eq 0 ]; then
                chown steam:steam "$TMP_PATH"
            fi
            
            # Decompress the backup file in tmp directory
            tar -zxvf "$BACKUP_FILE" -C "$TMP_PATH"

            # Make sure Saves with a different ID are removed before restoring the save
            rm -rf "$RESTORE_PATH/Saved/"

            # Move the backup file to the restore directory
            \cp -rf -f "$TMP_PATH/Saved/" "$RESTORE_PATH"
            LogInfo "Clean up the temporary directory."
            rm -rf "$TMP_PATH" "$TMP_SAVE_PATH"
            LogSuccess "Restore Complete"
            LogInfo "Please restart the container"
            exit 0
        else 
            LogError "The selected backup file does not exist."
            exit 1
        fi
    else
        LogWarn "Abort the recovery."
        exit 1
    fi
else
    LogError "The selected backup file does not exist."
    exit 1
fi