This is the guide to install and configure [Shiina-Web](https://github.com/osu-NoLimits/Shiina-Web) and [bancho.py-ex](https://github.com/osu-NoLimits/bancho.py-ex)

[![Discord](https://dcbadge.limes.pink/api/server/Dr79DU9kbD)](https://discord.gg/Dr79DU9kbD)

## Post setup

Create following subdomains and make them point to your server, adding [Cloudflare](https://www.cloudflare.com/) to your domain is
recommended cause of the Proxy that **protects your IP**.

![Subdomains](img/domains.png)

Do not forget the main domain `(example: osunolimits.dev)` which can be added with an `@` in Cloudflare. *isn't listed in image*

You can choose if you use flexible or strict SSL Encryption but you will need a certificate to connect to the server.
A good tutotial is here [bancho.py wiki](https://github.com/osuAkatsuki/bancho.py/wiki/Post-setup)

`NOTE: It is recommended for the next step to create a fork with GitHub to get updates.`

## Installing bancho.py-ex

### Installing docker

??? note "Ubuntu"
    1. Remove conflicting packages
    ```bash
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    ```
    2. Install repository to apt
    ```bash
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    ```
    3. Install latest
    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

??? note "Debian"
    1. Remove conflicting packages
    ```bash
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
    ```
    2. Install repository to apt
    ```bash
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    ```
    3. Install latest
    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

??? note "Fedora"
     1. Remove conflicting packages
    ```bash
    sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
    ```
    2. Install repository to rpm
    ```bash
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    ```
    3. Install latest
    ```bash
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```
    4. Enable Docker Engine
    ```bash
    sudo systemctl enable --now docker
    ```

### Installing nginx

??? note "Ubuntu & Debian"
    1. Remove Apache2 if installed (Ubuntu)
    ```bash
    sudo systemctl stop apache2
    sudo apt remove apache2 apache2-utils apache2-bin apache2.2-common
    sudo apt autoremove
    ```
    2. Update package list
    ```bash
    sudo apt update
    ```
    3. Install nginx
    ```bash
    sudo apt install nginx
    ```
    4. Check status
    ```bash
    sudo systemctl status nginx
    ```

??? note "Fedora"
    1. Update package list
    ```bash
    sudo dnf update
    ```
    2. Install nginx
    ```bash
    sudo dnf install nginx
    ```
    3. Start and enable nginx
    ```bash
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```
    4. Open firewall ports
    ```
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    ```
    5. Check status
    ```
    sudo systemctl status nginx
    ```

### First steps

Clone the repository (use your own fork if possible)
```bash
git clone https://github.com/osu-NoLimits/bancho.py-ex.git /home/bancho-py.ex
cd /home/bancho.py-ex
```

### Configuring bancho.py-ex

Copy the configuration files:

* `.env.example` -> `.env`
* `logging.yaml.example` -> `logging.yaml`

```bash
cp .env.example .env
cp logging.yaml.example logging.yaml
```

With `nano .env` you can edit the configuration. 

- You can get a [osu! API Key here](https://osu.ppy.sh/home/account/edit)

This is the stuff you should change

```bash
# These are important starting the server
DB_PASS=lol123 #Choose a safe password
DOMAIN=example.com
OSU_API_KEY=

# Only needed change when using strict
SSL_CERT_PATH=/home/user/certs/fullchain.crt
SSL_KEY_PATH=/home/user/certs/private.key

# Customization
FIRST_PLACES_WEBHOOK=
ENABLE_FIRST_PLACES_WEBHOOK=True
DISCORD_URL=https://discord.gg/Xfv4pAKxxa
SERVER_NAME=osuNoLimits
DISCORD_AUDIT_LOG_WEBHOOK=
SEASONAL_BGS=https://i.cmyui.xyz/T74WiQG5wVyf.jpg,https://i.cmyui.xyz/nrMT4V2RR3PR.jpeg
MENU_ICON_URL=https://akatsuki.pw/static/images/logos/logo_ingame.png
MENU_ONCLICK_URL=https://akatsuki.pw
```

Install nginx configuration
```
./scripts/install-nginx-config.sh
```

If everything went glad, you are now able to build and start the project

```bash
make build
make run
```