Это верно? [Y/n]: y

Кого гнать через VPN?
1) Только одно устройство, например PS5
2) Всю LAN-подсеть, но реально пойдут только те устройства, у которых gateway = IP этой VM
Выбор [1/2, по умолчанию 1]: 2
Hit:1 http://security.debian.org/debian-security trixie-security InRelease
Hit:2 http://deb.debian.org/debian trixie InRelease
Hit:3 http://deb.debian.org/debian trixie-updates InRelease
All packages are up to date.    
curl is already the newest version (8.14.1-2+deb13u3).
wget is already the newest version (1.25.0-2).
ca-certificates is already the newest version (20250419).
iproute2 is already the newest version (6.15.0-1).
nftables is already the newest version (1.1.3-1).
python3 is already the newest version (3.13.5-1).
python3 set to manually installed.
Installing:
  git  gpg  unzip

Installing dependencies:
  dirmngr  gnupg       gnupg-utils  gpg-wks-client  gpgsm  libassuan9          liberror-perl  libgpg-error-l10n  libksba8      libngtcp2-crypto-gnutls8  patch
  git-man  gnupg-l10n  gpg-agent    gpgconf         gpgv   libcurl3t64-gnutls  libgcrypt20    libgpg-error0      libngtcp2-16  libnpth0t64               pinentry-curses

Suggested packages:
  pinentry-gnome3  tor  git-doc  git-email  git-gui  gitk  gitweb  git-cvs  git-mediawiki  git-svn  gpg-wks-server  parcimonie  xloadimage  scdaemon  tpm2daemon  rng-tools  ed  diffutils-doc  pinentry-doc  zip

Summary:
  Upgrading: 0, Installing: 25, Removing: 0, Not Upgrading: 0
  Download size: 16.7 MB
  Space needed: 70.2 MB / 6,176 MB available

