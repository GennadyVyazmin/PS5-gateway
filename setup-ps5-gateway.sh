#!/usr/bin/env bash
set -euo pipefail
APP_DIR="/etc/ps5-gateway"
SETTINGS_FILE="$APP_DIR/settings.env"
SUB_FILE="$APP_DIR/subscription.txt"
SINGBOX_DIR="/etc/sing-box"
SINGBOX_CONFIG="$SINGBOX_DIR/config.json"
SINGBOX_BACKUP_DIR="/etc/sing-box-backups"
ROUTE_SCRIPT="/usr/local/sbin/ps5-gateway-route.sh"
ROUTE_SERVICE="/etc/systemd/system/ps5-gateway-route.service"
TABLE_ID="200"
RULE_PRIORITY="100"
TUN_IFACE="sb-tun0"
MIXED_PORT="2080"
CLASH_PORT="9090"
UI_DIR="/etc/sing-box/ui"
need_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "Запусти от root: sudo bash $0"
    exit 1
  fi
}
pause() {
  echo
  read -r -p "Нажми Enter для продолжения..."
}
detect_network() {
  DEFAULT_LINE="$(ip -4 route show default | head -n1 || true)"
  if [ -z "$DEFAULT_LINE" ]; then
    echo "Не нашёл default route. Проверь сеть VM."
    exit 1
  fi
  LAN_IFACE="$(echo "$DEFAULT_LINE" | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1)}')"
  LAN_GATEWAY="$(echo "$DEFAULT_LINE" | awk '{for(i=1;i<=NF;i++) if($i=="via") print $(i+1)}')"
  VM_IP="$(ip -4 addr show dev "$LAN_IFACE" | awk '/inet / {print $2}' | head -n1 | cut -d/ -f1)"
  LAN_CIDR="$(ip -4 route show dev "$LAN_IFACE" scope link | awk '{print $1}' | head -n1)"
  if [ -z "${LAN_IFACE:-}" ] || [ -z "${LAN_GATEWAY:-}" ] || [ -z "${VM_IP:-}" ] || [ -z "${LAN_CIDR:-}" ]; then
    echo "Не смог автоматически определить сеть."
    echo "LAN_IFACE=$LAN_IFACE"
    echo "LAN_GATEWAY=$LAN_GATEWAY"
    echo "VM_IP=$VM_IP"
    echo "LAN_CIDR=$LAN_CIDR"
    exit 1
  fi
}
confirm_network() {
  detect_network
  echo
  echo "Найдено:"
  echo "  Интерфейс VM: $LAN_IFACE"
  echo "  IP VM:        $VM_IP"
  echo "  Роутер:       $LAN_GATEWAY"
  echo "  LAN:          $LAN_CIDR"
  echo
  read -r -p "Это верно? [Y/n]: " ok
  ok="${ok:-Y}"
  if [[ ! "$ok" =~ ^[YyДд]$ ]]; then
    read -r -p "Интерфейс VM: " LAN_IFACE
    read -r -p "IP VM: " VM_IP
    read -r -p "IP роутера: " LAN_GATEWAY
    read -r -p "LAN CIDR, например 192.168.88.0/24: " LAN_CIDR
  fi
}
install_deps() {
  apt update
  apt install -y curl wget ca-certificates gpg iproute2 nftables python3 git unzip
}
install_singbox() {
  if command -v sing-box >/dev/null 2>&1; then
    echo "sing-box уже установлен: $(sing-box version | head -n1)"
    return
  fi
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://sing-box.sagernet.org/gpg-key.txt | gpg --dearmor -o /etc/apt/keyrings/sagernet.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/sagernet.gpg] https://deb.sagernet.org/ * *" > /etc/apt/sources.list.d/sagernet.list
  apt update
  apt install -y sing-box
  systemctl enable sing-box
}
install_ui() {
  mkdir -p "$SINGBOX_DIR"
  rm -rf "$UI_DIR"
  if git clone https://github.com/MetaCubeX/metacubexd.git -b gh-pages "$UI_DIR"; then
    echo "MetaCubeXD UI установлен в $UI_DIR"
  else
    echo "Не удалось скачать MetaCubeXD через git. UI можно поставить позже."
    mkdir -p "$UI_DIR"
  fi
}
ask_client() {
  echo
  echo "Кого гнать через VPN?"
  echo "1) Только одно устройство, например PS5"
  echo "2) Всю LAN-подсеть, но реально пойдут только те устройства, у которых gateway = IP этой VM"
  read -r -p "Выбор [1/2, по умолчанию 1]: " route_mode
  route_mode="${route_mode:-1}"
  if [ "$route_mode" = "2" ]; then
    ROUTE_SOURCE="$LAN_CIDR"
  else
    read -r -p "IP PS5/клиента, например 192.168.88.10: " CLIENT_IP
    if [ -z "$CLIENT_IP" ]; then
      echo "IP клиента пустой."
      exit 1
    fi
    ROUTE_SOURCE="$CLIENT_IP"
  fi
}
save_settings() {
  mkdir -p "$APP_DIR"
  cat > "$SETTINGS_FILE" <<EOF
LAN_IFACE="$LAN_IFACE"
LAN_GATEWAY="$LAN_GATEWAY"
VM_IP="$VM_IP"
LAN_CIDR="$LAN_CIDR"
ROUTE_SOURCE="$ROUTE_SOURCE"
TABLE_ID="$TABLE_ID"
RULE_PRIORITY="$RULE_PRIORITY"
TUN_IFACE="$TUN_IFACE"
EOF
}
load_settings() {
  if [ ! -f "$SETTINGS_FILE" ]; then
    echo "Настройки не найдены. Сначала выбери пункт установки."
    exit 1
  fi
  # shellcheck disable=SC1090
  source "$SETTINGS_FILE"
}
read_subscription_input() {
  echo
  echo "Вставь:"
  echo "  - одну vless:// ссылку"
  echo "  - несколько vless:// ссылок через пробел или с новой строки"
  echo "  - http/https ссылку на подписку с VLESS"
  echo
  echo "Когда закончишь вставку, нажми Enter на пустой строке."
  echo
  local input=""
  local line=""
  while IFS= read -r line; do
    [ -z "$line" ] && break
    input+="$line"$'\n'
  done
  if [ -z "$input" ]; then
    echo "Пустой ввод."
    exit 1
  fi
  mkdir -p "$APP_DIR"
  printf "%s" "$input" > "$SUB_FILE"
}
generate_singbox_config() {
  load_settings
  mkdir -p "$SINGBOX_DIR" "$SINGBOX_BACKUP_DIR"
  find "$SINGBOX_DIR" -maxdepth 1 -type f ! -name "config.json" -exec mv {} "$SINGBOX_BACKUP_DIR"/ \; 2>/dev/null || true
  python3 - "$SUB_FILE" "$SINGBOX_CONFIG" "$UI_DIR" <<'PY'
import base64
import ipaddress
import json
import os
import re
import sys
import urllib.parse
import urllib.request
sub_file, out_file, ui_dir = sys.argv[1], sys.argv[2], sys.argv[3]
raw = open(sub_file, "r", encoding="utf-8", errors="ignore").read().strip()
def fetch_if_url(s):
    s = s.strip()
    if s.startswith("http://") or s.startswith("https://"):
        with urllib.request.urlopen(s, timeout=25) as r:
            return r.read().decode("utf-8", errors="ignore")
    return s
def maybe_b64_decode(s):
    if "vless://" in s:
        return s
    compact = re.sub(r"\s+", "", s)
    if not compact:
        return s
    try:
        pad = "=" * (-len(compact) % 4)
        decoded = base64.urlsafe_b64decode((compact + pad).encode()).decode("utf-8", errors="ignore")
        if "vless://" in decoded:
            return decoded
    except Exception:
        pass
    try:
        pad = "=" * (-len(compact) % 4)
        decoded = base64.b64decode((compact + pad).encode()).decode("utf-8", errors="ignore")
        if "vless://" in decoded:
            return decoded
    except Exception:
        pass
    return s
content = maybe_b64_decode(fetch_if_url(raw))
links = re.findall(r"vless://[^\s\"'<>]+", content)
if not links and content.startswith("vless://"):
    links = [content]
if not links:
    print("Не нашёл vless:// ссылок в вводе/подписке.", file=sys.stderr)
    sys.exit(1)
def first(q, *names, default=""):
    for name in names:
        if name in q and q[name]:
            return q[name][0]
    return default
def sanitize_tag(name, fallback):
    name = urllib.parse.unquote(name or "")
    if not name:
        name = fallback
    name = name.lower()
    name = re.sub(r"[^a-z0-9._-]+", "-", name)
    name = re.sub(r"-+", "-", name).strip("-")
    return name or fallback
outbounds = [
    {"type": "direct", "tag": "direct"},
    {"type": "block", "tag": "block"},
]
vps_ips = []
tags = []
used_tags = set(["direct", "block", "auto", "select"])
for idx, link in enumerate(links, start=1):
    u = urllib.parse.urlsplit(link)
    q = urllib.parse.parse_qs(u.query)
    server = u.hostname
    port = u.port
    uuid = urllib.parse.unquote(u.username or "")
    fragment = urllib.parse.unquote(u.fragment or "")
    if not server or not port or not uuid:
        print(f"Пропускаю ссылку #{idx}: не хватает server/port/uuid", file=sys.stderr)
        continue
    base_tag = sanitize_tag(fragment, f"proxy-{idx}")
    tag = base_tag
    n = 2
    while tag in used_tags:
        tag = f"{base_tag}-{n}"
        n += 1
    used_tags.add(tag)
    tags.append(tag)
    sni = first(q, "sni", "serverName", "servername", default="www.nvidia.com")
    pbk = first(q, "pbk", "public_key", "publicKey", "pubkey")
    sid = first(q, "sid", "short_id", "shortId")
    fp = first(q, "fp", "fingerprint", default="chrome")
    if not pbk:
        print(f"Пропускаю {tag}: нет pbk/public_key", file=sys.stderr)
        continue
    try:
        ipaddress.ip_address(server)
        vps_ips.append(f"{server}/32")
    except Exception:
        pass
    outbound = {
        "type": "vless",
        "tag": tag,
        "server": server,
        "server_port": port,
        "uuid": uuid,
        "packet_encoding": "xudp",
        "tls": {
            "enabled": True,
            "server_name": sni,
            "reality": {
                "enabled": True,
                "public_key": pbk,
                "short_id": sid
            },
            "utls": {
                "enabled": True,
                "fingerprint": fp
            }
        }
    }
    outbounds.append(outbound)
if not tags:
    print("Нет валидных VLESS outbound.", file=sys.stderr)
    sys.exit(1)
selector_default = "auto" if len(tags) > 1 else tags[0]
if len(tags) > 1:
    outbounds.insert(2, {
        "type": "urltest",
        "tag": "auto",
        "outbounds": tags,
        "url": "https://google.com/generate_204",
        "interval": "3m",
        "tolerance": 50,
        "idle_timeout": "30m",
        "interrupt_exist_connections": False
    })
    outbounds.insert(3, {
        "type": "selector",
        "tag": "select",
        "outbounds": ["auto"] + tags,
        "default": "auto",
        "interrupt_exist_connections": False
    })
else:
    outbounds.insert(2, {
        "type": "selector",
        "tag": "select",
        "outbounds": tags,
        "default": tags[0],
        "interrupt_exist_connections": False
    })
rules = [
    {"ip_version": 6, "outbound": "block"},
    {"ip_is_private": True, "outbound": "direct"},
]
if vps_ips:
    rules.append({"ip_cidr": sorted(set(vps_ips)), "outbound": "direct"})
config = {
    "log": {
        "level": "info",
        "timestamp": True
    },
    "dns": {
        "servers": [
            {"type": "udp", "tag": "cloudflare", "server": "1.1.1.1"},
            {"type": "udp", "tag": "google", "server": "8.8.8.8"}
        ],
        "final": "cloudflare"
    },
    "inbounds": [
        {
            "type": "tun",
            "tag": "tun-in",
            "interface_name": "sb-tun0",
            "address": ["172.19.0.1/30"],
            "auto_route": False,
            "strict_route": False,
            "stack": "system"
        },
        {
            "type": "mixed",
            "tag": "mixed-in",
            "listen": "127.0.0.1",
            "listen_port": 2080
        }
    ],
    "outbounds": outbounds,
    "route": {
        "default_domain_resolver": "cloudflare",
        "auto_detect_interface": True,
        "rules": rules,
        "final": "select"
    },
    "experimental": {
        "cache_file": {"enabled": True},
        "clash_api": {
            "external_controller": "0.0.0.0:9090",
            "external_ui": ui_dir,
            "external_ui_download_detour": "direct",
            "access_control_allow_private_network": True,
            "secret": ""
        }
    }
}
os.makedirs(os.path.dirname(out_file), exist_ok=True)
with open(out_file, "w", encoding="utf-8") as f:
    json.dump(config, f, indent=2, ensure_ascii=False)
print("Создан sing-box config:", out_file)
print("Найдено outbound:", ", ".join(tags))
print("Исключения VPS:", ", ".join(sorted(set(vps_ips))) if vps_ips else "нет IP-исключений")
PY
}
write_route_script() {
  load_settings
  cat > "$ROUTE_SCRIPT" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
SETTINGS_FILE="/etc/ps5-gateway/settings.env"
# shellcheck disable=SC1090
source "$SETTINGS_FILE"
sysctl -w net.ipv4.ip_forward=1 >/dev/null
ip route replace "$LAN_CIDR" dev "$LAN_IFACE" table "$TABLE_ID"
if [ -f /etc/sing-box/config.json ]; then
  python3 - "$LAN_GATEWAY" "$LAN_IFACE" "$TABLE_ID" <<'PY'
import json
import sys
gw, iface, table = sys.argv[1], sys.argv[2], sys.argv[3]
cfg = json.load(open("/etc/sing-box/config.json"))
ips = set()
for rule in cfg.get("route", {}).get("rules", []):
    for item in rule.get("ip_cidr", []) or []:
        if item.endswith("/32"):
            ips.add(item[:-3])
for ip in sorted(ips):
    print(f"ip route replace {ip}/32 via {gw} dev {iface} table {table}")
PY
fi | while read -r cmd; do
  [ -n "$cmd" ] && sh -c "$cmd"
done
ip route replace default dev "$TUN_IFACE" table "$TABLE_ID"
while ip rule del from "$ROUTE_SOURCE" table "$TABLE_ID" priority "$RULE_PRIORITY" 2>/dev/null; do :; done
ip rule add from "$ROUTE_SOURCE" table "$TABLE_ID" priority "$RULE_PRIORITY"
nft add table ip ps5gw_nat 2>/dev/null || true
nft 'add chain ip ps5gw_nat postrouting { type nat hook postrouting priority 100; policy accept; }' 2>/dev/null || true
nft flush chain ip ps5gw_nat postrouting
nft add rule ip ps5gw_nat postrouting oifname "$LAN_IFACE" ip saddr "$LAN_CIDR" masquerade
EOF
  chmod +x "$ROUTE_SCRIPT"
  cat > "$ROUTE_SERVICE" <<EOF
[Unit]
Description=PS5 Gateway policy routing
After=network-online.target sing-box.service
Wants=network-online.target
Requires=sing-box.service
[Service]
Type=oneshot
ExecStart=$ROUTE_SCRIPT
RemainAfterExit=yes
[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable ps5-gateway-route.service
}
apply_all() {
  sing-box check -c "$SINGBOX_CONFIG"
  systemctl restart sing-box
  sleep 1
  systemctl restart ps5-gateway-route.service
}
show_result() {
  load_settings
  echo
  echo "Готово."
  echo
  echo "Проверь mixed-прокси:"
  echo "  curl -4 --max-time 20 -x socks5h://127.0.0.1:$MIXED_PORT ifconfig.me && echo"
  echo
  echo "Clash UI:"
  echo "  http://$VM_IP:$CLASH_PORT/ui"
  echo
  echo "Настройки PS5/клиента:"
  echo "  Gateway: $VM_IP"
  echo "  DNS:     1.1.1.1 или 8.8.8.8"
  echo
  echo "Текущие проверки:"
  ip rule show || true
  echo
  ip route show table "$TABLE_ID" || true
}
install_flow() {
  confirm_network
  ask_client
  save_settings
  install_deps
  install_singbox
  install_ui
  read_subscription_input
  generate_singbox_config
  write_route_script
  apply_all
  show_result
}
change_config_flow() {
  load_settings
  read_subscription_input
  generate_singbox_config
  apply_all
  show_result
}
uninstall_flow() {
  echo "Удаляю настройки PS5 gateway..."
  systemctl disable --now ps5-gateway-route.service 2>/dev/null || true
  systemctl stop sing-box 2>/dev/null || true
  if [ -f "$SETTINGS_FILE" ]; then
    # shellcheck disable=SC1090
    source "$SETTINGS_FILE"
    while ip rule del from "$ROUTE_SOURCE" table "$TABLE_ID" priority "$RULE_PRIORITY" 2>/dev/null; do :; done
    ip route flush table "$TABLE_ID" 2>/dev/null || true
  fi
  nft delete table ip ps5gw_nat 2>/dev/null || true
  rm -f "$ROUTE_SERVICE" "$ROUTE_SCRIPT"
  systemctl daemon-reload
  read -r -p "Удалить пакет sing-box и конфиги? [y/N]: " remove_all
  remove_all="${remove_all:-N}"
  if [[ "$remove_all" =~ ^[YyДд]$ ]]; then
    apt purge -y sing-box || true
    rm -rf "$SINGBOX_DIR" "$APP_DIR"
  fi
  echo "Удаление завершено."
}
main_menu() {
  echo
  echo "PS5 Gateway + sing-box"
  echo "1. Установить"
  echo "2. Удалить"
  echo "3. Изменить конфигурацию"
  echo
  read -r -p "Выбор [1-3]: " choice
  case "$choice" in
    1) install_flow ;;
    2) uninstall_flow ;;
    3) change_config_flow ;;
    *) echo "Неверный выбор"; exit 1 ;;
  esac
}
need_root
main_menu
