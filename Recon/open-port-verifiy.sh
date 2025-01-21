#!/bin/bash

# Function to check if a port is open
check_port_open() {
    local host=$1
    local port=$2
    echo "Checking if port $port is open on $host..."
    timeout 2 bash -c "</dev/tcp/$host/$port" 2>/dev/null && echo "Port $port is open on $host" || echo "Port $port is closed on $host"
}

# Function to check service and vulnerabilities using nmap
check_service_and_vuln() {
    local host=$1
    local port=$2
    echo "Scanning service and checking vulnerabilities on $host:$port..."
    nmap -Pn -p $port -sV --script vuln $host
}

# Main logic
process_file() {
    local file_path=$1

    if [[ ! -f $file_path ]]; then
        echo "File not found: $file_path"
        exit 1
    fi

    echo "Processing file: $file_path"
    while IFS=, read -r host port; do
        if [[ $host != "" && $port != "" ]]; then
            echo "\nHost: $host, Port: $port"
            check_port_open $host $port
            check_service_and_vuln $host $port
        fi
    done < <(tail -n +2 "$file_path") # Skip header line
}

# File containing host and port information
FILE="mtb-open.csv"

process_file $FILE

## the csv file must have two column (host, port)