sudo pacman -S iwd

# Create and edit the file with a text editor
sudo vim /etc/NetworkManager/conf.d/wifi_backend.conf

# Add the following lines to the file and save it:
[device]
wifi.backend=iwd

# Stop and disable the old backend
sudo systemctl disable --now wpa_supplicant.service

# Enable and start the new iwd backend
sudo systemctl enable --now iwd.service

sudo systemctl restart NetworkManager.service