# :material-routes: Working with Routes

Create custom web routes and API endpoints in your Shiina-Web plugins.

---

## :material-web: What Are Routes?

Routes define URL endpoints that users can access. They can serve:

- 🌐 **Web Pages** — HTML templates with dynamic content
- 🔌 **REST APIs** — JSON responses for integrations
- 📥 **Form Handlers** — Process POST requests
- 🔄 **Redirects** — Route users to different pages

---

## :material-plus-box: Registering Routes

Routes are registered in your plugin's `onEnable()` method using the `WebServer` class.

### Basic Registration

```java
package com.example.plugin;

import com.example.plugin.routes.ExampleRoute;
import ch.qos.logback.classic.Logger;
import dev.osunolimits.main.WebServer;
import dev.osunolimits.plugins.ShiinaPlugin;

public class Plugin extends ShiinaPlugin {

    @Override
    protected void onEnable(String pluginName, Logger logger) {
        // Register GET route
        WebServer.get("/example", new ExampleRoute());
        
        // Register POST route
        WebServer.post("/example", new ExampleRoute());
        
        logger.info("Routes registered successfully!");
    }

    @Override
    protected void onDisable(String pluginName, Logger logger) {
        // Routes are automatically unregistered
    }
}
```

### HTTP Methods

| Method | Usage | Example |
|--------|-------|---------|
| `WebServer.get()` | Retrieve data, display pages | Profile pages, leaderboards |
| `WebServer.post()` | Submit forms, create resources | Login, registration |
| `WebServer.put()` | Update existing resources | Edit profile |
| `WebServer.delete()` | Remove resources | Delete account |

---

## :material-api: Creating API Routes

API routes return JSON data without HTML templates — perfect for integrations and AJAX requests.

### Simple API Example

Create `routes/ExampleRoute.java`:

```java
package com.example.plugin.routes;

import dev.osunolimits.modules.Shiina;
import dev.osunolimits.modules.ShiinaRoute;
import dev.osunolimits.modules.ShiinaRoute.ShiinaRequest;
import spark.Request;
import spark.Response;

public class ExampleRoute extends Shiina {

    @Override
    public Object handle(Request req, Response res) throws Exception {
        // Initialize Shiina request context
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Set response type to JSON
        res.type("application/json");
        
        // Return JSON response
        return "{\"status\": \"success\", \"message\": \"Hello from API!\"}";
    }
}
```

### Accessing the Route

Once registered, access your API at:
```
https://yourdomain.dev/example
```

---

## :material-database: Database Access in Routes

Access MySQL database through the `shiina.mysql` object.

### Query Examples

```java
package com.example.plugin.routes;

import dev.osunolimits.modules.Shiina;
import dev.osunolimits.modules.ShiinaRoute;
import dev.osunolimits.modules.ShiinaRoute.ShiinaRequest;
import spark.Request;
import spark.Response;
import java.sql.ResultSet;

public class UserStatsRoute extends Shiina {

    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Get user ID from URL parameter
        String userId = req.params(":id");
        
        // Query database with prepared statement
        ResultSet result = shiina.mysql.Query(
            "SELECT * FROM users WHERE id = ?",
            Integer.parseInt(userId)
        );
        
        if (result.next()) {
            String username = result.getString("username");
            int playcount = result.getInt("playcount");
            
            res.type("application/json");
            return String.format(
                "{\"username\": \"%s\", \"playcount\": %d}",
                username, playcount
            );
        }
        
        return notFound(res, shiina);
    }
}
```

### Database Methods

| Method | Purpose | Example |
|--------|---------|---------|
| `shiina.mysql.Query(sql, params...)` | SELECT queries | Read data |
| `shiina.mysql.Exec(sql, params...)` | INSERT, UPDATE, DELETE | Modify data |

!!! warning "Security: Always Use Prepared Statements"
    ✅ **DO:** `shiina.mysql.Query("SELECT * FROM users WHERE id = ?", userId)`
    
    ❌ **DON'T:** `shiina.mysql.Query("SELECT * FROM users WHERE id = " + userId)`
    
    Prepared statements prevent SQL injection attacks!

---

## :material-redirect: Redirects and Response Helpers

Shiina provides helper methods for common responses.

### Redirect to Another Page

```java
return redirect(res, shiina, "/dashboard");
```

### Show 404 Not Found

```java
return notFound(res, shiina);
```

### Custom Error Messages

