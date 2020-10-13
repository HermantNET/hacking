OSINT
=====

Using the provided materials, we run exiftool to check the image
metadata:

    exiftool thegrinch.jpg

We find the `Creator` field contains a possible username of `JLolax1`.
Now we run sherlock to find any linked accounts on major platforms:

    sherlock JLolax1

#### Returns

    [+] Euw: https://euw.op.gg/summoner/userName=JLolax1
    [+] Photobucket: https://photobucket.com/user/JLolax1/library
    [+] Steamid: https://steamid.uk/profile/JLolax1
    [+] Twitter: https://mobile.twitter.com/JLolax1

Checking out Twitter, we find

-   Born December 29, 1900
-   <https://lolajohnson1998.wordpress.com/>
-   She is one of Santa's Helpers
-   She is a professional photographer
-   She owns an iPhone X

let's checkout that wordpress site. We find:

-   10 Street Road, City, 10100 USA
-   <johnson.lola1992@gmail.com>
-   She knows AutoCAD, Fashion Modeling, Pet Styling, 120mm Film,
    Blogging

Using wayback machine we find a snapshot of the site revealing when she
first started freelance photography.

We run a reverse image search using tineye.com on the painting from her
site, that we find out is of Ada Lovelace
