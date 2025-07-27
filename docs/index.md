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

1. Clone the repository (use your own fork if possible)
```
git clone https://github.com/osu-NoLimits/bancho.py-ex.git
cd bancho.py-ex
```

### Installing docker

??? note "Ubuntu 22.04 & 22.02"
    1. Remove conflicting packages
    ```
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    ```
    2. Install repository to apt
    ```
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
    ```
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```
