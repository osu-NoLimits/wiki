# :material-star: Advanced Plugin Development

Master advanced techniques for building powerful Shiina-Web plugins.

---

## :material-database: Advanced Database Operations

### Connection Pooling

The `App.mysql` object manages connection pooling automatically, but you should still write efficient queries.

```java
// Good: Single query with JOIN
ResultSet rs = App.mysql.Query(
    "SELECT u.*, s.playcount FROM users u " +
    "LEFT JOIN stats s ON u.id = s.user_id " +
    "WHERE u.id = ?",
    userId
);

// Avoid: Multiple queries
ResultSet user = App.mysql.Query("SELECT * FROM users WHERE id = ?", userId);
ResultSet stats = App.mysql.Query("SELECT * FROM stats WHERE user_id = ?", userId);
```

### Batch Operations

For multiple INSERT/UPDATE operations:

```java
public void batchUpdateUsers(List<Integer> userIds) {
    try {
        // Begin transaction
        App.mysql.Exec("START TRANSACTION");
        
        for (Integer userId : userIds) {
            App.mysql.Exec(
                "UPDATE users SET last_updated = NOW() WHERE id = ?",
                userId
            );
        }
        
        // Commit transaction
        App.mysql.Exec("COMMIT");
        
    } catch (Exception e) {
        // Rollback on error
        App.mysql.Exec("ROLLBACK");
        App.logger.error("Batch update failed: " + e.getMessage());
    }
}
```

### Pagination

Efficiently handle large result sets:

```java
public class LeaderboardRoute extends Shiina {
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        int page = Integer.parseInt(req.queryParams("page") != null ? req.queryParams("page") : "1");
        int perPage = 50;
        int offset = (page - 1) * perPage;
        
        ResultSet rs = shiina.mysql.Query(
            "SELECT * FROM users ORDER BY pp DESC LIMIT ? OFFSET ?",
            perPage, offset
        );
        
        // Process results...
        
        return renderPage(res, shiina, "leaderboard.html");
    }
}
```

---

## :material-shield-check: Security Best Practices

### Input Validation

Always validate and sanitize user input:

```java
public class UpdateProfileRoute extends Shiina {
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        String bio = req.queryParams("bio");
        
        // Validate length
        if (bio == null || bio.length() > 500) {
            res.status(400);
            return "{\"error\": \"Bio must be between 1-500 characters\"}";
        }
        
        // Sanitize HTML/Scripts
        bio = sanitizeInput(bio);
        
        // Update database
        shiina.mysql.Exec(
            "UPDATE users SET bio = ? WHERE id = ?",
            bio, shiina.user.id
        );
        
        return redirect(res, shiina, "/profile");
    }
    
    private String sanitizeInput(String input) {
        // Remove HTML tags and dangerous characters
        return input.replaceAll("<[^>]*>", "")
                   .replaceAll("[<>\"'&]", "");
    }
}
```

### Permission Checking

```java
public class AdminRoute extends Shiina {
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Check if user is logged in
        if (!shiina.loggedIn) {
            return redirect(res, shiina, "/login");
        }
        
        // Check admin privileges
        ResultSet rs = shiina.mysql.Query(
            "SELECT priv FROM users WHERE id = ?",
            shiina.user.id
        );
        
        if (rs.next()) {
            int privileges = rs.getInt("priv");
            boolean isAdmin = (privileges & 4) != 0; // Check admin bit
            
            if (!isAdmin) {
                res.status(403);
                return "{\"error\": \"Forbidden\"}";
            }
        }
        
        // Admin-only code here
        return "Welcome, admin!";
    }
}
```

### Rate Limiting

Protect your routes from abuse:

```java
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class RateLimitedRoute extends Shiina {
    private static final ConcurrentHashMap<String, AtomicInteger> requestCounts = new ConcurrentHashMap<>();
    private static final int MAX_REQUESTS = 10; // per minute
    
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        String clientIp = req.ip();
        
        // Get or create counter
        AtomicInteger counter = requestCounts.computeIfAbsent(
            clientIp,
            k -> new AtomicInteger(0)
        );
        
        // Check rate limit
        if (counter.incrementAndGet() > MAX_REQUESTS) {
            res.status(429);
            return "{\"error\": \"Too many requests\"}";
        }
        
        // Process request...
        return "{\"status\": \"success\"}";
    }
}
```

---

## :material-file-code: Configuration Files

