#!/bin/bash

# Get a list of network interfaces
interfaces=$(ip link show | awk '/^[0-9]+:/ {print $2}' | tr -d ':')

# Check if any interfaces were found
if [ -z "$interfaces" ]; then
  echo "No network interfaces found."
  exit 1
fi

# Select the first interface (you can modify this if needed)
interface=$(echo "$interfaces" | head -n 1)

# Generate a random MAC address
new_mac=$(openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')

# Bring the interface down
ip link set dev "$interface" down

# Change the MAC address
ip link set dev "$interface" address "$new_mac"

# Bring the interface back up
ip link set dev "$interface" up

# Send a notification using notify-send (if available)
if command -v notify-send &> /dev/null; then
  notify-send "MAC Address Changed" "New MAC address: $new_mac"
else
  # If notify-send is not available, just echo the message
  echo "MAC Address Changed. New MAC address: $new_mac"
fi