```java
res.status(400);
res.type("application/json");
return "{\"error\": \"Invalid input\"}";
```

---

## :material-form-textbox: Handling Form Data

Process POST requests with form data.

### Example Form Handler

```java
package com.example.plugin.routes;

import dev.osunolimits.modules.Shiina;
import dev.osunolimits.modules.ShiinaRoute;
import dev.osunolimits.modules.ShiinaRoute.ShiinaRequest;
import spark.Request;
import spark.Response;

public class SubmitFormRoute extends Shiina {

    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Get form data
        String username = req.queryParams("username");
        String email = req.queryParams("email");
        
        // Validate input
        if (username == null || username.isEmpty()) {
            res.status(400);
            res.type("application/json");
            return "{\"error\": \"Username is required\"}";
        }
        
        // Process the data
        shiina.mysql.Exec(
            "INSERT INTO submissions (username, email) VALUES (?, ?)",
            username, email
        );
        
        // Redirect to success page
        return redirect(res, shiina, "/success");
    }
}
```

### Register as POST Route

```java
WebServer.post("/submit-form", new SubmitFormRoute());
```

---

## :material-shield-check: Authentication in Routes

Check if a user is logged in and access their data.

### Example with Authentication

```java
package com.example.plugin.routes;

import dev.osunolimits.modules.Shiina;
import dev.osunolimits.modules.ShiinaRoute;
import dev.osunolimits.modules.ShiinaRoute.ShiinaRequest;
import spark.Request;
import spark.Response;

public class ProtectedRoute extends Shiina {

    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Check if user is logged in
        if (shiina.loggedIn) {
            // Access user data
            int userId = shiina.user.id;
            String username = shiina.user.name;
            
            res.type("application/json");
            return String.format(
                "{\"message\": \"Hello, %s!\", \"id\": %d}",
                username, userId
            );
        } else {
            // Redirect to login page
            return redirect(res, shiina, "/login");
        }
    }
}
```

### ShiinaRequest Properties

| Property | Type | Description |
|----------|------|-------------|
| `shiina.loggedIn` | boolean | Whether user is authenticated |
| `shiina.user.id` | int | User's database ID |
| `shiina.user.name` | String | Username |
| `shiina.user.country` | String | Country code |
| `shiina.mysql` | Object | Database connection |

---

## :material-code-json: JSON Response Builder

For complex JSON responses, use a JSON library or build programmatically.

### Using Gson (Recommended)

```java
import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class JsonApiRoute extends Shiina {

    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        JsonObject response = new JsonObject();
        response.addProperty("status", "success");
        response.addProperty("timestamp", System.currentTimeMillis());
        response.addProperty("user", shiina.user.name);
        
        res.type("application/json");
        return new Gson().toJson(response);
    }
}
```

---

## :material-link-variant: URL Parameters

Capture dynamic values from the URL.

### Route with Parameters

```java
// Register route with parameter
WebServer.get("/user/:id", new UserProfileRoute());

// In your route handler
public class UserProfileRoute extends Shiina {
    @Override
    public Object handle(Request req, Response res) throws Exception {
        ShiinaRequest shiina = new ShiinaRoute().handle(req, res);
        
        // Get parameter value
        String userId = req.params(":id");
        
        // Use the parameter...
        return "User ID: " + userId;
    }
}
```

### Query String Parameters

```java
// URL: /search?q=keyword&page=2
String query = req.queryParams("q");      // "keyword"
String page = req.queryParams("page");    // "2"
```

---

## :material-check-all: Best Practices

!!! tip "Route Development Tips"
    - ✅ **Use descriptive route paths** — `/api/user-stats` not `/usr`
    - ✅ **Return appropriate HTTP status codes** — 200, 404, 400, 500
    - ✅ **Validate all input data** — Never trust user input
    - ✅ **Use prepared statements** — Prevent SQL injection
    - ✅ **Handle errors gracefully** — Use try-catch blocks
    - ✅ **Set correct content types** — `application/json` for APIs
    - ✅ **Log important events** — Help with debugging

!!! warning "Common Mistakes"
    - ❌ Don't expose sensitive data in API responses
    - ❌ Don't use string concatenation for SQL queries
    - ❌ Don't forget to validate user permissions
    - ❌ Don't return stack traces to users
    - ❌ Don't ignore error handling

---

<div align="center">
    <p><em>© 2026 Marc Andre Herpers. All rights reserved.</em></p>
</div>
