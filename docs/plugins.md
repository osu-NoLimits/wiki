# :material-plus-box: Extending Shiina

Enhance your Shiina-Web installation with our powerful plugin system.

## :material-language-java: Creating a Shiina Plugin

With our plugin starter creating a plugin is very simple

```bash
git clone https://github.com/osu-NoLimits/shiina-plugin/ pluginname/
cd pluginname/
```

In `src/main/resources/plugin.yml` is the plugin metadata file

```yml
name: ExamplePlugin
main: com.example.plugin.Plugin
```

You can change the name and the main attributes but make sure the path is equal in `src/main/java` example: `/com/example/plugin/Plugin.java`
also change the name in the `pluginname/pom.xml`.

The `Plugin.java` is the main Entrypoint for your shiina plugin. The plugin starter has some basic stuff implemented but that can be removed by
deleting the `.java` files and deleting the lines in `Plugin.java` that causes issues.

### :material-package-variant: Building a plugin.jar

in your `pluginname/` run command `mvn package`

If everything was successful:

- [x] the build runs without issues
- [x] your pluginname.jar will be in `pluginname/`
- [x] shiina will load the plugin successfully

## :material-web-box: Creating a route `/example`

You need to register your route in the `Plugin.java` next step will be creating the `ExampleRoute.java` file

```java
package com.example.plugin;

import com.example.plugin.routes.ExampleRoute;

import ch.qos.logback.classic.Logger;
import dev.osunolimits.main.WebServer;
import dev.osunolimits.plugins.ShiinaPlugin;

public class Plugin extends ShiinaPlugin
{

    @Override
    protected void onEnable(String pluginName, Logger logger) {
        WebServer.get("/example", new ExampleRoute());
        //WebServer.post("/example", new ExampleRoute());
    }

    @Override
    protected void onDisable(String pluginName, Logger logger) {
    }

}
```

### :material-api: Creating a route without a .html file (API)

Creating a simple route for api handeling is easy, you can also access the current auth and mysql

```java
package com.example.plugin;

import dev.osunolimits.modules.Shiina;
import dev.osunolimits.modules.ShiinaRoute;
import dev.osunolimits.modules.ShiinaRoute.ShiinaRequest;

import spark.Request;
import spark.Response;

public class ExampleRoute extends Shiina {

    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        Integer id = 0;
        shiina.mysql.Query("SELECT * FROM `users` WHERE id = ?", id)
        //the same for shiina.mysql.Exec(sql, optionalParams)
        return redirect(res, shiina, "/"); // Redirects to home
        //return notFound(res, shiina); // Not found route
    }
}
```

## :material-clock-outline: Using Cron Tasks

If you need something running every x minutes or at a fixed time this system is perfect for you.

### Implementing cron tasks in your plugin

=== ":material-file-code: MyCustomPlugin.java"

    ```java
    package dev.osunolimits.plugins;

    import ch.qos.logback.classic.Logger;

    public class MyCustomPlugin extends ShiinaPlugin {

        @Override
        protected void onEnable(String pluginName, Logger logger) {
            // Register the task to run every 30 minutes
            App.cron.registerTimedTask(30, new SimpleTask());

            // Run every day at 3:30 AM
            App.cron.registerFixedRateTask(3, 30, new DailyTask());

            // Run at the beginning of every hour
            App.cron.registerTaskEachFullHour(new HourlyTask());

            logger.info("Cron Task registered");

        }

        @Override
        protected void onDisable(String pluginName, Logger logger) {
        }
    }
    
    ```



### :material-tea-outline: Scheduling patterns

=== "Timed Tasks"

    Run tasks at fixed intervals (every X minutes):

    ```java
    // Create a simple cron task class
    public class SimpleTask extends RunnableCronTask {
        
        @Override
        public void run() {
            App.logger.info("Hello Cron Task - Running every 30 minutes!");
        }

        @Override
        public String getName() {
            return "SimpleTask";
        }
    }
    ```

    !!! example "Common Use Cases"
        - Regular status updates
        - Periodic health checks
        - Simple maintenance tasks
        - Log rotation

=== ":material-clock-time-eight: Fixed Rate Tasks"

    Run tasks daily at a specific time (hour:minute):

    ```java
    // Create a daily task
    public class DailyTask extends RunnableCronTask {
        
        @Override
        public void run() {
            App.logger.info("Hello Cron Task - Daily task running at 3:30 AM!");
        }

        @Override
        public String getName() {
            return "DailyTask";
        }
    }
    ```

    !!! note "Time Format"
        - **Hour**: 24-hour format (0-23)
        - **Minute**: 0-59
        - Times are in server local timezone

=== ":material-clock-outline: Hourly Tasks"

    Run tasks at the start of every hour (XX:00):

    ```java
    // Create an hourly task
    public class HourlyTask extends RunnableCronTask {
        
        @Override
        public void run() {
            App.logger.info("Hello Cron Task - Hourly task running!");
        }

        @Override
        public String getName() {
            return "HourlyTask";
        }
    }
    ```

    !!! success "Perfect For"
        - Regular status updates
        - Simple monitoring
        - Log messages
        - Basic maintenance

---
