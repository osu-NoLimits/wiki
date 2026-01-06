# :material-clock-outline: Scheduled Tasks (Cron)

Automate recurring tasks in your Shiina-Web plugins with the built-in cron system.

---

## :material-information: What Are Cron Tasks?

Cron tasks allow you to run code automatically at scheduled intervals or specific times. Perfect for:

- 🔄 **Regular Maintenance** — Database cleanup, cache clearing
- 📊 **Statistics Updates** — Recalculate rankings, generate reports
- 📧 **Notifications** — Send reminders, check for events
- 🔍 **Monitoring** — Health checks, status updates
- 💾 **Backups** — Automated data backups

---

## :material-clock-time-eight: Task Types

Shiina-Web supports three types of scheduled tasks:

| Type | Description | Example |
|------|-------------|---------|
| **Timed Tasks** | Run every X minutes | Every 30 minutes |
| **Fixed Rate Tasks** | Run daily at specific time | Daily at 3:30 AM |
| **Hourly Tasks** | Run at the start of each hour | Every hour at XX:00 |

---

## :material-file-code: Creating a Cron Task

All cron tasks extend the `RunnableCronTask` class.

### Basic Task Structure

```java
package com.example.plugin.tasks;

import dev.osunolimits.common.App;
import dev.osunolimits.modules.utils.cron.RunnableCronTask;

public class MyTask extends RunnableCronTask {
    
    @Override
    public void run() {
        // Your task code here
        App.logger.info("Task is running!");
    }

    @Override
    public String getName() {
        return "MyTask";
    }
}
```

### Task Components

| Method | Purpose | Required |
|--------|---------|----------|
| `run()` | Contains the code to execute | ✅ |
| `getName()` | Returns task identifier | ✅ |

---

## :material-timer: Timed Tasks

Run tasks at regular intervals (every X minutes).

### Example: Every 30 Minutes

```java
package com.example.plugin.tasks;

import dev.osunolimits.common.App;
import dev.osunolimits.modules.utils.cron.RunnableCronTask;

public class StatusCheckTask extends RunnableCronTask {
    
    @Override
    public void run() {
        App.logger.info("Running status check...");
        
        // Your periodic task code
        checkServerHealth();
        updateCache();
        cleanupTemporaryData();
    }

    @Override
    public String getName() {
        return "StatusCheckTask";
    }
    
    private void checkServerHealth() {
        // Implementation
    }
    
    private void updateCache() {
        // Implementation
    }
    
    private void cleanupTemporaryData() {
        // Implementation
    }
}
```

### Registering Timed Tasks

In your main `Plugin.java`:

```java
@Override
protected void onEnable(String pluginName, Logger logger) {
    // Run every 30 minutes
    App.cron.registerTimedTask(30, new StatusCheckTask());
    
    // Run every 5 minutes
    App.cron.registerTimedTask(5, new QuickUpdateTask());
    
    // Run every 2 hours (120 minutes)
    App.cron.registerTimedTask(120, new HeavyMaintenanceTask());
    
    logger.info("Timed tasks registered!");
}
```

!!! tip "Choosing Intervals"
    - **1-5 minutes** — Light operations, frequent updates
    - **15-30 minutes** — Regular maintenance, moderate operations
    - **60+ minutes** — Heavy operations, infrequent tasks

---

## :material-clock-time-three: Fixed Rate Tasks

Run tasks daily at a specific time (hour:minute).

### Example: Daily at 3:30 AM

```java
package com.example.plugin.tasks;

import dev.osunolimits.common.App;
import dev.osunolimits.modules.utils.cron.RunnableCronTask;

public class DailyMaintenanceTask extends RunnableCronTask {
    
    @Override
    public void run() {
        App.logger.info("Running daily maintenance at 3:30 AM");
        
        // Heavy operations suitable for low-traffic hours
        recalculateAllRankings();
        generateDailyReports();
        cleanupOldLogs();
        optimizeDatabase();
    }

    @Override
    public String getName() {
        return "DailyMaintenanceTask";
    }
    
    private void recalculateAllRankings() {
        // Implementation
    }
    
    private void generateDailyReports() {
        // Implementation
    }
    
    private void cleanupOldLogs() {
        // Implementation
    }
    
    private void optimizeDatabase() {
        // Implementation
    }
}
```

### Registering Fixed Rate Tasks

```java
@Override
protected void onEnable(String pluginName, Logger logger) {
    // Run daily at 3:30 AM
    App.cron.registerFixedRateTask(3, 30, new DailyMaintenanceTask());
    
    // Run daily at midnight (00:00)
    App.cron.registerFixedRateTask(0, 0, new MidnightResetTask());
    
    // Run daily at 6:45 PM (18:45)
    App.cron.registerFixedRateTask(18, 45, new EveningReportTask());
    
    logger.info("Fixed rate tasks registered!");
}
```

!!! note "Time Format"
    - **Hour:** 24-hour format (0-23)
    - **Minute:** 0-59
    - **Timezone:** Server's local timezone

!!! tip "Best Times for Heavy Tasks"
    Schedule resource-intensive operations during low-traffic hours:
    
    - **2:00-5:00 AM** — Typically lowest traffic
    - **Avoid peak hours** — Usually 12:00-23:00

---

## :material-clock: Hourly Tasks

Run tasks at the beginning of every hour (XX:00).

### Example: Every Hour

