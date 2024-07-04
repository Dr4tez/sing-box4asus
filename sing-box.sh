#!/bin/sh

# Script to run sing-box on Asus routers with Merlin firmware.

# Enter the IP addresses of devices whose traffic needs to be routed to the sing-box tun interface, separated by spaces.
DEVICE_IPS="192.168.50.31 192.168.50.32 192.168.50.33 192.168.50.38 192.168.50.42 192.168.50.43 192.168.50.45 192.168.50.47 192.168.50.48 192.168.50.49"

# If the specified routing table number is already in use on your router, assign your own number.
ROUTE_TABLE="222"

# Path to the sing-box executable.
SING_BOX_PATH="/tmp/mnt/entware/entware/root/sing-box/sing-box"

# Path to the sing-box config.
CONFIG_PATH="/tmp/mnt/entware/entware/root/sing-box/config.json"

# Name of your tun interface from the sing-box config.
TUN_INTERFACE="sbtun"

SERVICES_START_SCRIPT="/jffs/scripts/services-start"
SERVICES_START_LINES="sleep 30
$SING_BOX_PATH.sh start"

FIREWALL_SCRIPT="/jffs/scripts/firewall-start"
FIREWALL_RULES="FORWARD -i $TUN_INTERFACE -j ACCEPT
FORWARD -o $TUN_INTERFACE -j ACCEPT
INPUT -i $TUN_INTERFACE -j ACCEPT
OUTPUT -o $TUN_INTERFACE -j ACCEPT"

log_message() {
    echo "$1"
    logger -t "sing-box" "$1"
}

ensure_script_exists() {
    local script_path="$1"
    if [ ! -f "$script_path" ]; then
        echo "#!/bin/sh" > "$script_path"
        chmod 755 "$script_path"
    fi
}

update_script() {
    local script_path="$1"
    local content="$2"
    ensure_script_exists "$script_path"
    echo "$content" | while read -r line; do
        grep -qF "$line" "$script_path" || echo "$line" >> "$script_path"
    done
}

remove_from_script() {
    local script_path="$1"
    local content="$2"
    if [ -f "$script_path" ]; then
        echo "$content" | while read -r line; do
            sed -i "/$(echo "$line" | sed 's/[\/&]/\\&/g')/d" "$script_path"
        done
    fi
}

manage_iptables_rule() {
    local action="$1"
    local rule="$2"
    if [ "$action" = "add" ]; then
        if ! iptables -C $rule 2>/dev/null; then
            iptables -I $rule || echo "Error adding iptables rule: $rule"
        fi
    elif [ "$action" = "remove" ]; then
        if iptables -C $rule 2>/dev/null; then
            iptables -D $rule || echo "Error removing iptables rule: $rule"
        fi
    fi
}

is_sing_box_running() {
    ps | grep -v grep | grep -q "$SING_BOX_PATH"
}

extract_interface_name() {
    local config_file="$CONFIG_PATH"
    if [ -f "$config_file" ]; then
        local new_interface_name=$(grep '"interface_name":' "$config_file" | sed -n 's/.*"interface_name": "\(.*\)".*/\1/p')
        if [ -n "$new_interface_name" ]; then
            if [ "$new_interface_name" != "$TUN_INTERFACE" ]; then
                echo "Current TUN interface name: $TUN_INTERFACE"
                echo "New TUN interface name: $new_interface_name"
                while true; do
                    read -p "Change TUN interface name? (1-No 2-Yes): " change_interface
                    case "$change_interface" in
                        1)
                            echo "TUN interface name remains unchanged: $TUN_INTERFACE"
                            break  # Exit the loop since "No" was selected
                            ;;
                        2)
                            TUN_INTERFACE="$new_interface_name"
                            sed -i "s|^TUN_INTERFACE=\".*\"$|TUN_INTERFACE=\"$TUN_INTERFACE\"|" "$0"
                            log_message "TUN interface name updated to: $TUN_INTERFACE"
                            break  # Exit the loop after successfully changing the interface name
                            ;;
                        *)
                            echo "Invalid input: Enter 1 or 2."
                            ;;
                    esac
                done
            fi
        else
            log_message "Error: failed to extract TUN interface name from $config_file"
            exit 1
        fi
    else
        log_message "Error: file $config_file not found"
        exit 1
    fi
}

