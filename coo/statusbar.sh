#!/bin/bash

# 获取 WiFi IP 地址
get_wifi_ip() {
    ip=$(ip route get 8.8.8.8 2>/dev/null | grep -Eo 'src [0-9.]+' | grep -Eo '[0-9.]+')
    if [ -n "$ip" ]; then
        echo "[ $ip ]"
    else
        echo "[ No WiFi ]"
    fi
}

# 检查是否存在指定的电池
has_battery() {
    battery_path="/sys/class/power_supply/$battery"
    [ -d "$battery_path" ]
}

# 获取电池状态
get_battery_status() {
    if has_battery && [ -e "/sys/class/power_supply/$battery/status" ]; then
        charge=$(get_charge)
        status=$(get_charging_status)
        if [ "$status" == "Charging" ]; then
            echo "$charge% ⚡"
        else
            echo "$charge%"
        fi
    fi
}

# 获取充电状态
get_charging_status() {
    cat "/sys/class/power_supply/$battery/status"
}

# 获取电池电量
get_charge() {
    cat "/sys/class/power_supply/$battery/capacity"
}

# 获取当前日期和时间
get_date() {
    date +"%a %d %b %Y | %I:%M:%S %p %Z"
}

# 主循环，每隔一分钟更新一次状态栏
update_status() {
    while true; do
        xsetroot -name "$(get_wifi_ip) $(get_date) | $(get_battery_status)"
        sleep 10
    done
}

# 主函数
main() {
    battery="BAT0"  # 电池名称
    update_status
}

# 运行主函数
main
