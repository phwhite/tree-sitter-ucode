#!/usr/bin/ucode

/*
 * System Monitor Script for OpenWrt
 * Demonstrates JSON handling, built-in functions, and system monitoring
 */

// Note: fs module not available in basic ucode installation
// This example demonstrates the patterns for when modules are available

// Utility function - defined first since it's used by other functions
function format_uptime(seconds) {
    let days = int(seconds / 86400);
    let hours = int((seconds % 86400) / 3600);
    let minutes = int((seconds % 3600) / 60);
    let secs = int(seconds % 60);

    if (days > 0) {
        return sprintf("%d days, %02d:%02d:%02d", days, hours, minutes, secs);
    } else {
        return sprintf("%02d:%02d:%02d", hours, minutes, secs);
    }
}

function format_bytes(bytes) {
    let units = ["B", "KB", "MB", "GB", "TB"];
    let unit_index = 0;
    let size = bytes;

    while (size >= 1024 && unit_index < length(units) - 1) {
        size = size / 1024;
        unit_index++;
    }

    if (unit_index == 0) {
        return sprintf("%d %s", int(size), units[unit_index]);
    } else {
        return sprintf("%.2f %s", size, units[unit_index]);
    }
}

// Built-in function usage and system monitoring
function get_system_metrics() {
    let metrics = {
        timestamp: time(),
        uptime: null,
        load_average: [],
        memory: {},
        disk_usage: {},
        cpu_info: {},
        network_stats: {}
    };

    // Simulated system uptime (in real OpenWrt would read /proc/uptime)
    let simulated_uptime = 86400; // 1 day
    metrics.uptime = {
        total_seconds: simulated_uptime,
        idle_seconds: simulated_uptime * 0.9,
        uptime_formatted: format_uptime(simulated_uptime)
    };

    // Simulated load average (in real OpenWrt would read /proc/loadavg)
    metrics.load_average = [
        0.25,  // 1-minute
        0.35,  // 5-minute
        0.40   // 15-minute
    ];

    // Simulated memory information (in real OpenWrt would read /proc/meminfo)
    let total_mem = 128 * 1024 * 1024; // 128MB
    let free_mem = 64 * 1024 * 1024;   // 64MB

    metrics.memory = {
        total: total_mem,
        free: free_mem,
        available: free_mem + 16 * 1024 * 1024, // 80MB available
        buffers: 8 * 1024 * 1024,    // 8MB
        cached: 16 * 1024 * 1024,    // 16MB
        used: total_mem - free_mem,
        usage_percent: ((total_mem - free_mem) * 100) / total_mem
    };

    // Simulated CPU information (in real OpenWrt would read /proc/cpuinfo)
    metrics.cpu_info = {
        model: "ARM Cortex-A53",
        frequency: 1200, // MHz
        core_count: 4
    };

    return metrics;
}

function get_disk_usage() {
    // Simulated disk usage (in real OpenWrt would use df command)
    let disk_usage = {
        "/": {
            filesystem: "/dev/root",
            size: "16G",
            used: "4.2G",
            available: "11G",
            usage_percent: "27"
        },
        "/tmp": {
            filesystem: "tmpfs",
            size: "64M",
            used: "12M",
            available: "52M",
            usage_percent: "19"
        },
        "/overlay": {
            filesystem: "/dev/ubi0_1",
            size: "256M",
            used: "45M",
            available: "211M",
            usage_percent: "18"
        }
    };

    return disk_usage;
}

function get_process_list() {
    // Simulated process list (in real OpenWrt would use ps command)
    let processes = [
        {
            user: "root",
            pid: 1,
            cpu_percent: 0,
            mem_percent: 1,
            vsz: 1234,
            rss: 567,
            tty: "?",
            stat: "Ss",
            start: "00:00",
            time: "00:00:01",
            command: "/sbin/procd"
        },
        {
            user: "root",
            pid: 123,
            cpu_percent: 2,
            mem_percent: 3,
            vsz: 5678,
            rss: 1234,
            tty: "?",
            stat: "S",
            start: "00:01",
            time: "00:00:05",
            command: "/usr/sbin/uhttpd"
        },
        {
            user: "nobody",
            pid: 456,
            cpu_percent: 1,
            mem_percent: 2,
            vsz: 2345,
            rss: 890,
            tty: "?",
            stat: "S",
            start: "00:02",
            time: "00:00:02",
            command: "/usr/sbin/dnsmasq"
        }
    ];

    return processes;
}

