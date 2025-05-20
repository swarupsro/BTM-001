#!/bin/bash

# Input and Output Files
input_file="ip.txt"
text_output="output.txt"
csv_output="output.csv"

# Initialize files
echo "Ping Results" > "$text_output"
echo "----------------------" >> "$text_output"
echo "IP,Status" > "$csv_output"

# Read total number of IPs
total_ips=$(grep -cve '^\s*$' "$input_file")
current_count=0

# Loop through each IP
while read -r ip; do
    # Skip empty lines
    if [[ -z "$ip" ]]; then
        continue
    fi

    current_count=$((current_count + 1))
    echo -e "\n[ $current_count / $total_ips ] 🔄 Pinging $ip..."

    echo "Pinging $ip..." >> "$text_output"
    echo "" >> "$text_output"

    # Perform ping with 4 packets
    ping_output=$(ping -c 4 "$ip")
    echo "$ping_output" >> "$text_output"
    echo "----------------------" >> "$text_output"

    # Determine if the IP is up or down
    received_packets=$(echo "$ping_output" | grep -i 'received' | awk '{print $4}')
    if [[ "$received_packets" -eq 0 ]]; then
        status="Down"
    else
        status="Up"
    fi

    # Write to CSV
    echo "$ip,$status" >> "$csv_output"

done < "$input_file"

echo -e "\n✅ Completed! $current_count IPs have been pinged."