setup_sing_box() {
    # Determine the current script directory
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

    while true; do
        read -p "Change script settings? (1-No 2-Yes): " change_settings
        case "$change_settings" in
            1)
                echo "Script has finished execution."
                exit 0
                ;;
            2)
                echo "You chose to change settings."
                break  # Exit the loop since a valid value was entered
                ;;
            *)
                echo "Invalid input: Enter 1 or 2."
                ;;
        esac
    done

    echo "Current device IP addresses: $DEVICE_IPS"
    while true; do
        read -p "Change device IP addresses? (1-No 2-Yes): " change_ips
        case "$change_ips" in
            1)
                echo "You chose not to change device IP addresses."
                break  # Exit the loop since "No" was selected
                ;;
            2)
                read -p "Current device IP addresses will be deleted. Enter new device IP addresses separated by spaces: " new_ips
                DEVICE_IPS="$new_ips"
                sed -i "s|^DEVICE_IPS=\".*\"$|DEVICE_IPS=\"$DEVICE_IPS\"|" "$0"
                log_message "Device IP addresses successfully changed."
                break  # Exit the loop after successfully changing the IP addresses
                ;;
            *)
                echo "Invalid input: Enter 1 or 2."
                ;;
        esac
    done

    echo "Current routing table number: $ROUTE_TABLE"
    while true; do
        read -p "Change routing table number? (1-No 2-Yes): " change_route_table
        case "$change_route_table" in
            1)
                echo "Routing table number remains unchanged: $ROUTE_TABLE"
                break  # Exit the loop since "No" was selected
                ;;
            2)
                read -p "Enter new routing table number: " new_route_table
                ROUTE_TABLE="$new_route_table"
                sed -i "s|^ROUTE_TABLE=\".*\"$|ROUTE_TABLE=\"$ROUTE_TABLE\"|" "$0"
                log_message "Routing table number changed to $ROUTE_TABLE"
                break  # Exit the loop after successfully changing the routing table number
                ;;
            *)
                echo "Invalid input: Enter 1 or 2."
                ;;
        esac
    done

    # Show the current and new values of SING_BOX_PATH and CONFIG_PATH
    if [ "$SING_BOX_PATH" != "$SCRIPT_DIR/sing-box" ]; then
        echo "Current path to sing-box executable: $SING_BOX_PATH"
        echo "New path to sing-box executable: $SCRIPT_DIR/sing-box"
        while true; do
            read -p "Apply new path to sing-box executable? (1-No 2-Yes): " change_sing_box_path
            case "$change_sing_box_path" in
                1)
                    echo "Path to sing-box executable remains unchanged: $SING_BOX_PATH"
                    break  # Exit the loop since "No" was selected
                    ;;
                2)
                    SING_BOX_PATH="$SCRIPT_DIR/sing-box"
                    sed -i "s|^SING_BOX_PATH=\".*\"$|SING_BOX_PATH=\"$SING_BOX_PATH\"|" "$0"
                    log_message "Path to sing-box executable updated to: $SING_BOX_PATH"
                    break  # Exit the loop after successfully changing the path
                    ;;
                *)
                    echo "Invalid input: Enter 1 or 2."
                    ;;
            esac
        done
    fi

    if [ "$CONFIG_PATH" != "$SCRIPT_DIR/config.json" ]; then
        echo "Current path to sing-box config: $CONFIG_PATH"
        echo "New path to sing-box config: $SCRIPT_DIR/config.json"
        while true; do
            read -p "Apply new path to sing-box config? (1-No 2-Yes): " change_config_path
            case "$change_config_path" in
                1)
                    echo "Path to sing-box config remains unchanged: $CONFIG_PATH"
                    break  # Exit the loop since "No" was selected
                    ;;
                2)
                    CONFIG_PATH="$SCRIPT_DIR/config.json"
                    sed -i "s|^CONFIG_PATH=\".*\"$|CONFIG_PATH=\"$CONFIG_PATH\"|" "$0"
                    log_message "Path to sing-box config updated to: $CONFIG_PATH"
                    break  # Exit the loop after successfully changing the path
                    ;;
                *)
                    echo "Invalid input: Enter 1 or 2."
                    ;;
            esac
        done
    fi

    # Extract TUN interface name from config.json and offer to change it
    extract_interface_name

    echo "New settings applied."
}

start_sing_box() {
    log_message "Starting sing-box..."
    if is_sing_box_running; then
        log_message "Error: sing-box is already running"
        exit 1
    fi

    if ! lsmod | grep -q "^tun "; then
        log_message "Loading TUN module..." && modprobe tun
    else
        log_message "TUN module already loaded."
    fi

    nohup $SING_BOX_PATH run -c $CONFIG_PATH >/dev/null 2>&1 &
    sleep 3

    if ! ip link show $TUN_INTERFACE > /dev/null 2>&1; then
        log_message "Error: TUN interface $TUN_INTERFACE not found"
        exit 1
    fi

    log_message "Configuring routing table..."
    ip route add default dev $TUN_INTERFACE table $ROUTE_TABLE
    for IP in $DEVICE_IPS; do ip rule add from $IP table $ROUTE_TABLE; done

    log_message "Adding firewall rules..."
    echo "$FIREWALL_RULES" | while read -r rule; do
        manage_iptables_rule "add" "$rule"
    done

    log_message "Updating firewall-start script..."
    echo "$FIREWALL_RULES" | while read -r rule; do
        update_script "$FIREWALL_SCRIPT" "iptables -I $rule"
    done

    log_message "Updating services-start script..."
    update_script "$SERVICES_START_SCRIPT" "$SERVICES_START_LINES"
}

stop_sing_box() {
    log_message "Stopping sing-box..."
    while is_sing_box_running; do
        PID=$(ps | grep "$SING_BOX_PATH" | grep -v "grep" | awk '{print $1}')
        [ -z "$PID" ] && break
        kill $PID
    done

    log_message "Removing firewall rules..."
    echo "$FIREWALL_RULES" | while read -r rule; do
        manage_iptables_rule "remove" "$rule"
        remove_from_script "$FIREWALL_SCRIPT" "iptables -I $rule"
    done

    log_message "Removing routing rules..."
    for IP in $DEVICE_IPS; do ip rule del from $IP table $ROUTE_TABLE; done
    ip route del default dev $TUN_INTERFACE table $ROUTE_TABLE 2>/dev/null || true

    log_message "Updating services-start script..."
    remove_from_script "$SERVICES_START_SCRIPT" "$SERVICES_START_LINES"
}

# Main script execution logic
case "$1" in
    start) start_sing_box ;;
    stop) stop_sing_box ;;
    restart) stop_sing_box && start_sing_box ;;
    setup) setup_sing_box ;;
    *) echo "Usage: $0 {start|stop|restart|setup}" && exit 1 ;;
esac