Get:1 http://security.debian.org/debian-security trixie-security/main amd64 libgcrypt20 amd64 1.11.0-7+deb13u1 [843 kB]
Get:2 http://deb.debian.org/debian trixie/main amd64 libgpg-error0 amd64 1.51-4 [82.1 kB]
Get:3 http://deb.debian.org/debian trixie/main amd64 libassuan9 amd64 3.0.2-2 [61.5 kB]
Get:4 http://deb.debian.org/debian trixie/main amd64 gpgconf amd64 2.4.7-21+deb13u1+b3 [129 kB]
Get:5 http://deb.debian.org/debian trixie/main amd64 libksba8 amd64 1.6.7-2+b1 [136 kB]
Get:6 http://deb.debian.org/debian trixie/main amd64 libnpth0t64 amd64 1.8-3 [23.2 kB]
Get:7 http://deb.debian.org/debian trixie/main amd64 dirmngr amd64 2.4.7-21+deb13u1+b3 [384 kB]
Get:8 http://deb.debian.org/debian trixie/main amd64 libngtcp2-16 amd64 1.11.0-1+deb13u1 [132 kB]
Get:9 http://deb.debian.org/debian trixie/main amd64 libngtcp2-crypto-gnutls8 amd64 1.11.0-1+deb13u1 [29.5 kB]
Get:10 http://deb.debian.org/debian trixie/main amd64 libcurl3t64-gnutls amd64 8.14.1-2+deb13u3 [384 kB]
Get:11 http://deb.debian.org/debian trixie/main amd64 liberror-perl all 0.17030-1 [26.9 kB]
Get:12 http://deb.debian.org/debian trixie/main amd64 git-man all 1:2.47.3-0+deb13u1 [2,205 kB]
Get:13 http://deb.debian.org/debian trixie/main amd64 git amd64 1:2.47.3-0+deb13u1 [8,862 kB]
Get:14 http://deb.debian.org/debian trixie/main amd64 gnupg-l10n all 2.4.7-21+deb13u1 [749 kB]
Get:15 http://deb.debian.org/debian trixie/main amd64 gpg amd64 2.4.7-21+deb13u1+b3 [635 kB]
Get:16 http://deb.debian.org/debian trixie/main amd64 pinentry-curses amd64 1.3.1-2 [86.4 kB]
Get:17 http://deb.debian.org/debian trixie/main amd64 gpg-agent amd64 2.4.7-21+deb13u1+b3 [271 kB]
Get:18 http://deb.debian.org/debian trixie/main amd64 gpgsm amd64 2.4.7-21+deb13u1+b3 [276 kB]
Get:19 http://deb.debian.org/debian trixie/main amd64 gnupg all 2.4.7-21+deb13u1 [417 kB]
Get:20 http://deb.debian.org/debian trixie/main amd64 gpg-wks-client amd64 2.4.7-21+deb13u1+b3 [109 kB]
Get:21 http://deb.debian.org/debian trixie/main amd64 gpgv amd64 2.4.7-21+deb13u1+b3 [241 kB]
Get:22 http://deb.debian.org/debian trixie/main amd64 libgpg-error-l10n all 1.51-4 [114 kB]
Get:23 http://deb.debian.org/debian trixie/main amd64 patch amd64 2.8-2 [134 kB]
Get:24 http://deb.debian.org/debian trixie/main amd64 unzip amd64 6.0-29 [173 kB]
Get:25 http://deb.debian.org/debian trixie/main amd64 gnupg-utils amd64 2.4.7-21+deb13u1+b3 [195 kB]
Fetched 16.7 MB in 1s (24.5 MB/s) 
Selecting previously unselected package libgpg-error0:amd64.
(Reading database ... 34908 files and directories currently installed.)
Preparing to unpack .../00-libgpg-error0_1.51-4_amd64.deb ...
Unpacking libgpg-error0:amd64 (1.51-4) ...
Selecting previously unselected package libassuan9:amd64.
Preparing to unpack .../01-libassuan9_3.0.2-2_amd64.deb ...
Unpacking libassuan9:amd64 (3.0.2-2) ...
Selecting previously unselected package libgcrypt20:amd64.
Preparing to unpack .../02-libgcrypt20_1.11.0-7+deb13u1_amd64.deb ...
Unpacking libgcrypt20:amd64 (1.11.0-7+deb13u1) ...
Selecting previously unselected package gpgconf.
Preparing to unpack .../03-gpgconf_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gpgconf (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package libksba8:amd64.
Preparing to unpack .../04-libksba8_1.6.7-2+b1_amd64.deb ...
Unpacking libksba8:amd64 (1.6.7-2+b1) ...
Selecting previously unselected package libnpth0t64:amd64.
Preparing to unpack .../05-libnpth0t64_1.8-3_amd64.deb ...
Unpacking libnpth0t64:amd64 (1.8-3) ...
Selecting previously unselected package dirmngr.
Preparing to unpack .../06-dirmngr_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking dirmngr (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package libngtcp2-16:amd64.
Preparing to unpack .../07-libngtcp2-16_1.11.0-1+deb13u1_amd64.deb ...
Unpacking libngtcp2-16:amd64 (1.11.0-1+deb13u1) ...
Selecting previously unselected package libngtcp2-crypto-gnutls8:amd64.
Preparing to unpack .../08-libngtcp2-crypto-gnutls8_1.11.0-1+deb13u1_amd64.deb ...
Unpacking libngtcp2-crypto-gnutls8:amd64 (1.11.0-1+deb13u1) ...
Selecting previously unselected package libcurl3t64-gnutls:amd64.
Preparing to unpack .../09-libcurl3t64-gnutls_8.14.1-2+deb13u3_amd64.deb ...
Unpacking libcurl3t64-gnutls:amd64 (8.14.1-2+deb13u3) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../10-liberror-perl_0.17030-1_all.deb ...
Unpacking liberror-perl (0.17030-1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../11-git-man_1%3a2.47.3-0+deb13u1_all.deb ...
Unpacking git-man (1:2.47.3-0+deb13u1) ...
Selecting previously unselected package git.
Preparing to unpack .../12-git_1%3a2.47.3-0+deb13u1_amd64.deb ...
Unpacking git (1:2.47.3-0+deb13u1) ...
Selecting previously unselected package gnupg-l10n.
Preparing to unpack .../13-gnupg-l10n_2.4.7-21+deb13u1_all.deb ...
Unpacking gnupg-l10n (2.4.7-21+deb13u1) ...
Selecting previously unselected package gpg.
Preparing to unpack .../14-gpg_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gpg (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package pinentry-curses.
Preparing to unpack .../15-pinentry-curses_1.3.1-2_amd64.deb ...
Unpacking pinentry-curses (1.3.1-2) ...
Selecting previously unselected package gpg-agent.
Preparing to unpack .../16-gpg-agent_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gpg-agent (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package gpgsm.
Preparing to unpack .../17-gpgsm_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gpgsm (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package gnupg.
Preparing to unpack .../18-gnupg_2.4.7-21+deb13u1_all.deb ...
Unpacking gnupg (2.4.7-21+deb13u1) ...
Selecting previously unselected package gpg-wks-client.
Preparing to unpack .../19-gpg-wks-client_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gpg-wks-client (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package gpgv.
Preparing to unpack .../20-gpgv_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gpgv (2.4.7-21+deb13u1+b3) ...
Selecting previously unselected package libgpg-error-l10n.
Preparing to unpack .../21-libgpg-error-l10n_1.51-4_all.deb ...
Unpacking libgpg-error-l10n (1.51-4) ...
Selecting previously unselected package patch.
Preparing to unpack .../22-patch_2.8-2_amd64.deb ...
Unpacking patch (2.8-2) ...
Selecting previously unselected package unzip.
Preparing to unpack .../23-unzip_6.0-29_amd64.deb ...
Unpacking unzip (6.0-29) ...
Selecting previously unselected package gnupg-utils.
Preparing to unpack .../24-gnupg-utils_2.4.7-21+deb13u1+b3_amd64.deb ...
Unpacking gnupg-utils (2.4.7-21+deb13u1+b3) ...
Setting up libnpth0t64:amd64 (1.8-3) ...
Setting up libgpg-error0:amd64 (1.51-4) ...
Setting up unzip (6.0-29) ...
Setting up libgcrypt20:amd64 (1.11.0-7+deb13u1) ...
Setting up liberror-perl (0.17030-1) ...
Setting up gnupg-l10n (2.4.7-21+deb13u1) ...
Setting up patch (2.8-2) ...
Setting up gpgv (2.4.7-21+deb13u1+b3) ...
Setting up libassuan9:amd64 (3.0.2-2) ...
Setting up gpgconf (2.4.7-21+deb13u1+b3) ...
Setting up git-man (1:2.47.3-0+deb13u1) ...
Setting up libngtcp2-16:amd64 (1.11.0-1+deb13u1) ...
Setting up libgpg-error-l10n (1.51-4) ...
Setting up libngtcp2-crypto-gnutls8:amd64 (1.11.0-1+deb13u1) ...
Setting up libksba8:amd64 (1.6.7-2+b1) ...
Setting up pinentry-curses (1.3.1-2) ...
Setting up gpg-agent (2.4.7-21+deb13u1+b3) ...
Created symlink '/etc/systemd/user/sockets.target.wants/gpg-agent-browser.socket' → '/usr/lib/systemd/user/gpg-agent-browser.socket'.
Created symlink '/etc/systemd/user/sockets.target.wants/gpg-agent-extra.socket' → '/usr/lib/systemd/user/gpg-agent-extra.socket'.
Created symlink '/etc/systemd/user/sockets.target.wants/gpg-agent-ssh.socket' → '/usr/lib/systemd/user/gpg-agent-ssh.socket'.
Created symlink '/etc/systemd/user/sockets.target.wants/gpg-agent.socket' → '/usr/lib/systemd/user/gpg-agent.socket'.
Setting up gpgsm (2.4.7-21+deb13u1+b3) ...
Setting up libcurl3t64-gnutls:amd64 (8.14.1-2+deb13u3) ...
Setting up dirmngr (2.4.7-21+deb13u1+b3) ...
Created symlink '/etc/systemd/user/sockets.target.wants/dirmngr.socket' → '/usr/lib/systemd/user/dirmngr.socket'.
Setting up git (1:2.47.3-0+deb13u1) ...
Setting up gpg (2.4.7-21+deb13u1+b3) ...
Created symlink '/etc/systemd/user/sockets.target.wants/keyboxd.socket' → '/usr/lib/systemd/user/keyboxd.socket'.
Setting up gnupg-utils (2.4.7-21+deb13u1+b3) ...
Setting up gpg-wks-client (2.4.7-21+deb13u1+b3) ...
Setting up gnupg (2.4.7-21+deb13u1) ...
Processing triggers for man-db (2.13.1-1) ...
Processing triggers for libc-bin (2.41-12+deb13u3) ...
curl: (22) The requested URL returned error: 404
gpg: no valid OpenPGP data found.
root@debian:~# sudo bash /tmp/setup-ps5-gateway.sh

PS5 Gateway + sing-box
1. Установить
2. Удалить
3. Изменить конфигурацию

Выбор [1-3]: `
Неверный выбор
root@debian:~# sudo bash /tmp/setup-ps5-gateway.sh

PS5 Gateway + sing-box
1. Установить
2. Удалить
3. Изменить конфигурацию

Выбор [1-3]: 1

Найдено:
  Интерфейс VM: ens18
  IP VM:        192.168.88.29
  Роутер:       192.168.88.1
  LAN:          192.168.88.0/24

Это верно? [Y/n]: y

Кого гнать через VPN?
1) Только одно устройство, например PS5
2) Всю LAN-подсеть, но реально пойдут только те устройства, у которых gateway = IP этой VM
Выбор [1/2, по умолчанию 1]: 2
Hit:1 http://security.debian.org/debian-security trixie-security InRelease
Hit:2 http://deb.debian.org/debian trixie InRelease
Hit:3 http://deb.debian.org/debian trixie-updates InRelease
All packages are up to date.    
curl is already the newest version (8.14.1-2+deb13u3).
wget is already the newest version (1.25.0-2).
ca-certificates is already the newest version (20250419).
gpg is already the newest version (2.4.7-21+deb13u1+b3).
iproute2 is already the newest version (6.15.0-1).
nftables is already the newest version (1.1.3-1).
python3 is already the newest version (3.13.5-1).
git is already the newest version (1:2.47.3-0+deb13u1).
unzip is already the newest version (6.0-29).
Summary:
  Upgrading: 0, Installing: 0, Removing: 0, Not Upgrading: 0
File '/etc/apt/keyrings/sagernet.gpg' exists. Overwrite? (y/N) curl: (22) The requested URL returned error: 404

Enter new filename: 
gpg: signal Interrupt caught ... exiting

root@debian:~# sudo bash /tmp/setup-ps5-gateway.sh

PS5 Gateway + sing-box
1. Установить
2. Удалить
3. Изменить конфигурацию

Выбор [1-3]: 2
Удаляю настройки PS5 gateway...
Удалить пакет sing-box и конфиги? [y/N]: y
Error: Unable to locate package sing-box
Удаление завершено.
root@debian:~# sudo bash /tmp/setup-ps5-gateway.sh

PS5 Gateway + sing-box
1. Установить
2. Удалить
3. Изменить конфигурацию

Выбор [1-3]: 1

Найдено:
  Интерфейс VM: ens18
  IP VM:        192.168.88.29
  Роутер:       192.168.88.1
  LAN:          192.168.88.0/24

Это верно? [Y/n]: y

Кого гнать через VPN?
1) Только одно устройство, например PS5
2) Всю LAN-подсеть, но реально пойдут только те устройства, у которых gateway = IP этой VM
Выбор [1/2, по умолчанию 1]: 2
Hit:1 http://deb.debian.org/debian trixie InRelease
Hit:2 http://security.debian.org/debian-security trixie-security InRelease
Hit:3 http://deb.debian.org/debian trixie-updates InRelease
All packages are up to date.    
curl is already the newest version (8.14.1-2+deb13u3).
wget is already the newest version (1.25.0-2).
ca-certificates is already the newest version (20250419).
gpg is already the newest version (2.4.7-21+deb13u1+b3).
iproute2 is already the newest version (6.15.0-1).
nftables is already the newest version (1.1.3-1).
python3 is already the newest version (3.13.5-1).
git is already the newest version (1:2.47.3-0+deb13u1).
unzip is already the newest version (6.0-29).
Summary:
  Upgrading: 0, Installing: 0, Removing: 0, Not Upgrading: 0
File '/etc/apt/keyrings/sagernet.gpg' exists. Overwrite? (y/N) curl: (22) The requested URL returned error: 404

