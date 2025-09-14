#!/usr/bin/ucode

/*
 * Network Management Script for OpenWrt
 * Demonstrates UCI configuration handling, network operations, and system integration
 */

// Note: UCI and fs modules not available in basic ucode installation
// This example demonstrates the patterns for when modules are available

// Global configuration
const CONFIG_FILE = "/etc/config/network";
const DHCP_LEASES = "/tmp/dhcp.leases";
const PROC_NET_DEV = "/proc/net/dev";

// Network interface management
function get_network_interfaces() {
    // Simulated network interface statistics (in real OpenWrt would read /proc/net/dev)
    let interfaces = {
        "lo": {
            rx_bytes: 1024,
            rx_packets: 10,
            tx_bytes: 1024,
            tx_packets: 10
        },
        "eth0": {
            rx_bytes: 1048576,
            rx_packets: 1000,
            tx_bytes: 524288,
            tx_packets: 800
        },
        "wlan0": {
            rx_bytes: 2097152,
            rx_packets: 1500,
            tx_bytes: 1048576,
            tx_packets: 1200
        }
    };

    return interfaces;
}

// UCI configuration management (simulated for demo)
function load_network_config() {
    // Simulated network configuration (in real OpenWrt would use UCI)
    let config = {
        "loopback": {
            proto: "static",
            ipaddr: "127.0.0.1",
            netmask: "255.0.0.0",
            enabled: true
        },
        "lan": {
            proto: "static",
            ipaddr: "192.168.1.1",
            netmask: "255.255.255.0",
            enabled: true
        },
        "wan": {
            proto: "dhcp",
            enabled: true
        }
    };

    print("Loaded simulated network configuration\n");
    return config;
}

function save_interface_config(interface_name, settings) {
    // Simulated UCI save operation
    print("Would save interface " + interface_name + " with settings:\n");
    print(sprintf("%J\n", settings));

    // In real implementation, would use UCI cursor to save
    return true;
}

// DHCP lease management
function get_dhcp_leases() {
    // Simulated DHCP leases (in real OpenWrt would read from /tmp/dhcp.leases)
    let leases = [
        {
            expires: time() + 3600,
            mac: "aa:bb:cc:dd:ee:ff",
            ip: "192.168.1.100",
            hostname: "laptop",
            client_id: null
        },
        {
            expires: time() + 7200,
            mac: "11:22:33:44:55:66",
            ip: "192.168.1.101",
            hostname: "phone",
            client_id: null
        }
    ];

    return leases;
}

// Network diagnostics
function ping_host(host, count) {
    if (!count) count = 3;

    let cmd = "ping -c " + count + " -W 2 " + host;
    let result = {
        success: false,
        packets_sent: count,
        packets_received: 0,
        avg_rtt: 0,
        output: ""
    };

    // Simulate ping command (popen may not be available)
    if (host == "192.168.1.1" || host == "8.8.8.8") {
        result.success = true;
        result.packets_received = count;
        result.avg_rtt = 25;
        result.output = sprintf("PING %s: %d packets transmitted, %d received, avg %dms",
                              host, count, count, 25);
    } else if (host == "google.com") {
        result.success = true;
        result.packets_received = count;
        result.avg_rtt = 45;
        result.output = sprintf("PING %s: %d packets transmitted, %d received, avg %dms",
                              host, count, count, 45);
    } else {
        result.success = false;
        result.output = sprintf("PING %s: %d packets transmitted, 0 received", host, count);
    }

    return result;
}

function check_connectivity() {
    let targets = [
        { name: "Gateway", host: "192.168.1.1" },
        { name: "DNS", host: "8.8.8.8" },
        { name: "External", host: "google.com" }
    ];

    let results = {};

    for (target in targets) {
        print("Checking connectivity to " + target.name + " (" + target.host + ")...\n");
        results[target.name] = ping_host(target.host);

        if (results[target.name].success) {
            print("  ✓ " + target.name + ": " + results[target.name].packets_received +
                  "/" + results[target.name].packets_sent + " packets, avg " +
                  results[target.name].avg_rtt + "ms\n");
        } else {
            print("  ✗ " + target.name + ": No response\n");
        }
    }

    return results;
}

// System command execution
function execute_system_command(command) {
    // Simulate system command execution
    print("Would execute: " + command + "\n");

    if (index(command, "restart") >= 0) {
        return { success: true, output: "Service restarted", exit_code: 0 };
    } else if (index(command, "route") >= 0) {
        return {
            success: true,
            output: "Kernel IP routing table\nDestination     Gateway         Genmask         Flags Metric Ref    Use Iface\n0.0.0.0         192.168.1.1     0.0.0.0         UG    0      0        0 eth0\n192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 eth0\n",
            exit_code: 0
        };
    } else {
        return { success: false, output: "Command not found", exit_code: 127 };
    }
}

