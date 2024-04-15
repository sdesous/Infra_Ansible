## Overview

This Ansible project automates the deployment of a complete rootless Podman container infrastructure. It allows users to easily set up and manage containerized environments without requiring root privileges, ensuring security and flexibility.
## Prerequisites

- Ansible installed on the control node.
- Ansible podman collection installed on control node.
```
$ ansible-galaxy collection install containers.podman
```
- Target hosts running a **Alpine Linux** with python3 installed.
- SSH access to the target machine as root
```
$ ssh-copy-id root@<Alpine_IP>
```

## Containers

| Container                                                                                           | Description                                                 | Pod             | User        |
|-----------------------------------------------------------------------------------------------------|-------------------------------------------------------------|-----------------|-------------|
| [WG-easy](https://github.com/wg-easy/wg-easy)                                                       | VPN                                                         | wireguard_pod   | root   |
| [Ombi](https://docs.linuxserver.io/images/docker-ombi/)                                             | Centralize Radarr, Sonarr and Lidarr in one interface       | ombi_pod        | ombi        |
| [Jellyfin](https://jellyfin.org/docs/general/installation/container/)                               | Media player solution                                       | ombi_pod        | ombi        |
| [Flaresolverr](https://github.com/FlareSolverr/FlareSolverr)                                        | Proxy server to bypass Cloudflare and DDoS-GUARD protection | ombi_pod        | ombi        |
| [Jackett](https://docs.linuxserver.io/images/docker-jackett/)                                       | Torrent indexer                                             | ombi_pod        | ombi        |
| [Transmission](https://github.com/sdesous/Transmission_Ratiomaster)                                 | Torrent client                                              | ombi_pod        | ombi        |
| [Sonarr](https://docs.linuxserver.io/images/docker-sonarr/)                                         | Download Series                                             | ombi_pod        | ombi        |
| [Radarr](https://docs.linuxserver.io/images/docker-radarr/)                                         | Download Films                                              | ombi_pod        | ombi        |
| [Lidarr](https://docs.linuxserver.io/images/docker-lidarr/)                                         | Download Music                                              | ombi_pod        | ombi        |
| [Homarr](https://github.com/ajnart/homarr)                                                          | Application dashboard                                       | ombi_pod        | ombi        |
| [Vaultwarden](https://github.com/dani-garcia/vaultwarden)                                           | Secure password vault                                       | vaultwarden_pod | vaultwarden |
| [Nextcloud](https://hub.docker.com/_/nextcloud)                                                     | Cloud solution                                              | nextcloud_pod   | nextcloud   |
| [HAproxy](https://hub.docker.com/_/haproxy/)                                                        | Enable HTTPS                                                | haproxy_pod     | haproxy     |
| [Transfer.sh](https://github.com/sdesous/transfer.sh/tree/main)                                     | Quick file transfer solution                                | transfer_pod    | transfer    |
| [Mealie](https://docs.mealie.io/documentation/getting-started/installation/installation-checklist/) | Recipe management app                                       | mealie_pod      | mealie      |

## Default directories tree

```
/
├── Backup_PC
│   ├── User_1
│   └── User_2
├── Backup_volumes
│   ├── Backup_1.tar.gz
│   └── Backup-2.tar.gz
├── Downloads
│   └── Some Data ...
├── Media
│   ├── Anime
│   ├── Films
│   ├── Music
│   └── Series
├── Nextcloud
│   └── Some Data ...
├── Transfers
│   └── Some Data ...
└── volumes
    ├── haproxy_volume
    ├── ombi_volume
    ├── transfer_volume
    └── nextcloud_volume
```

## Usage

**WARNING !!! Read the documentation before using this project in order to use it properly.** 

1. Clone this repository to your Ansible control node.
2. Configure the inventory file with your target hosts.
3. Customize variables in `vars/vars.yaml` according to your requirements.
4. Play the main playbook using `deploy.sh`.

## TLDR

- Setup your alpine linux machine with python3 installed
- Clone the repo
- Add the IP address of your alpine to the `inventory.yaml`
- Edit the  `IP_ADDR` variable in the *vars/vars.yaml* file
- Edit the `Backups_PATH` variable in the *vars/vars.yaml* (optionnal)
- Edit *vars/secrets.yaml* file with your wanted creds and SMB config

```
$ ansible-vault edit vars/secrets.yaml
```
- Play the playbook
```
# Simple install
$ ./deploy.sh

# Install and restore backups
$ ./deploy.sh --restore
```
- Configure all your fresh containers (if needed)

## Backup

To create a backup of your volume we recommend you to simple create un tar.gz file of the */volumes* directory.

`WARNING !!! To create a proper backup off Nextcloud you need to save the /Nextcloud directory too`

```
$ tar czvf /Backup_volumes/$(date -I).tar.gz /volumes/* /Nextcloud
```

## Restore

You could already have some volume's backup that you want to restore during the install.

In order to do that you have to edit the `Backups_PATH` variable *vars/vars.yaml*.

This path is were is located the backups in your local machine (not on the alpine).

In order to work properly yout backup directory should be structed like this : 

```
Backup_volumes
├── haproxy_volume
├── ombi_volume
├── nextcloud_volume
└── transfer_volume
```

`WARNING !!! You have to move the Nextcloud directory to nextcloud_volume before restoring your containers`

## Variables

You can find regular variables in the *vars/vars.yaml*. 
Please edit carefully this file and respect the YAML syntax.

You must add the IP address of your alpine machine in the `inventory.yaml` file, then edit the `IP_ADDR` variable with the same address.

## Secrets

As mentionned before we save all of our criticals variables in the *vars/secrets.yaml* file wiche is an ansible vault.

`You are not forced to use a vault but we highly recommend you tu use it for security reasons.`

Finally your secrests file chould look like this : 

```
SMB_Users:
  "User_1":
      "Password" : '$uperSecur3P@$$w0rD'
  "User_2":
      "Password" : '$uperSecur3P@$$w0rD'
SMB_Admins:
  - "User_1"
  - "User_2"
WG_PASSWORD: "$uperSecur3P@$$w0rD"
Nextcloud_Postgres_User: "username"
Nextcloud_Postgres_Password: '$uperSecur3P@$$w0rD'
Smb_svc_Password: '$uperSecur3P@$$w0rD`'
Mealie_DB_User: "username"
Mealie_DB_Password: 'password'
```

## SMB

Deploy a SMB server on the machine and create automatically some users based on *vars/vars.yaml* .
### Smb_svc user

The `smb_svc` user is the default service account for the SMB server. 
This account is a member of `smb_admins` group ans need to have it's password changed properly with the `Smb_svc_Password` variable located  in the *vars/secrets.yaml* file.
### Add SMB user 

In order to add an smb user you have to edit the `SMB_Users` variable located in the *vars/secrets.yaml* file.

```
$ ansible-vault edit vars/secrets.yaml
```

You should do a structure like this. `Don't forget to change the password with an actually secure one` : 

```
SMB_Users:
  "User_1":
      "Password" : '$uperSecur3P@$$w0rD'
  "User_2":
      "Password" : '$uperSecur3P@$$w0rD'
```
### Add SMB admin 

In order to add an smb admin you have to edit the `SMB_Admins` variable located in the *vars/secrets.yaml* file.

```
$ ansible-vault edit vars/secrets.yaml
```

You should have a list of user like this : 

```
SMB_Admins:
  - "User_1"
  - "User_2"
```
### Shares

By default there are 4 SMB shares. 

**All shares are available for `smb_admins` members**

| Share          | Description                                                                                                                                      | Permission  |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| Backup_PC      | In this share you will find a dedicated directory for each users in order to save there PC backups. *Only the owner can access it directory*     | @smb_users  |
| Backup_Volumes | in this share you will find some backup of container's volumes in case of a restoration                                                          | @smb_admins |
| Jellyfin       | Open share where is located all of the media available in Jellyfin                                                                               | @smb_users  |
| Transfers      | Transfer.sh temporary directory                                                                                                                  | @smb_admins |

Here is an example of a the default share's file structure :

```
├── Backup_PC
│   ├── User_1
│   └── User_2
├── Backup_volumes
│   ├── haproxy_volume
│   ├── ombi_volume
│   ├── transfer_volume
│   └── nextcloud_volume
├── Media
│   ├── Anime
│   ├── Films
│   ├── Music
│   └── Series
└── Transfers
```

## Start, Stop, Restart and Update your containers

| Action  | Description                                                                                      | Command                        |
|---------|--------------------------------------------------------------------------------------------------|--------------------------------|
| Start   | 1 - Pull all required image<br>2 - Recreate the pod<br>3 - Run all required containers inside the pod  | `rc-service svc_name start`   |
| Stop    | 1 - Stop all containers<br>2 - Delete the pod with it's containers<br>3 - Delete all images            | `rc-service svc_name stop`    |
| Restart | 1 - Stop<br>2 - Start (Can act like an update action)                                               | `rc-service svc_name restart` |


## Interact with containers as root

In order to interact with containers without the need to use `su` command you can use the `subpodman` command.

```
$ subpodman username <command>
```

### Examples
```
# To see all running container from this user
$ subpodman username ps

# To read the log of the container_1
$ subpodman username logs container_1

# To delete container_2
$ subpodman username rm -f container_2
```

## Impersonate user

```
$ su - username -s /bin/ash
```
