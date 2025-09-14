#!/usr/bin/ucode

/*
 * Web API Server Example for ucode
 * Demonstrates HTTP handling, REST endpoints, and JSON APIs
 * Note: This is a conceptual example - actual HTTP server implementation
 * would require native ucode HTTP modules or external web server integration
 */

// Global configuration
const SERVER_PORT = 8080;
const API_VERSION = "v1";
const DATA_FILE = "/tmp/api_data.json";

// In-memory data store
let data_store = {
    users: [
        { id: 1, name: "admin", email: "admin@example.com", role: "administrator" },
        { id: 2, name: "user1", email: "user1@example.com", role: "user" }
    ],
    posts: [
        { id: 1, title: "Welcome", content: "Welcome to the API", author_id: 1 },
        { id: 2, title: "Getting Started", content: "How to use this API", author_id: 1 }
    ],
    sessions: {},
    next_user_id: 3,
    next_post_id: 3
};

// Utility functions
function generate_id() {
    // Simple ID generation using time and a counter
    let timestamp = time();
    let counter = timestamp % 10000;
    return sprintf("%08x%08x", timestamp, counter);
}

function parse_query_params(query_string) {
    let params = {};
    if (!query_string) return params;

    let pairs = split(query_string, "&");
    for (pair in pairs) {
        let kv = split(pair, "=", 2);
        if (length(kv) == 2) {
            params[kv[0]] = kv[1];
        }
    }
    return params;
}

function send_json_response(status_code, data) {
    let json_data = sprintf("%J", data);

    print("HTTP/1.1 " + status_code + " OK\r\n");
    print("Content-Type: application/json\r\n");
    print("Content-Length: " + length(json_data) + "\r\n");
    print("Access-Control-Allow-Origin: *\r\n");
    print("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n");
    print("Access-Control-Allow-Headers: Content-Type, Authorization\r\n");
    print("\r\n");
    print(json_data);
}

function send_error_response(status_code, message) {
    send_json_response(status_code, {
        error: true,
        message: message,
        timestamp: time()
    });
}

function validate_json_input(body, required_fields) {
    if (!body) {
        return { valid: false, error: "Empty request body" };
    }

    try {
        let data = json(body);

        for (field in required_fields) {
            if (!(field in data) || data[field] == null) {
                return { valid: false, error: "Missing required field: " + field };
            }
        }

        return { valid: true, data: data };
    } catch (e) {
        return { valid: false, error: "Invalid JSON: " + e };
    }
}

// Authentication middleware
function authenticate_request(auth_header) {
    if (!auth_header) {
        return { authenticated: false, error: "Missing authorization header" };
    }

    let token = replace(auth_header, "Bearer ", "");
    if (token in data_store.sessions) {
        let session = data_store.sessions[token];
        if (session.expires > time()) {
            return { authenticated: true, user_id: session.user_id };
        } else {
            delete data_store.sessions[token];
            return { authenticated: false, error: "Token expired" };
        }
    }

    return { authenticated: false, error: "Invalid token" };
}

// API endpoint handlers
function handle_login(method, body) {
    if (method != "POST") {
        send_error_response(405, "Method not allowed");
        return;
    }

    let validation = validate_json_input(body, ["username", "password"]);
    if (!validation.valid) {
        send_error_response(400, validation.error);
        return;
    }

    let credentials = validation.data;

    // Simple authentication (in real app, use proper hashing)
    let user = null;
    for (u in data_store.users) {
        if (u.name == credentials.username) {
            user = u;
            break;
        }
    }

    if (!user || credentials.password != "password123") {
        send_error_response(401, "Invalid credentials");
        return;
    }

    // Create session
    let token = generate_id();
    data_store.sessions[token] = {
        user_id: user.id,
        expires: time() + 3600  // 1 hour
    };

    send_json_response(200, {
        success: true,
        token: token,
        user: {
            id: user.id,
            name: user.name,
            role: user.role
        }
    });
}