// Main network management functions
function restart_network() {
    print("Restarting network services...\n");

    let services = ["network", "dnsmasq", "firewall"];

    for (service in services) {
        print("  Restarting " + service + "...");

        let result = execute_system_command("/etc/init.d/" + service + " restart");
        if (result.success) {
            print(" ✓\n");
        } else {
            print(" ✗ (" + result.output + ")\n");
        }
    }
}

function format_bytes(bytes) {
    if (bytes < 1024) return bytes + " B";
    if (bytes < 1048576) return sprintf("%.1f KB", bytes / 1024);
    if (bytes < 1073741824) return sprintf("%.1f MB", bytes / 1048576);
    return sprintf("%.1f GB", bytes / 1073741824);
}

function show_interface_status() {
    let config = load_network_config();
    let interfaces = get_network_interfaces();

    print("\n=== Network Interface Status ===\n");
    printf("%-12s %-8s %-15s %-15s %s\n",
          "Interface", "Status", "IP Address", "Protocol", "RX/TX Bytes");
    print("----------------------------------------" +
          "----------------------------------------\n");

    for (name in keys(config)) {
        let iface = config[name];
        let stats = interfaces[name] || { rx_bytes: 0, tx_bytes: 0 };
        let status = iface.enabled ? "UP" : "DOWN";

        printf("%-12s %-8s %-15s %-15s %s/%s\n",
              name,
              status,
              iface.ipaddr || "N/A",
              iface.proto || "N/A",
              format_bytes(stats.rx_bytes),
              format_bytes(stats.tx_bytes));
    }
    print("\n");
}

function format_time(timestamp) {
    if (timestamp == 0) return "Never";

    let current = time();
    if (timestamp > current) {
        let diff = timestamp - current;
        if (diff < 3600) return sprintf("in %d minutes", int(diff / 60));
        if (diff < 86400) return sprintf("in %d hours", int(diff / 3600));
        return sprintf("in %d days", int(diff / 86400));
    }

    return "Expired";
}

function show_dhcp_clients() {
    let leases = get_dhcp_leases();

    print("=== DHCP Client Leases ===\n");
    if (length(leases) == 0) {
        print("No active DHCP leases found.\n\n");
        return;
    }

    printf("%-15s %-17s %-20s %s\n",
          "IP Address", "MAC Address", "Hostname", "Expires");
    print("--------------------------------------------------" +
          "--------------------\n");

    for (lease in leases) {
        let expires_str = format_time(lease.expires);
        let hostname = lease.hostname || "<unknown>";

        printf("%-15s %-17s %-20s %s\n",
              lease.ip,
              lease.mac,
              hostname,
              expires_str);
    }
    print("\n");
}

// Configuration management
function backup_config() {
    let timestamp = time();
    let backup_file = "/tmp/network_backup_" + timestamp + ".tar.gz";

    print("Simulating backup of network configuration...\n");
    print("Configuration would be backed up to: " + backup_file + "\n");
    return backup_file;
}

function show_routing_table() {
    print("=== Routing Table ===\n");

    let result = execute_system_command("route -n");
    if (result.success) {
        print(result.output);
    } else {
        print("Failed to get routing table: " + result.output + "\n");
    }
}

// Command line interface
function print_help() {
    print("\nUsage: network-management.uc [command]\n\n");
    print("Commands:\n");
    print("  status      Show network interface status\n");
    print("  clients     Show DHCP client leases\n");
    print("  ping        Test network connectivity\n");
    print("  restart     Restart network services\n");
    print("  config      Show network configuration\n");
    print("  routes      Show routing table\n");
    print("  backup      Backup network configuration\n");
    print("  help        Show this help message\n\n");
    print("Examples:\n");
    print("  network-management.uc status\n");
    print("  network-management.uc ping\n\n");
}

function main() {
    let command = "status";

    // Simple argument parsing - check if arguments exist
    // Note: ARGV may not be available in basic ucode installations

    switch (command) {
        case "status":
            show_interface_status();
            break;

        case "clients":
            show_dhcp_clients();
            break;

        case "ping":
            check_connectivity();
            break;

        case "restart":
            restart_network();
            break;

        case "config":
            let config = load_network_config();
            print("=== Network Configuration ===\n");
            print(sprintf("%J\n", config));
            break;

        case "routes":
            show_routing_table();
            break;

        case "backup":
            backup_config();
            break;

        case "help":
            print_help();
            break;

        default:
            print("Unknown command: " + command + "\n");
            print_help();
            return 1;
    }

    return 0;
}

// Execute main function
exit(main());
