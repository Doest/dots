#!/bin/bash

# A script to integrate OpenVPN with systemd-resolved
#
# This script is designed to be called by OpenVPN's 'up' and 'down' options.
#
# When the tunnel comes up, it sets the DNS servers and search domains
# for the VPN's network interface using resolvectl.
#
# When the tunnel goes down, it reverts the interface's DNS settings.

set -e

# The network interface used by the VPN tunnel (e.g., tun0)
DEV=$1
# The script type given by OpenVPN ('up' or 'down')
SCRIPT_TYPE=$2

# Environment variables passed by OpenVPN
# foreign_option_1='dhcp-option DNS 10.10.1.1'
# foreign_option_2='dhcp-option DOMAIN vpn.mycompany.com'

case $SCRIPT_TYPE in
  up)
    # Flush current DNS settings for the interface
    resolvectl dns "$DEV"
    resolvectl domain "$DEV"

    # Set DNS servers and domains from OpenVPN's pushed options
    for option in ${!foreign_option_*}
    do
      read -r _ proto family dns_ip <<< "${!option}"
      if [[ "$proto" == "dhcp-option" && "$family" == "DNS" ]]; then
        resolvectl dns "$DEV" "$dns_ip"
      fi
      if [[ "$proto" == "dhcp-option" && "$family" == "DOMAIN" ]]; then
        # The '~' makes this a routing-only domain
        resolvectl domain "$DEV" "~$dns_ip"
      fi
    done
    ;;
  down)
    # Revert all DNS changes for the interface
    resolvectl revert "$DEV"
    ;;
esac

exit 0
