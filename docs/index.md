# Installation Guide

Welcome to the comprehensive installation guide for **osuNoLimits**. This guide will walk you through setting up [Shiina-Web](https://github.com/osu-NoLimits/Shiina-Web) and [bancho.py-ex](https://github.com/osu-NoLimits/bancho.py-ex) from scratch.

!!! info "Community Support"
    Need help? Join our community on Discord for support and updates.
    
    [![Discord](https://dcbadge.limes.pink/api/server/Dr79DU9kbD)](https://discord.gg/Dr79DU9kbD)

!!! warning "Prerequisites"
    Before starting, ensure you have:
    
    - :material-server: A Linux server (Ubuntu 24.04+ recommended)
    - :material-domain: A domain name with DNS access
    - :material-shield-check: Basic command-line knowledge
    - :material-clock: Approximately 30-60 minutes

## :material-dns: Domain Configuration

Configure the following subdomains to point to your server. We strongly recommend using [Cloudflare](https://www.cloudflare.com/) for DNS management and DDoS protection.

!!! example "Required Subdomains"
    Create these DNS records pointing to your server's IP:
    
    === "A Records"
        | Subdomain | Purpose | Example |
        |-----------|---------|---------|
        | `@` | Main domain | `osunolimits.dev` |
        | `osu` | Game server | `osu.osunolimits.dev` |
        | `c` | Game server | `c.osunolimits.dev` |
        | `c4` | Game server | `c.osunolimits.dev` |
        | `a` | API endpoint | `a.osunolimits.dev` |
        | `assets` | Static assets | `assets.osunolimits.dev` |
        | `api` | Bancho API | `assets.osunolimits.dev` |
    
    === "Cloudflare Setup"
        1. Add your domain to Cloudflare
        2. Update nameservers at your registrar
        3. Create the A records listed above
        4. Enable proxy (orange cloud) for web traffic protection

    === "Example"
        ![Domain Configuration](img/domains.png)

!!! tip "SSL Configuration"
    You can choose between flexible or strict SSL encryption. For production environments, we recommend **Full (Strict)** SSL mode with valid certificates.
    
    📖 [Detailed SSL setup guide](https://github.com/osuAkatsuki/bancho.py/wiki/Post-setup)

!!! note "Version Control Recommendation"
    Create a GitHub fork of the repositories before proceeding. This allows you to:
    
    - :material-source-pull: Easily pull updates
    - :material-pencil: Make custom modifications  
    - :material-backup-restore: Maintain your configuration

## :material-docker: Installing bancho.py-ex

### :material-package-variant-closed: Docker Installation

Docker is required to run bancho.py-ex. Choose your operating system below:

=== ":material-ubuntu: Ubuntu"

    !!! warning "Cleanup First"
        Remove any conflicting Docker packages:
        
    ```bash
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
        sudo apt-get remove $pkg
    done
    ```

    **Step 1:** Add Docker's official GPG key and repository
    ```bash
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    ```

    **Step 2:** Add Docker repository to APT sources
    ```bash
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    ```

    **Step 3:** Install Docker
    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

=== ":material-debian: Debian"

    !!! warning "Cleanup First"
        Remove any conflicting Docker packages:
        
    ```bash
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
        sudo apt-get remove $pkg
    done
    ```

    **Step 1:** Add Docker's official GPG key and repository
    ```bash
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    ```

    **Step 2:** Add Docker repository to APT sources
    ```bash
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    ```

    **Step 3:** Install Docker
    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

=== ":material-fedora: Fedora"

    **Step 1:** Remove conflicting packages
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

    **Step 2:** Add Docker repository
    ```bash
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    ```

    **Step 3:** Install Docker
    ```bash
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

    **Step 4:** Enable Docker service
    ```bash
    sudo systemctl enable --now docker
    ```

### :material-web: Nginx Installation

Nginx serves as our web server and reverse proxy. Follow the instructions for your operating system:

=== ":material-ubuntu: Ubuntu & Debian"

    !!! tip "Remove Apache2 (Ubuntu only)"
        If Apache2 is installed, remove it first to avoid conflicts:
        
    ```bash
    sudo systemctl stop apache2
    sudo apt remove apache2 apache2-utils apache2-bin apache2.2-common
    sudo apt autoremove
    ```

    **Step 1:** Update package list and install Nginx
    ```bash
    sudo apt update
    sudo apt install nginx
    ```

    **Step 2:** Verify installation
    ```bash
    sudo systemctl status nginx
    ```

    !!! success "Expected Output"
        You should see `Active: active (running)` in green text.

=== ":material-fedora: Fedora"

    **Step 1:** Update packages and install Nginx
    ```bash
    sudo dnf update
    sudo dnf install nginx
    ```

    **Step 2:** Start and enable Nginx
    ```bash
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```

    **Step 3:** Configure firewall
    ```bash
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    ```

    **Step 4:** Verify installation
    ```bash
    sudo systemctl status nginx
    ```

### :material-git: Git Installation

Git is required for cloning the repository and managing updates.

=== ":material-ubuntu: Ubuntu & Debian"

    **Step 1:** Install Git
    ```bash
    sudo apt update
    sudo apt install git
    ```

    **Step 2:** Verify installation
    ```bash
    git --version
    ```

    **Step 3:** Configure Git (replace with your information)
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```

=== ":material-fedora: Fedora"

    **Step 1:** Install Git
    ```bash
    sudo dnf update
    sudo dnf install git
    ```

    **Step 2:** Verify installation
    ```bash
    git --version
    ```

    **Step 3:** Configure Git (replace with your information)
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```

### :material-download: Repository Setup

Clone the bancho.py-ex repository to your server:

!!! tip "Use Your Fork"
    If you created a fork, replace the URL with your fork's URL for easier updates.

```bash
git clone https://github.com/osu-NoLimits/bancho.py-ex.git /home/bancho-py-ex
cd /home/bancho-py-ex
```

## :material-cog: Configuration

### :material-file-cog: Environment Setup

First, create your configuration files from the provided examples:

```bash
cp .env.example .env
cp logging.yaml.example logging.yaml
```

### :material-pencil: Edit Configuration

Open the environment file for editing:

```bash
nano .env
```

!!! warning "Required Configuration"
    You **must** configure these essential settings before proceeding:

=== ":material-key: Authentication"

    | Setting | Description | Required |
    |---------|-------------|----------|
    | `OSU_API_KEY` | [Get your osu! API key here](https://osu.ppy.sh/home/account/edit) | ✅ |
    | `DB_PASS` | Strong database password | ✅ |
    | `DOMAIN` | Your domain (e.g., `osunolimits.dev`) | ✅ |

=== ":material-shield-lock: SSL Settings (Optional)"

    !!! note "Only required for Full/Strict SSL mode"
    
    ```bash
    SSL_CERT_PATH=/path/to/your/fullchain.crt
    SSL_KEY_PATH=/path/to/your/private.key
    ```

=== ":material-palette: Customization (Optional)"

    | Setting | Description | Example |
    |---------|-------------|---------|
    | `SERVER_NAME` | Your server's display name | `osuNoLimits` |
    | `DISCORD_URL` | Your Discord invite link | `https://discord.gg/yourinvite` |
    | `MENU_ICON_URL` | In-game menu icon | URL to your icon |
    | `MENU_ONCLICK_URL` | Click destination | Your website URL |
    | `SEASONAL_BGS` | Background images | Comma-separated URLs |

=== ":material-webhook: Webhooks (Optional)"

    Configure Discord webhooks for notifications:
    
    ```bash
    FIRST_PLACES_WEBHOOK=https://discord.com/api/webhooks/...
    ENABLE_FIRST_PLACES_WEBHOOK=True
    DISCORD_AUDIT_LOG_WEBHOOK=https://discord.com/api/webhooks/...
    ```

### :material-web-box: Nginx Configuration

Install the pre-configured nginx setup:

```bash
./scripts/install-nginx-config.sh
```

!!! success "Configuration Complete"
    Your nginx configuration has been automatically set up with the correct proxy settings for all bancho.py-ex endpoints.

## :material-rocket: Deployment

### :material-hammer-wrench: Build and Start

With everything configured, build and start the project:

```bash
# Build the Docker containers
make build

# Start all services
make run
```

!!! tip "Development vs Production"
    - For **development**: Use `make run` for easier debugging
    - For **production**: Consider using `make run-detached` to run in background

### :material-shield-account: Autoban Configuration

Configure performance point limits to prevent cheating:

```bash
nano caps.json
```

!!! example "PP Caps Configuration"
    ```json
    {
        "enabled": true,
        "caps": {
            "0": 800,    // osu! standard
            "1": 1000,   // osu! taiko  
            "2": 900,    // osu! catch
            "3": 850     // osu! mania
        }
    }
    ```

!!! warning "Important Notes"
    - Set `"enabled": true` to activate automatic banning
    - Adjust PP values based on your server's skill level
    - Monitor logs for any false positives