function generate_report(metrics, disk_usage, processes) {
    let hostname_data = "unknown";
    try {
        hostname_data = trim(readfile("/proc/sys/kernel/hostname"));
    } catch (e) {
        // Use default
    }

    let report = {
        generated_at: sprintf("%d", metrics.timestamp),
        hostname: hostname_data,
        system: {
            uptime: metrics.uptime,
            load_average: metrics.load_average,
            cpu: metrics.cpu_info
        },
        memory: metrics.memory,
        storage: disk_usage,
        top_processes: []
    };

    // Sort processes by CPU usage and take top 10
    let sorted_processes = sort(processes, function(a, b) {
        return b.cpu_percent - a.cpu_percent;
    });

    for (let i = 0; i < min(10, length(sorted_processes)); i++) {
        let proc = sorted_processes[i];
        push(report.top_processes, {
            pid: proc.pid,
            user: proc.user,
            cpu_percent: proc.cpu_percent,
            mem_percent: proc.mem_percent,
            command: proc.command
        });
    }

    return report;
}

function print_summary(metrics, disk_usage) {
    print("=== System Monitor Summary ===\n");
    print("Timestamp: " + sprintf("%d", metrics.timestamp) + "\n");

    if (metrics.uptime) {
        print("Uptime: " + metrics.uptime.uptime_formatted + "\n");
    } else {
        print("Uptime: Unknown\n");
    }
    print("\n");

    // CPU and Load
    print("--- CPU & Load ---\n");
    if (exists(metrics.cpu_info, "model")) {
        print("CPU: " + metrics.cpu_info.model + "\n");
    }
    if (exists(metrics.cpu_info, "core_count")) {
        print("Cores: " + metrics.cpu_info.core_count + "\n");
    }
    if (length(metrics.load_average) == 3) {
        print("Load Average: " + metrics.load_average[0] + ", " +
              metrics.load_average[1] + ", " + metrics.load_average[2] + "\n");
    }
    print("\n");

    // Memory
    print("--- Memory ---\n");
    if (exists(metrics.memory, "total")) {
        print("Total: " + format_bytes(metrics.memory.total) + "\n");
        print("Used: " + format_bytes(metrics.memory.used) +
              " (" + sprintf("%.1f", metrics.memory.usage_percent) + "%)\n");
        print("Free: " + format_bytes(metrics.memory.free) + "\n");
        if (exists(metrics.memory, "available")) {
            print("Available: " + format_bytes(metrics.memory.available) + "\n");
        }
    }
    print("\n");

    // Disk Usage
    print("--- Storage ---\n");
    for (mount in keys(disk_usage)) {
        let info = disk_usage[mount];
        print(mount + ": " + info.used + "/" + info.size +
              " (" + info.usage_percent + "% used)\n");
    }
    print("\n");
}

function save_json_report(report, filename) {
    try {
        let json_data = sprintf("%J", report);
        writefile(filename, json_data);
        print("Report saved to " + filename + "\n");
        return true;
    } catch (e) {
        print("Error saving report: " + e + "\n");
        return false;
    }
}

function load_previous_report(filename) {
    try {
        // Simulate file access check (access function may not be available)
        print("Would load previous report from: " + filename + "\n");
        return null; // No previous report for simulation
        return json(json_data);
    } catch (e) {
        return null;
    }
}

function compare_metrics(current, previous) {
    if (!previous) {
        print("No previous report found for comparison.\n");
        return;
    }

    print("=== Comparison with Previous Report ===\n");

    let time_diff = current.system.uptime.total_seconds - previous.system.uptime.total_seconds;
    print("Time since last report: " + format_uptime(time_diff) + "\n");

    // Memory comparison
    if (exists(current.memory, "usage_percent") && exists(previous.memory, "usage_percent")) {
        let mem_diff = current.memory.usage_percent - previous.memory.usage_percent;
        print("Memory usage change: " + sprintf("%+.1f", mem_diff) + "%\n");
    }

    // Load average comparison
    if (length(current.system.load_average) >= 1 && length(previous.system.load_average) >= 1) {
        let load_diff = current.system.load_average[0] - previous.system.load_average[0];
        print("Load average change (1m): " + sprintf("%+.2f", load_diff) + "\n");
    }

    print("\n");
}

