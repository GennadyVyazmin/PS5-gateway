# PS5 Gateway
Скрипт для Debian VM, которая работает как локальный gateway для PS5 или других устройств.
Схема работы:
```text
PS5 → Debian VM → sing-box → VLESS Reality → интернет

Скрипт работает с VLESS-подписками от 3x-ui.

Поддерживается:

* VLESS Reality;
* подписка ссылкой;
* base64-подписка;
* несколько outbound в одной подписке;
* выбор сервера через MetaCubeXD UI.

Требования

Debian 12/13.

Перед запуском на чистой Debian нужно установить curl.

Если вы под root:

apt update
apt install -y curl

Если вы под обычным пользователем и sudo уже есть:

sudo apt update
sudo apt install -y curl

Если sudo нет, сначала зайдите под root:

su -

И затем выполните:

apt update
apt install -y curl

Установка и запуск

curl -fsSL 'https://raw.githubusercontent.com/GennadyVyazmin/PS5-gateway/refs/heads/main/setup-ps5-gateway.sh' -o /tmp/setup-ps5-gateway.sh && chmod +x /tmp/setup-ps5-gateway.sh && bash /tmp/setup-ps5-gateway.sh

Если запускаете от обычного пользователя с установленным sudo:

curl -fsSL 'https://raw.githubusercontent.com/GennadyVyazmin/PS5-gateway/refs/heads/main/setup-ps5-gateway.sh' -o /tmp/setup-ps5-gateway.sh && chmod +x /tmp/setup-ps5-gateway.sh && sudo bash /tmp/setup-ps5-gateway.sh

Меню

1. Установить
2. Удалить
3. Изменить конфигурацию

Настройка PS5

В настройках сети PS5 укажите:

Gateway: IP Debian VM
DNS:     1.1.1.1 или 8.8.8.8

IP Debian VM скрипт покажет после установки.

Web UI

После установки интерфейс доступен по адресу:

http://IP_DEBIAN_VM:9090/ui

В UI можно выбрать сервер вручную в группе select.

Для игр лучше выбирать конкретный сервер вручную, а не auto, чтобы во время игры не было переключения outbound.

:::
