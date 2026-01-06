# :material-file-code: Creating Plugins

Learn how to create your first Shiina-Web plugin from scratch.

---

## :material-download: Plugin Starter Template

The easiest way to start is by using our official plugin starter template. It includes all the necessary structure and dependencies.

### Clone the Template

```bash
git clone https://github.com/osu-NoLimits/shiina-plugin/ myplugin/
cd myplugin/
```

!!! tip "Choose a Good Name"
    Replace `myplugin` with a descriptive name for your plugin (e.g., `achievements-plugin`, `custom-leaderboard`, `discord-integration`)

---

## :material-cog: Project Structure

After cloning, your plugin will have this structure:

```
myplugin/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── example/
│       │           └── plugin/
│       │               └── Plugin.java
│       └── resources/
│           └── plugin.yml
├── pom.xml
└── README.md
```

### Key Files

| File | Purpose |
|------|---------|
| `Plugin.java` | Main entry point for your plugin |
| `plugin.yml` | Plugin metadata and configuration |
| `pom.xml` | Maven build configuration |

---

## :material-file-edit: Configuring plugin.yml

The `plugin.yml` file contains essential metadata about your plugin.

**Location:** `src/main/resources/plugin.yml`

```yaml
name: ExamplePlugin
main: com.example.plugin.Plugin
```

### Configuration Options

| Property | Description | Required | Example |
|----------|-------------|----------|---------|
| `name` | Display name of your plugin | ✅ | `AchievementTracker` |
| `main` | Fully qualified class name of main plugin class | ✅ | `com.myserver.achievements.Plugin` |

!!! warning "Important Notes"
    - The `main` path **must match** your actual Java package structure
    - The class name must match your main plugin file (usually `Plugin.java`)
    - Changing these values requires updating your Java package structure

---

## :material-language-java: Main Plugin Class

The `Plugin.java` file is your plugin's entry point. It extends `ShiinaPlugin` and implements lifecycle methods.

### Basic Structure

```java
package com.example.plugin;

import ch.qos.logback.classic.Logger;
import dev.osunolimits.plugins.ShiinaPlugin;

public class Plugin extends ShiinaPlugin {

    @Override
    protected void onEnable(String pluginName, Logger logger) {
        // Called when your plugin starts
        logger.info(pluginName + " has been enabled!");
        
        // Initialize your plugin here
        // - Register routes
        // - Schedule tasks
        // - Load configuration
    }

    @Override
    protected void onDisable(String pluginName, Logger logger) {
        // Called when your plugin stops
        logger.info(pluginName + " has been disabled!");
        
        // Cleanup here
        // - Save data
        // - Process last chunks of data
    }
}
```

### Lifecycle Methods

#### `onEnable(String pluginName, Logger logger)`

Called when Shiina-Web loads your plugin. Use this to:

- ✅ Register web routes
- ✅ Schedule cron tasks
- ✅ Initialize database connections
- ✅ Load configuration files
- ✅ Register event listeners

#### `onDisable(String pluginName, Logger logger)`

Called when Shiina-Web unloads your plugin. Use this to:

- ✅ Save plugin state
- ✅ Release resources

---

## :material-pencil: Customizing Your Plugin

### Step 1: Update plugin.yml

Edit `src/main/resources/plugin.yml`:

```yaml
name: MyAwesomePlugin
main: com.myserver.awesome.Plugin
```

### Step 2: Update Package Structure

Rename your Java package to match the `main` value:

**Before:**
```
src/main/java/com/example/plugin/Plugin.java
```

**After:**
```
src/main/java/com/myserver/awesome/Plugin.java
```

### Step 3: Update Package Declaration

Edit your `Plugin.java`:

```java
package com.myserver.awesome;  // Update this line

import ch.qos.logback.classic.Logger;
import dev.osunolimits.plugins.ShiinaPlugin;

public class Plugin extends ShiinaPlugin {
    // ... your code
}
```

### Step 4: Update pom.xml

Edit the artifact name in `pom.xml`:

```xml
<groupId>com.myserver</groupId>
<artifactId>myawesomeplugin</artifactId>
<version>1.0.0</version>
```

---

## :material-hammer-wrench: Building Your Plugin

Build your plugin using Maven:

```bash
mvn clean package
```

### Build Success Checklist

After running `mvn package`, verify:

- [x] Build completes without errors
- [x] JAR file is created in `target/` directory
- [x] JAR filename matches your artifact ID

!!! success "Build Output"
    Your compiled plugin will be at:
    ```
    target/myawesomeplugin-1.0.0.jar
    ```

---

## :material-check-circle: Verifying Installation

Your plugin is working if you see:

```
[INFO] Loaded plugin: MyAwesomePlugin
```

!!! failure "Troubleshooting"
    If the plugin doesn't load:
    
    - ❌ Check `plugin.yml` matches your Java package
    - ❌ Verify the JAR file is in the correct directory
    - ❌ Look for error messages in the logs
    - ❌ Confirm Java version compatibility

---

<div align="center">
    <p><em>© 2026 Marc Andre Herpers. All rights reserved.</em></p>
</div>
