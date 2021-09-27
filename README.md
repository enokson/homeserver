# Raspberry Pi Setup

* flash the sd card
* mount the boot drive
* cd to mounted raspberry boot drive
```bash
cd /path/to/bootdrive
```
* Enable ssh
```bash
touch ssh
```
* enable wifi  
The double quotation marks for the ssid and psk are important here.
```bash
echo "country=US # Your 2-digit country code
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
network={
    ssid=\"YOUR_NETWORK_NAME\"
    psk=\"YOUR_PASSWORD\"
}" >> wpa_supplicant.conf
```

* boot the system

* update the system
```bash
apt update
apt upgrade
```

## External Disk Encryption
* install dm-crypt
```bash
apt install cryptsetup
```

* reboot

* add the dm_crypt module
```bash
modprobe dm_crypt
```

* setup disk partition and encryption
```bash
# in this example the device to encrypt is /dev/sda
cryptsetup luksFormat /dev/sda

# crypt_drive is what the name of the mapper will be called
cryptsetup open /dev/sda crypt_drive

# create the fs (ext4)
mkfs.ext4 /dev/mapper/crypt_drive

# to mount the drive use
# mount -t fstype /dev/mapper/crypt_drive /path/to/mount
```

* add luks key
```bash
cryptsetup luksAddKey /dev/sda
Enter any existing passphrase:
Enter new passphrase for key slot:
Verify passphrase:
```

* create a key file
```bash
dd if=/dev/random bs=32 count=1 of=/path/to/keyfile
```

* Get the UUID of the device
```bash
lsblk -o NAME,UUID
# => NAME       UUID
# => sda        fakec550-0ac9-4a2c-a463-9f57c8e2fake
```

* add the key to the device
```bash
cryptsetup luksAddKey /dev/sda /path/to/keyfile
```

* add entry to /etc/crypttab
```bash
# device-name path/to/device path/to/key-file
echo "crypt_drive UUID=fakec550-0ac9-4a2c-a463-9f57c8e2fake /path/to/keyfile" >> /etc/crypttab
```

* add entry to /etc/fstab
```bash
echo "/dev/mapper/crypt_drive /path/to/mount ext4 defaults 0 0" >> /etc/fstab
```

* reboot
```bash
reboot
```

## Docker Setup
* Install docker
```
apt install docker docker-compose
```

* Create a network for the NPM container
```bash
# in this example, the network will be called npm
docker network create npm
```

* Add external network to each container to proxy
```yaml
# When this is added to the docker-compose.yml of the services to start with portainer, docker will put it on the same network as the npm container, exposing all the services' ports
networks:
  default:
    external:
      name: npm
```

* Start the portainer service in ./apps/portainer
```bash
cd ./apps/portainer
docker-compose up -d
```

* Add the pihole service, by coping the ./apps/pihole/docker-compose.yml

* add the following local dns'
```bash
<local-network-ip> npm.local
<local-network-ip> portainer.local
```

* change the router settings to point to the node's ip
