#!/usr/bin/ucode

/*
 * Basic ucode syntax examples
 * Demonstrates variables, functions, control flow, and OpenWrt patterns
 */

// Variable declarations
let name = "OpenWrt System";
const version = "23.05";
let config = {};

// Function declarations
function log_message(level, message) {
    let timestamp = time();
    print("[" + timestamp + "] " + level + ": " + message + "\n");
}

function get_system_info() {
    let info = {
        hostname: "openwrt-router",
        uptime: 86400,
        load_avg: [0.1, 0.2, 0.15],
        memory: {
            total: 128 * 1024 * 1024,
            free: 64 * 1024 * 1024,
            used: 64 * 1024 * 1024
        }
    };

    return info;
}

// Control flow examples
function check_system_status() {
    let info = get_system_info();

    if (info.memory.free < info.memory.total * 0.1) {
        log_message("WARN", "Low memory detected");
    } else if (info.memory.free < info.memory.total * 0.3) {
        log_message("INFO", "Memory usage is moderate");
    } else {
        log_message("INFO", "System memory is healthy");
    }

    // Loop through load averages
    for (let i = 0; i < length(info.load_avg); i++) {
        if (info.load_avg[i] > 1.0) {
            log_message("WARN", "High load average: " + info.load_avg[i]);
        }
    }
}

// Object and array manipulation
function process_interfaces() {
    let interfaces = [
        { name: "eth0", status: "up", ip: "192.168.1.1" },
        { name: "wlan0", status: "up", ip: "10.0.0.1" },
        { name: "br-lan", status: "up", ip: "192.168.1.1" }
    ];

    let active_interfaces = [];

    for (iface in interfaces) {
        if (iface.status == "up") {
            push(active_interfaces, iface.name);
        }
    }

    return active_interfaces;
}

// String concatenation and formatting
function generate_config(hostname, domain) {
    let config_template = "config system\n" +
                         "    option hostname '" + hostname + "'\n" +
                         "    option domain '" + domain + "'\n" +
                         "    option timezone 'UTC'\n\n" +
                         "config network\n" +
                         "    option ipaddr '192.168.1.1'\n" +
                         "    option netmask '255.255.255.0'\n";

    return config_template;
}

// Error handling with try/catch (no finally in ucode)
function safe_file_operation(filename) {
    try {
        let content = readfile(filename);
        log_message("INFO", "Successfully read " + filename);
        return content;
    } catch (error) {
        log_message("ERROR", "Failed to read " + filename + ": " + error);
        return null;
    }

    log_message("DEBUG", "File operation completed");
}

// Switch statement
function handle_signal(signal) {
    switch (signal) {
        case "SIGHUP":
            log_message("INFO", "Reloading configuration");
            break;
        case "SIGTERM":
        case "SIGINT":
            log_message("INFO", "Shutting down gracefully");
            break;
        case "SIGUSR1":
            log_message("INFO", "Toggling debug mode");
            break;
        default:
            log_message("WARN", "Unknown signal: " + signal);
    }
}

// For-in loop for objects and arrays
function print_system_info() {
    let info = get_system_info();

    for (key in info) {
        if (type(info[key]) == "object") {
            print(key + ":\n");
            for (subkey in info[key]) {
                print("  " + subkey + ": " + info[key][subkey] + "\n");
            }
        } else if (type(info[key]) == "array") {
            print(key + ": [" + join(", ", info[key]) + "]\n");
        } else {
            print(key + ": " + info[key] + "\n");
        }
    }
}

// String manipulation functions
function process_log_line(line) {
    // Trim whitespace
    line = trim(line);

    // Check if line contains error
    if (index(line, "ERROR") >= 0) {
        return "CRITICAL: " + line;
    }

    // Extract timestamp (assuming format: [timestamp] message)
    if (substr(line, 0, 1) == "[") {
        let closing_bracket = index(line, "]");
        if (closing_bracket > 0) {
            let timestamp = substr(line, 1, closing_bracket - 1);
            let message = substr(line, closing_bracket + 2);
            return "Parsed - Time: " + timestamp + ", Message: " + message;
        }
    }

    return "UNPARSED: " + line;
}

// Array operations
function analyze_numbers(numbers) {
    if (!length(numbers)) {
        return { error: "Empty array" };
    }

    // Sort array (modifies original)
    sort(numbers, function(a, b) { return a - b; });

    let total = 0;
    for (num in numbers) {
        total += num;
    }

    return {
        count: length(numbers),
        min: numbers[0],
        max: numbers[-1],
        average: total / length(numbers),
        median: numbers[int(length(numbers) / 2)]
    };
}

// Object manipulation
function merge_configs(base_config, override_config) {
    let merged = {};

    // Copy base configuration
    for (key, value in base_config) {
        merged[key] = value;
    }

    // Override with new values
    for (key, value in override_config) {
        merged[key] = value;
    }

    return merged;
}

// Regular expression usage
function validate_ip_address(ip) {
    // Check basic format with split and validation
    let octets = split(ip, ".");

    if (length(octets) != 4) {
        return false;
    }

    for (octet in octets) {
        let num = int(octet);
        if (num < 0 || num > 255 || octet != sprintf("%d", num)) {
            return false;
        }
    }

    return true;
}

// JSON handling
function save_system_state(filename) {
    let state = {
        timestamp: time(),
        system_info: get_system_info(),
        active_interfaces: process_interfaces(),
        uptime_formatted: sprintf("%.2f hours", time() / 3600)
    };

    try {
        let json_data = sprintf("%J", state);
        // In real ucode, would use fs module or built-in file functions
        // For now, just print the JSON data
        print("System state JSON:\n" + json_data + "\n");
        return true;
    } catch (error) {
        log_message("ERROR", "Failed to save state: " + error);
        return false;
    }
}

// Main execution function
function main() {
    log_message("INFO", "Starting ucode script");

    // Demonstrate various features
    check_system_status();

    let active_ifaces = process_interfaces();
    log_message("INFO", "Active interfaces: " + join(", ", active_ifaces));

    let config = generate_config("router", "local");
    log_message("DEBUG", "Generated configuration template");

    handle_signal("SIGHUP");

    print_system_info();

    // Test string processing
    let sample_logs = [
        "[1234567890] System started",
        "[1234567891] ERROR: Connection failed",
        "Unparsed log entry",
        "[1234567892] INFO: All systems operational"
    ];

    print("\n--- Log Processing ---\n");
    for (log_line in sample_logs) {
        print(process_log_line(log_line) + "\n");
    }

    // Test number analysis
    let test_numbers = [5, 2, 8, 1, 9, 3];
    let analysis = analyze_numbers(test_numbers);
    print("\n--- Number Analysis ---\n");
    print("Numbers: " + join(", ", test_numbers) + "\n");
    print("Count: " + analysis.count + "\n");
    print("Min: " + analysis.min + ", Max: " + analysis.max + "\n");
    print("Average: " + sprintf("%.2f", analysis.average) + "\n");

    // Test IP validation
    let test_ips = ["192.168.1.1", "256.1.1.1", "10.0.0.1", "invalid"];
    print("\n--- IP Validation ---\n");
    for (ip in test_ips) {
        let valid = validate_ip_address(ip) ? "VALID" : "INVALID";
        print(ip + ": " + valid + "\n");
    }

    // Save system state
    let state_file = "/tmp/system_state.json";
    if (save_system_state(state_file)) {
        log_message("INFO", "System state saved to " + state_file);
    }

    log_message("INFO", "Script execution completed");
}

// Execute main function
main();