function get_network_stats() {
    // Simulated network statistics (in real OpenWrt would read /proc/net/dev)
    let stats = {
        "lo": {
            rx_bytes: 1024,
            rx_packets: 10,
            tx_bytes: 1024,
            tx_packets: 10
        },
        "eth0": {
            rx_bytes: 10485760, // 10MB
            rx_packets: 8192,
            tx_bytes: 5242880,  // 5MB
            tx_packets: 4096
        },
        "wlan0": {
            rx_bytes: 20971520, // 20MB
            rx_packets: 16384,
            tx_bytes: 15728640, // 15MB
            tx_packets: 12288
        }
    };

    return stats;
}

function show_network_summary() {
    let stats = get_network_stats();

    print("=== Network Interface Summary ===\n");
    printf("%-12s %15s %15s %10s %10s\n",
           "Interface", "RX Bytes", "TX Bytes", "RX Pkts", "TX Pkts");
    print("--------------------------------------------------------------\n");

    for (iface in keys(stats)) {
        let info = stats[iface];
        printf("%-12s %15s %15s %10d %10d\n",
               iface,
               format_bytes(info.rx_bytes),
               format_bytes(info.tx_bytes),
               info.rx_packets,
               info.tx_packets);
    }
    print("\n");
}

function main() {
    let command = "summary";

    // Simple argument parsing - check if arguments exist
    // Note: ARGV may not be available in basic ucode installations

    let report_file = "/tmp/system_monitor_report.json";

    switch (command) {
        case "summary":
            print("Collecting system metrics...\n");
            let metrics = get_system_metrics();
            let disk_usage = get_disk_usage();
            print_summary(metrics, disk_usage);
            break;

        case "report":
            print("Generating detailed report...\n");
            let metrics = get_system_metrics();
            let disk_usage = get_disk_usage();
            let processes = get_process_list();
            let report = generate_report(metrics, disk_usage, processes);

            // Load previous report for comparison
            let previous = load_previous_report(report_file);
            compare_metrics(report, previous);

            // Save current report
            save_json_report(report, report_file);
            break;

        case "json":
            let metrics = get_system_metrics();
            let disk_usage = get_disk_usage();
            let processes = get_process_list();
            let report = generate_report(metrics, disk_usage, processes);
            print(sprintf("%J\n", report));
            break;

        case "processes":
            let processes = get_process_list();
            print("=== Top Processes by CPU Usage ===\n");
            printf("%-8s %-10s %6s %6s %s\n", "PID", "USER", "CPU%", "MEM%", "COMMAND");
            print("------------------------------------------------------------\n");

            let sorted = sort(processes, function(a, b) {
                return b.cpu_percent - a.cpu_percent;
            });

            for (let i = 0; i < min(15, length(sorted)); i++) {
                let proc = sorted[i];
                printf("%-8d %-10s %6d %6d %s\n",
                      proc.pid, proc.user, proc.cpu_percent, proc.mem_percent, proc.command);
            }
            break;

        case "network":
            show_network_summary();
            break;

        case "help":
            print("\nUsage: system-monitor.uc [command]\n\n");
            print("Commands:\n");
            print("  summary     Show system summary (default)\n");
            print("  report      Generate detailed report with comparison\n");
            print("  json        Output report in JSON format\n");
            print("  processes   Show top processes by CPU usage\n");
            print("  network     Show network interface statistics\n");
            print("  help        Show this help message\n\n");
            print("Examples:\n");
            print("  system-monitor.uc\n");
            print("  system-monitor.uc report\n");
            print("  system-monitor.uc json\n\n");
            break;

        default:
            print("Unknown command: " + command + "\n");
            print("Use 'help' command for usage information.\n");
            return 1;
    }

    return 0;
}

// Execute main function
exit(main());
