# Arch Setup
## 1. Wifi Setup
1. For the installation (temporary) use `wifi-menu` to connect to a wireless network, alternatively use NetworkManager:
2. Start Network Manager to wrap ethernet and wifi functionality `systemctl enable NetworkManager.service` then disable netctl (and ethernet if connected)
3. `systemctl disable netctl-auto@INTERFACENAME.service` (interface name can be obtained via `ip link` and usually starts with w, eg wlp3s0) and to disable ethernet service `sudo systemctl disable dhcpcd@enp1s0.service`

