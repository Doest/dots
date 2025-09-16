
Copy the file to openvpn folder
```
sudo cp ./update-systemd-resolved.sh /etc/openvpn/update-systemd-resolved.sh
```


Set appropriate permissions for security
```
sudo chown root:root /etc/openvpn/update-systemd-resolved.sh
sudo chmod 755 /etc/openvpn/update-systemd-resolved.sh
```

Update the openvpn config.

```

# Allow OpenVPN to call external scripts.
script-security 2

# Tell OpenVPN to run our script on connection up and down events.
up /etc/openvpn/update-systemd-resolved.sh
down /etc/openvpn/update-systemd-resolved.sh

```
