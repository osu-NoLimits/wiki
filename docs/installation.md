# :material-server: Installation Guide

Welcome to the **osuNoLimits** installation guide! This comprehensive walkthrough will help you set up a production-ready osu! private server using [Shiina-Web](https://github.com/osu-NoLimits/Shiina-Web) and [bancho.py-ex](https://github.com/osu-NoLimits/bancho.py-ex) with the [onl-docker](https://github.com/osu-NoLimits/onl-docker) Stack from the ground up.

!!! warning "Prerequisites Checklist"
    Before beginning the installation, please ensure you have:
    
    - :material-server: **Linux Server** — Ubuntu 24.04+ or Debian-based distribution recommended
    - :material-domain: **Domain Name** — with full DNS management access
    - :material-shield-check: **Technical Knowledge** — comfortable with command-line operations
    - :material-clock: **Time Allocation** — approximately 20-30 minutes for complete setup
  
## :material-dns: Domain Configuration

Proper DNS setup is crucial for your server's functionality. Configure the following subdomains to point to your server's IP address. We **strongly recommend** using [Cloudflare](https://www.cloudflare.com/) for robust DNS management and enterprise-grade DDoS protection.

!!! example "Required DNS Records"
    Create the following DNS records, all pointing to your server's IP address:
    
    === "A Records"
        | Subdomain | Purpose | Example |
        |-----------|---------|---------|
        | `@` | Main domain | `osunolimits.dev` |
        | `osu` | Game client connection | `osu.osunolimits.dev` |
        | `c` | Game server | `c.osunolimits.dev` |
        | `c4` | Game server | `c4.osunolimits.dev` |
        | `a` | Avatar endpoint | `a.osunolimits.dev` |
        | `assets` | Static assets | `assets.osunolimits.dev` |
        | `api` | Bancho API | `api.osunolimits.dev` |
    
    === "Cloudflare Setup"
        1. Add your domain to Cloudflare
        2. Update nameservers at your registrar
        3. Create the A records listed above
        4. Enable proxy (orange cloud) for web traffic protection

    === "Example"
        ![Domain Configuration](img/domains.png)

!!! tip "SSL/TLS Configuration"
    Choose between flexible or strict SSL encryption based on your security requirements. For production environments, we **strongly recommend Full (Strict)** SSL mode with valid certificates for maximum security.
    
    :material-book-open-variant: [Detailed SSL setup guide](https://github.com/osuAkatsuki/bancho.py/wiki/Post-setup)

!!! note "Version Control Best Practice"
    **We highly recommend** forking the repositories to your own GitHub account before proceeding. Benefits include:
    
    - :material-source-pull: **Easy Updates** — seamlessly pull upstream changes
    - :material-pencil: **Custom Modifications** — maintain your own feature branches  
    - :material-backup-restore: **Configuration Backup** — preserve your settings across updates

## :material-docker: Installing the osuNoLimits Stack

### :material-package-variant-closed: Docker Installation

Docker is the foundation of the osuNoLimits stack, providing containerized deployment for all services. Select your operating system below to begin installation:

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

    !!! warning "Cleanup First"
        Remove any conflicting Docker packages:
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

### :material-git: Git Installation

Git is essential for cloning the repository and managing future updates. Follow the instructions for your operating system:

=== ":material-ubuntu: Ubuntu & Debian"

    **Step 1:** Update package list and install Git
    ```bash
    sudo apt update
    sudo apt install git
    ```

    **Step 2:** Verify installation
    ```bash
    git --version
    ```

    !!! success "Expected Output"
        You should see something like `git version 2.34.1`

    **Step 3:** Configure Git (replace with your information)
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```

=== ":material-fedora: Fedora"

    **Step 1:** Update packages and install Git
    ```bash
    sudo dnf update
    sudo dnf install git
    ```

    **Step 2:** Verify installation
    ```bash
    git --version
    ```

    !!! success "Expected Output"
        You should see something like `git version 2.34.1`

    **Step 3:** Configure Git (replace with your information)
    ```bash
    git config --global user.name "Your Name"
    git config --global user.email "your.email@example.com"
    ```

### :material-download: Repository Setup

Clone the onl-docker repository to your server to get started:

!!! tip "Using Your Fork"
    If you created a fork earlier, replace the repository URL below with your fork's URL. This makes pulling updates and managing custom changes much easier.

!!! tip "Custom Submodule Configuration"
    To use your own forked versions of shiina-web and bancho.py-ex, update the URLs in the `.gitmodules` file within onl-docker.


```bash
git clone https://github.com/osu-NoLimits/onl-docker /home/onl-docker
cd /home/onl-docker
```

### :material-file-cog: Environment Configuration

Initialize your configuration by creating copies of the example files:

```bash
cp .env.example .env
cp .config/caps.example.json .config/caps.json
cp .config/customization.yml.example .config/customization.yml
cp .config/logger.env.example .config/logger.env
```

### :material-pencil: Configuration Editor

Open the main environment file for editing:

```bash
nano .env
```

!!! warning "Critical Configuration Settings"
    The following settings are **mandatory** and must be configured before starting the server:

=== ":material-key: Core Settings"

    | Setting | Description | Required |
    |---------|-------------|----------|
    | `DOMAIN` | Your primary domain (e.g., `osunolimits.dev`) | ✅ |
    | `DB_PASS` | Strong, unique database password | ✅ |
    | `BANCHO_DISCORD_URL` | osu! API key — [obtain here](https://osu.ppy.sh/home/account/edit) | ✅ |
    | `SHIINA_TURNSTILE_KEY` | Cloudflare Turnstile public key — [get yours here](https://dash.cloudflare.com/sign-up?to=/:account/turnstile) | ✅ |
    | `SHIINA_TURNSTILE_SECRET` | Cloudflare Turnstile private key — [get yours here](https://dash.cloudflare.com/sign-up?to=/:account/turnstile) | ✅ |
    | `FLEXIBLE` | SSL mode: `true` for flexible, `false` for strict (default: `true`) | ✅ |
    | `PROTOCOL` | Connection protocol: `https` recommended, use `http` only without Cloudflare (default: `https`) | ✅ |

=== ":material-shield-lock: SSL Certificate Paths (Optional)"

    !!! note "Required for Full/Strict SSL Mode Only"
        Configure these paths only if using Full or Strict SSL encryption:
    
    ```bash
    SSL_CERT_PATH=/path/to/your/fullchain.crt
    SSL_KEY_PATH=/path/to/your/private.key
    ```

=== ":material-palette: Branding & Customization (Optional)"

    | Setting | Description | Example |
    |---------|-------------|---------|
    | `BANCHO_SERVER_NAME` | Your server's public display name | `osuNoLimits` |
    | `BANCHO_DISCORD_URL` | Community Discord invite link | `https://discord.gg/yourinvite` |
    | `BANCHO_DISCORD_URL` | Your Discord invite link | `https://discord.gg/yourinvite` |
    | `BANCHO_ICON_URL` | In-game menu icon | URL to your icon |
    | `BANCHO_ONCLICK_URL` | Click destination | Your website URL |
    | `BANCHO_BGS` | Background images | Comma-separated URLs |

=== ":material-webhook: Webhooks (Optional)"

    Configure Discord webhooks for notifications:
    
    ```bash
    BANCHO_FIRST_PLACES_WEBHOOK=https://discord.com/api/webhooks/...
    BANCHO_FIRST_PLACES_WEBHOOK_URL=True
    BANCHO_AUDIT_LOG_WEBHOOK=https://discord.com/api/webhooks/...
    ```

### :material-web-box: Installation Script

With your configuration complete, run the automated installation script:

```bash
make install
```

The installer will guide you through the setup process, including:

- :material-package: Dependency installation
- :material-cog: Service configuration
- :material-help-circle: Optional phpMyAdmin setup (prompted during installation)

### :material-hammer-wrench: Launch Your Server

With everything configured, you're ready to start your osuNoLimits server! Choose your preferred launch method:

**Option 1: Detached with Screen** (Recommended for SSH sessions)
```bash
screen -S onl-docker make run
```

**Option 2: Detached Docker Compose**
```bash
docker compose up -d
```

**Option 3: Foreground Process**
```bash
make run
```

!!! success "Server Started!"
    Your server should now be running. Monitor the logs for any startup errors and verify all services are operational.

## :material-help-circle: Frequently Asked Questions

Find quick answers to common questions and troubleshooting tips below. We do have a [Community Dev Discord](https://discord.gg/Dr79DU9kbD)

---

### :material-cog-box: Installation & Setup

??? question "How to setup default avatar?"
    Nginx is looking in `/home/onl-docker/.data/bancho/avatars` for a `default.jpg`

    Note: 
    It can be possible that you need to reset permissions, help is in the section above


??? question "How can I receive donations through Shiina?"
    Currently, **Ko-fi** is the only supported payment provider.

    **Setup Steps:**

    1. Install the free Ko-fi plugin from the marketplace
    
    2. Enable monetization:
    ```bash
    nano /home/onl-docker/.data/shiina/data/monetization.json
    # Set enabled to true, then save and restart Shiina
    ```
    
    3. Configure Ko-fi webhook:
    ```bash
    nano /home/onl-docker/.data/shiina/data/monetization/kofi.json
    ```
    
    4. Set up webhook at [Ko-fi Webhooks Dashboard](https://ko-fi.com/manage/webhooks?src=sidemenu)
        - Webhook URL: `https://yourdomain.dev/handlekofi`
        - Find your verification token under **Advanced** settings
    
    **Configuration Example:**
    ```json
    {
        "verificationToken": "your-access-token",
        "pageName": "osunolimits",
        "donationAmount": 1
    }
    ```
    
    !!! info "Donation Calculation"
        `donationAmount` represents the base price in your currency. For example, a $10 donation equals 10 months of supporter status.

??? question "How do I configure automatic anti-cheat bans?"
    Configure performance point limits to automatically detect and ban suspicious plays:

    ```bash
    nano .config/caps.json
    ```

    !!! example "Sample PP Caps Configuration"
        ```json
        {
            "enabled": true,
            "caps": {
                "0": 800,    // osu! Standard
                "1": 1000,   // osu! Taiko  
                "2": 900,    // osu! Catch
                "3": 850     // osu! Mania
            }
        }
        ```

    !!! warning "Configuration Best Practices"
        - Set `"enabled": true` to activate the automatic banning system
        - Adjust PP thresholds based on your server's average skill level
        - Regularly monitor audit logs for false positives
        - Consider community feedback when tuning these values


---

### :material-application: Usage & Features

??? question "Why isn't my rank graph displaying?"
    Rank graphs require **at least one week of historical data** before they can be displayed. Be patient while your server collects player statistics.

??? question "Can I modify the source code?"
    Yes, but direct code modifications are **not recommended** as they can complicate future updates and cause merge conflicts. Instead, use the plugin and theme systems to extend functionality whenever possible.
---

### :material-wrench: Troubleshooting

??? question "Where can I find frontend logs?"
    Shiina automatically maintains logs with a **30-day rotation policy**. Access them here:
    
    ```bash
    cd /home/onl-docker/.data/shiina/logs
    ls -lh  # View available log files
    ```

??? question "How do I recalculate performance points (PP)?"
    To recalculate PP for all players, access the bancho container and run the recalculation script:
    
    **Step 1:** Find the bancho container ID
    ```bash
    docker ps
    ```
    
    **Step 2:** Access the container shell
    ```bash
    docker exec -it <container-id> sh
    ```
    
    **Step 3:** Navigate to tools and execute recalculation
    ```bash
    cd bancho.py-ex/tools/
    python recalc.py
    ```
    
    !!! tip "Performance Note"
        PP recalculation can be resource-intensive. Consider running during off-peak hours for servers with many players.

---

<div align="center">
    <p><em>© 2026 Marc Andre Herpers. All rights reserved.</em></p>
</div>
