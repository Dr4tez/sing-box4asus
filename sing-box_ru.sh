#!/bin/sh

# Скрипт для запуска sing-box на роутерах Asus с прошивкой Мерлина.

# Впишите разделенные пробелами ip-адреса устройств, трафик которых надо направить в tun интерфейс sing-box.
DEVICE_IPS="192.168.50.31 192.168.50.32 192.168.50.33 192.168.50.38 192.168.50.42 192.168.50.43 192.168.50.45 192.168.50.47 192.168.50.48 192.168.50.49"

# Если указанный номер таблицы маршрутизации на вашем маршрутизаторе уже занят, назначьте свой собственный номер.
ROUTE_TABLE="222"

# Путь до исполняемого файла sing-box.
SING_BOX_PATH="/tmp/mnt/entware/entware/root/sing-box/sing-box"

# Путь до конфига sing-box.
CONFIG_PATH="/tmp/mnt/entware/entware/root/sing-box/config.json"

# Имя вашего tun интерфейса из конфига sing-box.
TUN_INTERFACE="sbtun"

SERVICES_START_SCRIPT="/jffs/scripts/services-start"
SERVICES_START_LINES="sleep 30
"$SING_BOX_PATH"_ru.sh start"

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
                echo "Текущее имя интерфейса TUN: $TUN_INTERFACE"
                echo "Новое имя интерфейса TUN: $new_interface_name"
                while true; do
                    read -p "Изменить имя интерфейса TUN? (1-Нет 2-Да): " change_interface
                    case "$change_interface" in
                        1)
                            echo "Имя интерфейса TUN осталось без изменений: $TUN_INTERFACE"
                            break  # Выход из цикла, т.к. выбран вариант "Нет"
                            ;;
                        2)
                            TUN_INTERFACE="$new_interface_name"
                            sed -i "s|^TUN_INTERFACE=\".*\"$|TUN_INTERFACE=\"$TUN_INTERFACE\"|" "$0"
                            log_message "Имя интерфейса TUN обновлено на: $TUN_INTERFACE"
                            break  # Выход из цикла после успешного изменения имени интерфейса
                            ;;
                        *)
                            echo "Некорректный ввод: Введите 1 или 2."
                            ;;
                    esac
                done
            fi
        else
            log_message "Ошибка: не удалось извлечь имя интерфейса TUN из $config_file"
            exit 1
        fi
    else
        log_message "Ошибка: файл $config_file не найден"
        exit 1
    fi
}

setup_sing_box() {
    # Определение текущей директории скрипта
    SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

    while true; do
        read -p "Изменить настройки скрипта? (1-Нет 2-Да): " change_settings
        case "$change_settings" in
            1)
                echo "Скрипт завершил работу."
                exit 0
                ;;
            2)
                echo "Вы выбрали изменить настройки."
                break  # Выход из цикла, т.к. введено корректное значение
                ;;
            *)
                echo "Некорректный ввод: Введите 1 или 2."
                ;;
        esac
    done

    echo "Текущие IP адреса устройств: $DEVICE_IPS"
    while true; do
        read -p "Изменить IP адреса устройств? (1-Нет 2-Да): " change_ips
        case "$change_ips" in
            1)
                echo "Вы выбрали не изменять IP адреса устройств."
                break  # Выход из цикла, т.к. выбран вариант "Нет"
                ;;
            2)
                read -p "Текущие IP адреса устройств будут удалены. Введите новые IP адреса устройств с пробелами между ними: " new_ips
                DEVICE_IPS="$new_ips"
                sed -i "s|^DEVICE_IPS=\".*\"$|DEVICE_IPS=\"$DEVICE_IPS\"|" "$0"
                log_message "IP адреса устройств успешно изменены."
                break  # Выход из цикла после успешного изменения IP адресов
                ;;
            *)
                echo "Некорректный ввод: Введите 1 или 2."
                ;;
        esac
    done

    echo "Текущий номер таблицы маршрутизации: $ROUTE_TABLE"
    while true; do
        read -p "Изменить номер таблицы маршрутизации? (1-Нет 2-Да): " change_route_table
        case "$change_route_table" in
            1)
                echo "Номер таблицы маршрутизации остался без изменений: $ROUTE_TABLE"
                break  # Выход из цикла, т.к. выбран вариант "Нет"
                ;;
            2)
                read -p "Введите новый номер таблицы маршрутизации: " new_route_table
                ROUTE_TABLE="$new_route_table"
                sed -i "s|^ROUTE_TABLE=\".*\"$|ROUTE_TABLE=\"$ROUTE_TABLE\"|" "$0"
                log_message "Номер таблицы маршрутизации изменен на $ROUTE_TABLE"
                break  # Выход из цикла после успешного изменения номера таблицы маршрутизации
                ;;
            *)
                echo "Некорректный ввод: Введите 1 или 2."
                ;;
        esac
    done

    # Показать текущие и новые значения SING_BOX_PATH и CONFIG_PATH
    if [ "$SING_BOX_PATH" != "$SCRIPT_DIR/sing-box" ]; then
        echo "Текущий путь до исполняемого файла sing-box: $SING_BOX_PATH"
        echo "Новый путь до исполняемого файла sing-box: $SCRIPT_DIR/sing-box"
        while true; do
            read -p "Применить новый путь до исполняемого файла sing-box? (1-Нет 2-Да): " change_sing_box_path
            case "$change_sing_box_path" in
                1)
                    echo "Путь до исполняемого файла sing-box остался без изменений: $SING_BOX_PATH"
                    break  # Выход из цикла, т.к. выбран вариант "Нет"
                    ;;
                2)
                    SING_BOX_PATH="$SCRIPT_DIR/sing-box"
                    sed -i "s|^SING_BOX_PATH=\".*\"$|SING_BOX_PATH=\"$SING_BOX_PATH\"|" "$0"
                    log_message "Путь до исполняемого файла sing-box обновлен на: $SING_BOX_PATH"
                    break  # Выход из цикла после успешного изменения пути
                    ;;
                *)
                    echo "Некорректный ввод: Введите 1 или 2."
                    ;;
            esac
        done
    fi

    if [ "$CONFIG_PATH" != "$SCRIPT_DIR/config.json" ]; then
        echo "Текущий путь до конфига sing-box: $CONFIG_PATH"
        echo "Новый путь до конфига sing-box: $SCRIPT_DIR/config.json"
        while true; do
            read -p "Применить новый путь до конфига sing-box? (1-Нет 2-Да): " change_config_path
            case "$change_config_path" in
                1)
                    echo "Путь до конфига sing-box остался без изменений: $CONFIG_PATH"
                    break  # Выход из цикла, т.к. выбран вариант "Нет"
                    ;;
                2)
                    CONFIG_PATH="$SCRIPT_DIR/config.json"
                    sed -i "s|^CONFIG_PATH=\".*\"$|CONFIG_PATH=\"$CONFIG_PATH\"|" "$0"
                    log_message "Путь до конфига sing-box обновлен на: $CONFIG_PATH"
                    break  # Выход из цикла после успешного изменения пути
                    ;;
                *)
                    echo "Некорректный ввод: Введите 1 или 2."
                    ;;
            esac
        done
    fi

    # Извлечь имя интерфейса TUN из config.json и предложить изменить его
    extract_interface_name

    echo "Новые настройки применены."
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

# Основная логика выполнения скрипта
case "$1" in
    start) start_sing_box ;;
    stop) stop_sing_box ;;
    restart) stop_sing_box && start_sing_box ;;
    setup) setup_sing_box ;;
    *) echo "Usage: $0 {start|stop|restart|setup}" && exit 1 ;;
esac