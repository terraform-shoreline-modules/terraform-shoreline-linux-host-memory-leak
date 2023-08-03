
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Host Memory Leak Incident
---

 A memory leak occurs when a program allocates memory but fails to release it when it is no longer needed, leading to a gradual increase in memory usage over time. This can eventually cause the program or system to become unstable or crash due to insufficient available memory.

### Parameters
```shell
export N="PLACEHOLDER"

export PID="PLACEHOLDER"

export PATH_TO_LOG_FILE="PLACEHOLDER"

export PROCESS_NAME="PLACEHOLDER"

export MEMORY_THRESHOLD="PLACEHOLDER"

export MEMORY_USED="PLACEHOLDER"
```

## Debug

### Get top processes by memory usage
```shell
ps aux --sort=-%mem | head -n ${N}
```

### Check memory usage of a specific process
```shell
pmap ${PID}
```

### Check available memory and swap usage
```shell
free -h
```

### Check system logs for out of memory errors
```shell
grep -i "out of memory" /var/log/syslog
```

### Memory leaks in the software running on the host machine.
```shell
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
```