function handle_users_list(query_string) {
    let query_params = parse_query_params(query_string);
    let limit = int(query_params.limit) || 10;
    let offset = int(query_params.offset) || 0;

    let users = slice(data_store.users, offset, offset + limit);

    send_json_response(200, {
        users: users,
        total: length(data_store.users),
        limit: limit,
        offset: offset
    });
}

function handle_users_get(user_id) {
    let user = null;

    for (u in data_store.users) {
        if (u.id == user_id) {
            user = u;
            break;
        }
    }

    if (!user) {
        send_error_response(404, "User not found");
        return;
    }

    send_json_response(200, user);
}

function handle_users_create(body) {
    let validation = validate_json_input(body, ["name", "email"]);
    if (!validation.valid) {
        send_error_response(400, validation.error);
        return;
    }

    let user_data = validation.data;

    // Check if email already exists
    for (u in data_store.users) {
        if (u.email == user_data.email) {
            send_error_response(409, "Email already exists");
            return;
        }
    }

    let new_user = {
        id: data_store.next_user_id++,
        name: user_data.name,
        email: user_data.email,
        role: user_data.role || "user"
    };

    push(data_store.users, new_user);
    send_json_response(201, new_user);
}

function handle_users_update(user_id, body) {
    let user_index = -1;

    for (let i = 0; i < length(data_store.users); i++) {
        if (data_store.users[i].id == user_id) {
            user_index = i;
            break;
        }
    }

    if (user_index == -1) {
        send_error_response(404, "User not found");
        return;
    }

    let validation = validate_json_input(body, []);
    if (!validation.valid) {
        send_error_response(400, validation.error);
        return;
    }

    let updates = validation.data;

    // Update user
    if ("name" in updates) data_store.users[user_index].name = updates.name;
    if ("email" in updates) data_store.users[user_index].email = updates.email;
    if ("role" in updates) data_store.users[user_index].role = updates.role;

    send_json_response(200, data_store.users[user_index]);
}

function handle_users_delete(user_id) {
    let user_index = -1;

    for (let i = 0; i < length(data_store.users); i++) {
        if (data_store.users[i].id == user_id) {
            user_index = i;
            break;
        }
    }

    if (user_index == -1) {
        send_error_response(404, "User not found");
        return;
    }

    // Remove user
    splice(data_store.users, user_index, 1);
    send_json_response(204, {});
}

function handle_users(method, path_parts, query_string, body, auth_header) {
    let auth = authenticate_request(auth_header);
    if (!auth.authenticated) {
        send_error_response(401, auth.error);
        return;
    }

    if (method == "GET") {
        if (length(path_parts) > 3) {
            // GET /api/v1/users/:id
            let user_id = int(path_parts[3]);
            handle_users_get(user_id);
        } else {
            // GET /api/v1/users
            handle_users_list(query_string);
        }
    } else if (method == "POST") {
        // POST /api/v1/users
        handle_users_create(body);
    } else if (method == "PUT" && length(path_parts) > 3) {
        // PUT /api/v1/users/:id
        let user_id = int(path_parts[3]);
        handle_users_update(user_id, body);
    } else if (method == "DELETE" && length(path_parts) > 3) {
        // DELETE /api/v1/users/:id
        let user_id = int(path_parts[3]);
        handle_users_delete(user_id);
    } else {
        send_error_response(405, "Method not allowed");
    }
}

function handle_posts_list() {
    send_json_response(200, {
        posts: data_store.posts,
        total: length(data_store.posts)
    });
}

function handle_posts_get(post_id) {
    let post = null;

    for (p in data_store.posts) {
        if (p.id == post_id) {
            post = p;
            break;
        }
    }

    if (!post) {
        send_error_response(404, "Post not found");
        return;
    }

    send_json_response(200, post);
}

