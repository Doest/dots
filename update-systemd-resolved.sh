#!/bin/bash

set -e

DEV=$1
SCRIPT_TYPE=$2

case $SCRIPT_TYPE in
  up)
    # Set DNS servers and domains from OpenVPN's pushed options
    DNS_SERVERS=()
    DOMAINS=()
    for option in ${!foreign_option_*}
    do
      read -r _ proto family value <<< "${!option}"
      if [[ "$proto" == "dhcp-option" && "$family" == "DNS" ]]; then
        DNS_SERVERS+=("$value")
      fi
      if [[ "$proto" == "dhcp-option" && "$family" == "DOMAIN" ]]; then
        DOMAINS+=("~$value")
      fi
    done

    # Set the DNS servers and domains for the interface
    resolvectl dns "$DEV" "${DNS_SERVERS[@]}"
    resolvectl domain "$DEV" "${DOMAINS[@]}"

    # This line prevents DNS leaks by telling systemd-resolved
    # that no other DNS servers should be used for this interface.
    resolvectl dnsscope "$DEV" link-local
    ;;
  down)
    # Revert all DNS changes for the interface
    resolvectl revert "$DEV"
    ;;
esac

exit 0
