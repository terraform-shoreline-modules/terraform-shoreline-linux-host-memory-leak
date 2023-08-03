#!/bin/bash

# Define variables

LOG_FILE="${PATH_TO_LOG_FILE}"

PROCESS_NAME="${PROCESS_NAME}"

MEMORY_THRESHOLD="${MEMORY_THRESHOLD}"



# Check if the process is running

if pgrep $PROCESS_NAME > /dev/null

then

    echo "Process $PROCESS_NAME is running."



    # Check memory usage

    MEMORY_USED=$(ps aux | grep $PROCESS_NAME | awk '{print $4}')

    MEMORY_USED=${MEMORY_USED} # Replace decimal point with comma

    MEMORY_USED_PERCENTAGE=$(echo "scale=2; $MEMORY_USED/1" | bc) # Convert to percentage



    echo "Memory usage: $MEMORY_USED_PERCENTAGE%"



    # Check if memory usage is above threshold

    if (( $(echo "$MEMORY_USED_PERCENTAGE > $MEMORY_THRESHOLD" | bc -l) ))

    then

        echo "Memory usage is above threshold of $MEMORY_THRESHOLD%."



        # Log the issue

        echo "$(date): Memory usage of $MEMORY_USED_PERCENTAGE% is above threshold of $MEMORY_THRESHOLD%." >> $LOG_FILE



        # Restart the process

        echo "Restarting $PROCESS_NAME..."

        systemctl restart $PROCESS_NAME

    else

        echo "Memory usage is below threshold of $MEMORY_THRESHOLD%."

    fi

else

    echo "Process $PROCESS_NAME is not running."

fi



exit 0