function handle_posts_create(body, auth_header) {
    let auth = authenticate_request(auth_header);
    if (!auth.authenticated) {
        send_error_response(401, auth.error);
        return;
    }

    let validation = validate_json_input(body, ["title", "content"]);
    if (!validation.valid) {
        send_error_response(400, validation.error);
        return;
    }

    let post_data = validation.data;

    let new_post = {
        id: data_store.next_post_id++,
        title: post_data.title,
        content: post_data.content,
        author_id: auth.user_id,
        created_at: time()
    };

    push(data_store.posts, new_post);
    send_json_response(201, new_post);
}

function handle_posts(method, path_parts, query_string, body, auth_header) {
    if (method == "GET") {
        if (length(path_parts) > 3) {
            // GET /api/v1/posts/:id
            let post_id = int(path_parts[3]);
            handle_posts_get(post_id);
        } else {
            // GET /api/v1/posts
            handle_posts_list();
        }
    } else if (method == "POST") {
        // POST /api/v1/posts
        handle_posts_create(body, auth_header);
    } else {
        send_error_response(405, "Method not allowed");
    }
}

function handle_health() {
    let server_start_time = time() - 3600; // Simulated start time
    let timestamp = time();

    let health_info = {
        status: "healthy",
        version: API_VERSION,
        timestamp: timestamp,
        uptime: timestamp - server_start_time,
        memory_usage: {
            // Simulated memory info
            used: (timestamp % 100),
            free: 100 - (timestamp % 100)
        },
        active_sessions: length(keys(data_store.sessions))
    };

    send_json_response(200, health_info);
}

// Request processing functions
function parse_http_request(request_line) {
    let parts = split(trim(request_line), " ");
    if (length(parts) < 3) {
        return null;
    }

    let method = parts[0];
    let full_path = parts[1];
    let version = parts[2];

    let url_parts = split(full_path, "?");
    let path = url_parts[0];
    let query_string = length(url_parts) > 1 ? url_parts[1] : null;

    return {
        method: method,
        path: path,
        query_string: query_string,
        version: version
    };
}

function parse_headers(header_lines) {
    let headers = {};

    for (line in header_lines) {
        let trimmed = trim(line);
        if (!trimmed) continue;

        let colon_pos = index(trimmed, ":");
        if (colon_pos > 0) {
            let key = lc(trim(substr(trimmed, 0, colon_pos)));
            let value = trim(substr(trimmed, colon_pos + 1));
            headers[key] = value;
        }
    }

    return headers;
}

// Main request router
function route_request(method, path, query_string, body, headers) {
    let path_parts = split(path, "/");

    // Remove empty parts
    let filtered_parts = [];
    for (part in path_parts) {
        if (part != "") {
            push(filtered_parts, part);
        }
    }

    path_parts = filtered_parts;

    // Handle CORS preflight
    if (method == "OPTIONS") {
        print("HTTP/1.1 200 OK\r\n");
        print("Access-Control-Allow-Origin: *\r\n");
        print("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS\r\n");
        print("Access-Control-Allow-Headers: Content-Type, Authorization\r\n");
        print("\r\n");
        return;
    }

    let auth_header = headers.authorization || null;

    // Route to appropriate handler
    if (length(path_parts) >= 3 && path_parts[0] == "api" && path_parts[1] == API_VERSION) {
        let endpoint = path_parts[2];

        if (endpoint == "login") {
            handle_login(method, body);
        } else if (endpoint == "users") {
            handle_users(method, path_parts, query_string, body, auth_header);
        } else if (endpoint == "posts") {
            handle_posts(method, path_parts, query_string, body, auth_header);
        } else if (endpoint == "health") {
            handle_health();
        } else {
            send_error_response(404, "Endpoint not found");
        }
    } else if (path == "/" || path == "") {
        // API documentation
        send_json_response(200, {
            message: "ucode Web API Server",
            version: API_VERSION,
            endpoints: {
                "POST /api/v1/login": "Authenticate and get token",
                "GET /api/v1/users": "List users",
                "POST /api/v1/users": "Create user",
                "GET /api/v1/users/:id": "Get user by ID",
                "PUT /api/v1/users/:id": "Update user",
                "DELETE /api/v1/users/:id": "Delete user",
                "GET /api/v1/posts": "List posts",
                "POST /api/v1/posts": "Create post",
                "GET /api/v1/posts/:id": "Get post by ID",
                "GET /api/v1/health": "Health check"
            }
        });
    } else {
        send_error_response(404, "Not found");
    }
}

