---
date: '2012-05-14T17:40:31+10:00'
draft: false
title: 'Access Mutt Attachments Remotely'
tags: ["linux", "mutt", "ssh"]
---

[Mutt](https://www.mutt.org/) is hard to adopt, but once you learn it, you love it. It is a very flexible email client. Opening attachments through remote (e.g., SSH) connections is time-consuming. You need to save and download the attachment to the remote host. One way to get around this is to serve the attachment through a web server on a specific port and open up the browser on the remote host to view the attachment on that port. This can be easily done with a simple bash script and using netcat. Below is the script that you need to save in your home directory (e.g., ~/bin/muttattach.sh).

```bash
#!/bin/sh
# muttattch.sh
# This script handle all the attachment type in mutt and forward to
# a netcat on port 8083 to view on the remote/local system
# in mutt open attachment and in remote system open localhost.

TEMP="/tmp/muttattch"
PORT=8083
rm -f $TEMP
mkfifo --mode=600 $TEMP

# netcat is the fun part of this script.
# -l:            listen for an incoming connection
# -q 1:          wait 1s after EOF and quit
nc -q 1 -l $PORT < $TEMP &> /dev/null &
# send the HTTP headers, followed by a blank line.
echo "HTTP/1.1 200 OK" >> $TEMP
echo "Server: pi3ch/netcat (mutt)" >> $TEMP
echo "Cache-Control: no-cache" >> $TEMP
echo "Pragma: no-cache" >> $TEMP
echo -n "Content-type: " >> $TEMP
file -bni $1 2> /dev/null >> $TEMP
echo -n "Content-Length: " >> $TEMP
wc -c<$1 >> $TEMP
echo >> $TEMP

echo "Pragma: no-cache" >> $TEMP
echo -n "Content-type: " >> $TEMP
file -bni $1 2> /dev/null >> $TEMP
echo -n "Content-Length: " >> $TEMP
wc -c<$1 >> $TEMP
echo >> $TEMP
# Get started sending the file...
cat $1 >> $TEMP &
# Progress bar

# Fire up your browser now!
sleep 7
```

Make it executable (e.g. chmod +x muttattach.sh). Modify ~/.mutt/mailcap and the following lines:

```
text/; ~/bin/muttattch.sh %s
application/; ~/bin/muttattch.sh %s
image/; ~/bin/muttattch.sh %s
audio/; ~/bin/muttattch.sh %s
```

Now open up an attachment in mutt, browse to http://localhost:8083.

The above script is the modified version of http://www.linuxjournal.com/article/6511
