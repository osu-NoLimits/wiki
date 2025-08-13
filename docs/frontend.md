Welcome to the comprehensive guide for building frontends that integrate with [bancho.py-ex](https://github.com/osu-NoLimits/bancho.py-ex). This guide covers the PubSub system that enables real-time communication between your frontend and the server.

!!! info "What are PubSubs?"
    **PubSubs** (Publish-Subscribe) are real-time communication channels that allow external applications to interact with the bancho.py-ex server. Each channel either **sends** data from the server or **receives** commands from your application.

!!! tip "Getting Started"
    - :material-send: **Sends** - Server pushes data to your application
    - :fontawesome-solid-satellite-dish: **Receives** - Your application sends commands to server
    - :material-code-json: All data is transmitted in JSON format

## :material-file: Implementation example

=== ":fontawesome-brands-java: Shiina"
    ```java
    public void onEnable(String, pluginName, Logger logger) {
        PubSubModels.RankOutput rankOutput = new PubSubModels().new RankOutput();
        rankOutput.setBeatmap_id("1");
        rankOutput.setStatus(2); // ranked
        rankOutput.setFrozen(true);

        long subscribers = App.jedisPool.publish("rank", new Gson().toJson(rankOutput));
    }
    ```

=== ":fontawesome-brands-python: bancho.py-ex"
    ```python
    @router.post("/web/osu-submit-modular.php")
    async def osuSubmitModular(...) -> Response:
        score = Score.from_submission(score_data[2:])
        pubsub = app.state.services.redis.pubsub()
        await pubsub.execute_command("PUBLISH", "ex:submit", score.toJSON())
    ```



## :material-broadcast: Score / Map management

### :material-trophy: Score Submissions

!!! example ":material-send: `ex:submit`"

    **Direction:** :material-arrow-right: Server sends to your application  
    **Purpose:** Real-time score submissions and statistics
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 219154,
          "mode": 0,
          "mods": 88,
          "pp": 221283.124,
          "sr": 90.73485416518942,
          "score": 88845,
          "max_combo": 3,
          "acc": 2.158273381294964,
          "n300": 3,
          "n100": 0,
          "n50": 0,
          "nmiss": 136,
          "ngeki": 1,
          "nkatu": 0,
          "grade": 1,
          "passed": false,
          "perfect": false,
          "status": 0,
          "client_time": "2025-02-02T11:10:58",
          "server_time": "2025-02-02T11:10:57.000379",
          "time_elapsed": 54540,
          "client_flags": 0,
          "client_checksum": "EXAMPLE",
          "rank": null,
          "beatmap_id": 372245,
          "player_id": 1316
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Unique score ID |
        | `mode` | `int` | Game mode (0=std, 1=taiko, 2=catch, 3=mania) |
        | `mods` | `int` | Mod combination bitwise |
        | `pp` | `float` | Performance points |
        | `sr` | `float` | Star rating |
        | `score` | `int` | Total score |
        | `max_combo` | `int` | Maximum combo achieved |
        | `acc` | `float` | Accuracy percentage |
        | `passed` | `bool` | Whether the map was passed |
        | `beatmap_id` | `int` | Beatmap identifier |
        | `player_id` | `int` | Player identifier |

### :material-map: Beatmap Status Changes

!!! example ":material-send: `ex:map_status_change`"
    **Direction:** :material-arrow-right: Server sends to your application  
    **Purpose:** Beatmap ranking status updates
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "map_ids": [4840847, 4888854, 4892923, 4894589, 4918951],
          "ranktype": "set",
          "type": "love"
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `map_ids` | `int[]` | Array of beatmap IDs affected |
        | `ranktype` | `string` | Ranking operation type (`set`, `update`) |
        | `type` | `string` | New status (`love`, `ranked`, `approved`, `pending`) |

### :material-star: Beatmap Ranking

!!! example ":fontawesome-solid-satellite-dish: `rank`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Manually rank/unrank beatmaps
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "beatmap_id": 4870830,
          "status": 2,
          "frozen": true
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `beatmap_id` | `int` | Target beatmap ID |
        | `status` | `int` | Ranking status (0=pending, 1=ranked, 2=approved, 3=qualified, 4=loved) |
        | `frozen` | `bool` | Whether to freeze the beatmap from further changes |

## :material-account-supervisor: User Management

### :material-account-cancel: User Restriction

!!! example ":fontawesome-solid-satellite-dish: `restrict`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Restrict user accounts
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 3,
          "userId": 3,
          "reason": "the owner cheats"
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Target user ID to restrict |
        | `userId` | `int` | Admin user ID performing the action |
        | `reason` | `string` | Reason for restriction |

### :material-account-check: User Unrestriction

!!! example ":fontawesome-solid-satellite-dish: `unrestrict`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Unrestrict user accounts
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 3,
          "userId": 3,
          "reason": "isn't a bad guy"
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Target user ID to unrestrict |
        | `userId` | `int` | Admin user ID performing the action |
        | `reason` | `string` | Reason for unrestriction |

### :material-delete-sweep: User Data Wipe

!!! example ":fontawesome-solid-satellite-dish: `wipe`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Wipe user statistics for specific game mode
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 3,
          "mode": 0
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Target user ID |
        | `mode` | `int` | Game mode to wipe (0=std, 1=taiko, 2=catch, 3=mania) |

## :material-message-alert: Communication

### :material-bullhorn: Global Announcements

!!! example ":fontawesome-solid-satellite-dish: `alert_all`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Send announcements to all online users
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "message": "Server maintenance in 10 minutes!"
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `message` | `string` | Announcement message to broadcast |

## :material-crown: Premium Features

### :material-heart: Supporter Status

!!! example ":fontawesome-solid-satellite-dish: `givedonator`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Grant supporter/donator status
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 3,
          "duration": "1w"
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Target user ID |
        | `duration` | `string` | Duration (s=seconds, m=minutes, h=hours, d=days, w=weeks) |

## :material-shield-account: Privileges Management

!!! info "Available Privileges"
    `normal` • `verified` • `whitelisted` • `supporter` • `premium` • `alumni` • `tournament` • `nominator` • `mod` • `admin` • `developer`


### :material-plus-circle: Add Privileges

!!! example ":fontawesome-solid-satellite-dish: `addpriv`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Grant user privileges
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 3,
          "privs": ["admin", "developer"]
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Target user ID |
        | `privs` | `string[]` | Array of privileges to add |

### :material-minus-circle: Remove Privileges

!!! example ":fontawesome-solid-satellite-dish: `removepriv`"

    **Direction:** :material-arrow-left: Your application sends to server  
    **Purpose:** Remove user privileges
    
    === ":material-code-json: JSON Data"
    
        ```json
        {
          "id": 3,
          "privs": ["admin", "developer"]
        }
        ```
    
    === ":material-chart-line: Field Reference"
    
        | Field | Type | Description |
        |-------|------|-------------|
        | `id` | `int` | Target user ID |
        | `privs` | `string[]` | Array of privileges to remove |
