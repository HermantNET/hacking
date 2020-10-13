Credentials
===========

| username   | password    |
|------------|-------------|
| mcsysadmin | bestelf1234 |

1 How many visible files are there in the home directory(excudling ./ and ../)?
-------------------------------------------------------------------------------

First, ssh into the machine `ssh mcsysadmin@10.10.234.142`, then count
the files `ls | wc -l`, returns `8`

2 What is the contents of file5?
--------------------------------

`cat file5`, returns `recipes`

3 Which file contains the string 'password'?
--------------------------------------------

`grep -rl`, returns `file6`

4 What is the IP address in a file in the home folder?
------------------------------------------------------

`grep -Rno -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`, returns
`file2:35:10.0.0.05`

5 How many users can log into the machine?
------------------------------------------

`grep -e "/bin/bash" /etc/passwd | wc -l`, although this won't always
return all users, and won't work on systems not using bash. Returns:

    root:x:0:0:root:/root:/bin/bash
    ec2-user:x:1000:1000:EC2 Default User:/home/ec2-user:/bin/bash
    mcsysadmin:x:1001:1001::/home/mcsysadmin:/bin/bash

6 What is the sha1 hash of file8?
---------------------------------

`sha1sum file8`, returns `fa67ee594358d83becdd2cb6c466b25320fd2835`

7 What is mcsysadmin's password hash?
-------------------------------------

`find / -type f -name "*.bak"`, returns:

    /etc/nsswitch.conf.bak
    /var/shadow.bak

`cat /var/shadow.bak`, returns:

    ...
    mcsysadmin:$6$jbosYsU/$qOYToX/hnKGjT0EscuUIiIqF8GHgokHdy/Rg/DaB.RgkrbeBXPdzpHdMLI6cQJLdFlS4gkBMzilDBYcQvu2ro/:18234:0:99999:7:::