```java
package com.example.plugin.tasks;

import dev.osunolimits.common.App;
import dev.osunolimits.modules.utils.cron.RunnableCronTask;

public class HourlyStatsTask extends RunnableCronTask {
    
    @Override
    public void run() {
        App.logger.info("Running hourly statistics update");
        
        // Operations suitable for hourly execution
        updateOnlinePlayerCount();
        refreshLeaderboardCache();
        sendHourlyMetrics();
    }

    @Override
    public String getName() {
        return "HourlyStatsTask";
    }
    
    private void updateOnlinePlayerCount() {
        // Implementation
    }
    
    private void refreshLeaderboardCache() {
        // Implementation
    }
    
    private void sendHourlyMetrics() {
        // Implementation
    }
}
```

### Registering Hourly Tasks

```java
@Override
protected void onEnable(String pluginName, Logger logger) {
    // Run at the start of every hour
    App.cron.registerTaskEachFullHour(new HourlyStatsTask());
    App.cron.registerTaskEachFullHour(new HourlyBackupTask());
    
    logger.info("Hourly tasks registered!");
}
```

!!! success "Perfect For"
    - Regular status updates
    - Simple monitoring
    - Light maintenance
    - Cache refreshing
    - Metric collection

---

## :material-code-braces: Complete Plugin Example

Here's a full plugin with multiple cron tasks:

```java
package com.example.plugin;

import ch.qos.logback.classic.Logger;
import dev.osunolimits.common.App;
import dev.osunolimits.plugins.ShiinaPlugin;
import com.example.plugin.tasks.*;

public class Plugin extends ShiinaPlugin {

    @Override
    protected void onEnable(String pluginName, Logger logger) {
        // Register timed task - every 30 minutes
        App.cron.registerTimedTask(30, new StatusCheckTask());
        
        // Register fixed rate task - daily at 3:30 AM
        App.cron.registerFixedRateTask(3, 30, new DailyMaintenanceTask());
        
        // Register hourly task - every hour at XX:00
        App.cron.registerTaskEachFullHour(new HourlyStatsTask());
        
        logger.info("All cron tasks registered successfully!");
    }

    @Override
    protected void onDisable(String pluginName, Logger logger) {
        // Tasks are automatically unregistered when plugin is disabled
        logger.info("Plugin disabled, tasks stopped");
    }
}
```

---

## :material-database: Database Access in Tasks

Access the database within your cron tasks.

### Example with Database Operations

```java
package com.example.plugin.tasks;

import dev.osunolimits.common.App;
import dev.osunolimits.modules.utils.cron.RunnableCronTask;
import java.sql.ResultSet;

public class CleanupTask extends RunnableCronTask {
    
    @Override
    public void run() {
        try {
            App.logger.info("Starting database cleanup...");
            
            // Delete old sessions (older than 30 days)
            int deleted = App.mysql.Exec(
                "DELETE FROM sessions WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY)"
            );
            
            App.logger.info("Deleted " + deleted + " old sessions");
            
            // Query for inactive users
            ResultSet rs = App.mysql.Query(
                "SELECT COUNT(*) as count FROM users WHERE last_seen < DATE_SUB(NOW(), INTERVAL 365 DAY)"
            );
            
            if (rs.next()) {
                int inactiveCount = rs.getInt("count");
                App.logger.info("Found " + inactiveCount + " inactive users");
            }
            
        } catch (Exception e) {
            App.logger.error("Error during cleanup: " + e.getMessage());
        }
    }

    @Override
    public String getName() {
        return "CleanupTask";
    }
}
```

!!! warning "Error Handling"
    Always wrap database operations in try-catch blocks to prevent task failures from crashing your plugin!

---

## :material-check-all: Best Practices

!!! tip "Cron Task Development Tips"
    - ✅ **Use descriptive task names** — `UserCleanupTask` not `Task1`
    - ✅ **Log task execution** — Help with debugging and monitoring
    - ✅ **Handle errors gracefully** — Use try-catch blocks
    - ✅ **Keep tasks efficient** — Avoid long-running operations
    - ✅ **Choose appropriate intervals** — Don't over-schedule
    - ✅ **Test timing** — Verify tasks run at expected times
    - ✅ **Document task purposes** — Add comments explaining what they do

!!! warning "Common Mistakes"
    - ❌ Don't run heavy operations too frequently
    - ❌ Don't forget error handling
    - ❌ Don't block the main thread
    - ❌ Don't leave debugging logs in production
    - ❌ Don't schedule multiple similar tasks
    - ❌ Don't ignore task execution failures

---

## :material-timer-sand: Task Execution Timing

Understanding when tasks actually run:

### Timed Tasks
- Start when plugin enables
- Run at exact intervals
- Example: Registered at 10:00, interval 30 min → runs at 10:30, 11:00, 11:30...

### Fixed Rate Tasks
- Run once per day
- At specified hour:minute
- Example: Scheduled for 3:30 AM → runs at 3:30 AM every day

### Hourly Tasks
- Run at the top of each hour
- Example: Registered at 10:15 → first runs at 11:00, then 12:00, 13:00...

---

## :material-bug: Debugging Tasks

### Logging Best Practices

```java
@Override
public void run() {
    long startTime = System.currentTimeMillis();
    App.logger.info("[" + getName() + "] Starting execution");
    
    try {
        // Your task code
        performWork();
        
        long duration = System.currentTimeMillis() - startTime;
        App.logger.info("[" + getName() + "] Completed in " + duration + "ms");
        
    } catch (Exception e) {
        App.logger.error("[" + getName() + "] Error: " + e.getMessage());
        e.printStackTrace();
    }
}
```

### Monitoring Task Execution

Check Shiina-Web logs to see task output:

```bash
docker logs shiina-web | grep "TaskName"
```

---

<div align="center">
    <p><em>© 2026 Marc Andre Herpers. All rights reserved.</em></p>
</div>