// Data persistence functions
function save_data_store() {
    try {
        let json_data = sprintf("%J", data_store);
        writefile(DATA_FILE, json_data);
        return true;
    } catch (e) {
        return false;
    }
}

function load_data_store() {
    try {
        if (access(DATA_FILE)) {
            let json_data = readfile(DATA_FILE);
            let loaded_data = json(json_data);

            // Merge with defaults
            for (key in keys(loaded_data)) {
                data_store[key] = loaded_data[key];
            }
        }
    } catch (e) {
        // Use default data store
    }
}

// Simple HTTP server simulation
function simulate_http_request(method, path, headers, body) {
    print("=== Processing HTTP Request ===\n");
    print("Method: " + method + "\n");
    print("Path: " + path + "\n");
    print("Headers: " + sprintf("%J", headers) + "\n");
    if (body) {
        print("Body: " + body + "\n");
    }
    print("\n--- Response ---\n");

    let url_parts = split(path, "?");
    let clean_path = url_parts[0];
    let query_string = length(url_parts) > 1 ? url_parts[1] : null;

    route_request(method, clean_path, query_string, body, headers);
    print("\n");
}

function demo_api_usage() {
    print("ucode Web API Server Demo\n");
    print("========================\n\n");

    load_data_store();

    // Demo API documentation
    simulate_http_request("GET", "/", {}, null);

    // Demo login
    simulate_http_request("POST", "/api/v1/login",
                         { "content-type": "application/json" },
                         '{"username":"admin","password":"password123"}');

    // Demo user list
    simulate_http_request("GET", "/api/v1/users?limit=5",
                         { "authorization": "Bearer 12345678abcdefgh" }, null);

    // Demo user creation
    simulate_http_request("POST", "/api/v1/users",
                         {
                             "authorization": "Bearer 12345678abcdefgh",
                             "content-type": "application/json"
                         },
                         '{"name":"newuser","email":"new@example.com","role":"user"}');

    // Demo health check
    simulate_http_request("GET", "/api/v1/health", {}, null);

    // Demo posts list
    simulate_http_request("GET", "/api/v1/posts", {}, null);

    // Demo error case
    simulate_http_request("GET", "/api/v1/nonexistent", {}, null);

    save_data_store();
}

function print_help() {
    print("ucode Web API Server\n");
    print("===================\n\n");
    print("This is a demonstration of REST API patterns in ucode.\n");
    print("In a real implementation, this would integrate with an actual\n");
    print("HTTP server or web framework.\n\n");
    print("Usage: web-api.ucode [demo]\n\n");
    print("Commands:\n");
    print("  demo    Run API demonstration\n");
    print("  help    Show this help\n\n");
    print("API Endpoints:\n");
    print("  POST /api/v1/login         - User authentication\n");
    print("  GET  /api/v1/users         - List users\n");
    print("  POST /api/v1/users         - Create user\n");
    print("  GET  /api/v1/users/:id     - Get user by ID\n");
    print("  PUT  /api/v1/users/:id     - Update user\n");
    print("  DELETE /api/v1/users/:id   - Delete user\n");
    print("  GET  /api/v1/posts         - List posts\n");
    print("  POST /api/v1/posts         - Create post\n");
    print("  GET  /api/v1/posts/:id     - Get post by ID\n");
    print("  GET  /api/v1/health        - Health check\n\n");
}

// Main execution
function main() {
    let command = "demo";

    // Simple argument parsing
    if (length(ARGV) > 1) {
        command = ARGV[1];
    }

    if (command == "demo") {
        demo_api_usage();
    } else if (command == "help") {
        print_help();
    } else {
        print("Unknown command: " + command + "\n");
        print_help();
        return 1;
    }

    return 0;
}

// Execute main function
exit(main());