Store plugin settings in external configuration files.

### Creating config.json

```json
{
    "enabled": true,
    "apiKey": "your-api-key",
    "refreshInterval": 30,
    "features": {
        "notifications": true,
        "analytics": false
    }
}
```

### Loading Configuration

```java
package com.example.plugin;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.FileReader;
import java.io.IOException;

public class PluginConfig {
    private JsonObject config;
    
    public PluginConfig(String configPath) {
        try {
            FileReader reader = new FileReader(configPath);
            this.config = new Gson().fromJson(reader, JsonObject.class);
            reader.close();
        } catch (IOException e) {
            App.logger.error("Failed to load config: " + e.getMessage());
            this.config = new JsonObject();
        }
    }
    
    public boolean isEnabled() {
        return config.has("enabled") && config.get("enabled").getAsBoolean();
    }
    
    public String getApiKey() {
        return config.has("apiKey") ? config.get("apiKey").getAsString() : "";
    }
    
    public int getRefreshInterval() {
        return config.has("refreshInterval") ? config.get("refreshInterval").getAsInt() : 30;
    }
}
```

### Using Configuration in Plugin

```java
public class Plugin extends ShiinaPlugin {
    private PluginConfig config;
    
    @Override
    protected void onEnable(String pluginName, Logger logger) {
        // Load configuration
        config = new PluginConfig("plugins/" + pluginName + "/config.json");
        
        if (!config.isEnabled()) {
            logger.warn("Plugin is disabled in configuration");
            return;
        }
        
        // Use configuration values
        int interval = config.getRefreshInterval();
        App.cron.registerTimedTask(interval, new UpdateTask());
        
        logger.info("Plugin enabled with " + interval + " minute interval");
    }
}
```

---

## :material-webhook: External API Integration

Call external services from your plugin.

### HTTP Requests with OkHttp

```java
import okhttp3.*;
import com.google.gson.Gson;

public class ApiTask extends RunnableCronTask {
    private final OkHttpClient client = new OkHttpClient();
    
    @Override
    public void run() {
        try {
            // Build request
            Request request = new Request.Builder()
                .url("https://api.example.com/data")
                .addHeader("Authorization", "Bearer YOUR_TOKEN")
                .build();
            
            // Execute request
            Response response = client.newCall(request).execute();
            
            if (response.isSuccessful()) {
                String jsonData = response.body().string();
                processApiResponse(jsonData);
            } else {
                App.logger.error("API request failed: " + response.code());
            }
            
        } catch (Exception e) {
            App.logger.error("API error: " + e.getMessage());
        }
    }
    
    private void processApiResponse(String json) {
        // Parse and handle response
        JsonObject data = new Gson().fromJson(json, JsonObject.class);
        // ...
    }
    
    @Override
    public String getName() {
        return "ApiTask";
    }
}
```

### Discord Webhooks

```java
public void sendDiscordNotification(String webhookUrl, String message) {
    try {
        OkHttpClient client = new OkHttpClient();
        
        JsonObject payload = new JsonObject();
        payload.addProperty("content", message);
        
        RequestBody body = RequestBody.create(
            payload.toString(),
            MediaType.parse("application/json")
        );
        
        Request request = new Request.Builder()
            .url(webhookUrl)
            .post(body)
            .build();
        
        Response response = client.newCall(request).execute();
        
        if (!response.isSuccessful()) {
            App.logger.error("Discord webhook failed: " + response.code());
        }
        
    } catch (Exception e) {
        App.logger.error("Discord notification error: " + e.getMessage());
    }
}
```

---

## :material-memory: Caching

Implement caching to improve performance.

### Simple In-Memory Cache

```java
import java.util.concurrent.ConcurrentHashMap;

public class CacheManager {
    private static final ConcurrentHashMap<String, CachedData> cache = new ConcurrentHashMap<>();
    private static final long CACHE_DURATION = 5 * 60 * 1000; // 5 minutes
    
    public static class CachedData {
        public Object data;
        public long timestamp;
        
        public CachedData(Object data) {
            this.data = data;
            this.timestamp = System.currentTimeMillis();
        }
        
        public boolean isExpired() {
            return System.currentTimeMillis() - timestamp > CACHE_DURATION;
        }
    }
    
    public static void put(String key, Object data) {
        cache.put(key, new CachedData(data));
    }
    
    public static Object get(String key) {
        CachedData cached = cache.get(key);
        
        if (cached == null || cached.isExpired()) {
            cache.remove(key);
            return null;
        }
        
        return cached.data;
    }
    
    public static void clear() {
        cache.clear();
    }
}
```

### Using Cache in Routes

```java
public class LeaderboardRoute extends Shiina {
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Try to get from cache
        String cacheKey = "leaderboard_top100";
        Object cachedData = CacheManager.get(cacheKey);
        
        if (cachedData != null) {
            App.logger.debug("Serving from cache");
            res.type("application/json");
            return cachedData;
        }
        
        // Cache miss - query database
        ResultSet rs = shiina.mysql.Query(
            "SELECT * FROM users ORDER BY pp DESC LIMIT 100"
        );
        
        // Build response
        String jsonResponse = buildJsonResponse(rs);
        
        // Store in cache
        CacheManager.put(cacheKey, jsonResponse);
        
        res.type("application/json");
        return jsonResponse;
    }
}
```

---

## :material-file-multiple: Working with Files

Read and write files in your plugin.

### Reading Files

```java
import java.nio.file.Files;
import java.nio.file.Paths;

public String readFile(String path) {
    try {
        return new String(Files.readAllBytes(Paths.get(path)));
    } catch (IOException e) {
        App.logger.error("Failed to read file: " + e.getMessage());
        return "";
    }
}
```

### Writing Files

```java
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public void writeFile(String path, String content) {
    try {
        Files.write(
            Paths.get(path),
            content.getBytes(),
            StandardOpenOption.CREATE,
            StandardOpenOption.TRUNCATE_EXISTING
        );
    } catch (IOException e) {
        App.logger.error("Failed to write file: " + e.getMessage());
    }
}
```

---

## :material-bug: Error Handling and Logging

### Comprehensive Error Handling

```java
public class RobustRoute extends Shiina {
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        try {
            // Your route logic
            return processRequest(req, shiina);
            
        } catch (SQLException e) {
            App.logger.error("Database error: " + e.getMessage(), e);
            res.status(500);
            return "{\"error\": \"Database error occurred\"}";
            
        } catch (IllegalArgumentException e) {
            App.logger.warn("Invalid input: " + e.getMessage());
            res.status(400);
            return "{\"error\": \"Invalid input\"}";
            
        } catch (Exception e) {
            App.logger.error("Unexpected error: " + e.getMessage(), e);
            res.status(500);
            return "{\"error\": \"Internal server error\"}";
        }
    }
}
```

### Structured Logging

```java
// Info level - normal operations
App.logger.info("[MyPlugin] User " + userId + " performed action");

// Debug level - detailed information
App.logger.debug("[MyPlugin] Processing request with params: " + params);

// Warn level - potential issues
App.logger.warn("[MyPlugin] Slow query detected: " + duration + "ms");

// Error level - actual errors
App.logger.error("[MyPlugin] Failed to process request", exception);
```

---

## :material-test-tube: Testing Your Plugin

### Manual Testing Checklist

- [ ] Plugin loads without errors
- [ ] Routes respond correctly
- [ ] Database operations succeed
- [ ] Scheduled tasks execute on time
- [ ] Error handling works properly
- [ ] Logs are meaningful
- [ ] Performance is acceptable
- [ ] No memory leaks

### Load Testing Routes

Use tools like Apache Bench to test route performance:

```bash
# Test route with 1000 requests, 10 concurrent
ab -n 1000 -c 10 https://yourdomain.dev/your-route
```

---

## :material-package-variant: Dependency Management

Add external libraries to your plugin via `pom.xml`:

```xml
<dependencies>
    <!-- OkHttp for HTTP requests -->
    <dependency>
        <groupId>com.squareup.okhttp3</groupId>
        <artifactId>okhttp</artifactId>
        <version>4.12.0</version>
    </dependency>
    
    <!-- Gson for JSON -->
    <dependency>
        <groupId>com.google.code.gson</groupId>
        <artifactId>gson</artifactId>
        <version>2.10.1</version>
    </dependency>
</dependencies>
```

---

## :material-arrow-right-circle: Further Resources

- :material-file-code: **[Plugin starter template](https://github.com/osu-NoLimits/shiina-plugin)**
- :material-routes: **[Route documentation](routes.md)**
- :material-clock-outline: **[Cron task guide](cron-tasks.md)**

---

<div align="center">
    <p><em>© 2026 Marc Andre Herpers. All rights reserved.</em></p>
</div>
