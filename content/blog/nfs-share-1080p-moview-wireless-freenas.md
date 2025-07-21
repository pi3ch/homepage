---
date: '2012-05-28T18:43:18+10:00'
draft: false
title: 'Setup NFS to smoothly share 1080p movies over Wireless'
tags: ['nfs', 'freenas', 'wireless']
---

NFS is the traditional lightweight and superfast file sharing solution on mainly Nix and BSD distros. Due to small protocol overhead, NFS is one of the fastest ways of sharing files over local networks (See NFS vs SMF vs FTP vs SSH speed benchmark). So if you want to share those 1080p movies over home network to your HTPC without any stuttering, NFS can be the best choice.

So how to setup FreeNAS7 with NFS share? The first thing is WebGUI for FreeNAS7 is buggy for NFS service. So, have your SSH connection to FreeNAS ready.

## Step 1: Enable NFS through WebGUI

1. Go to Services > NFS > Shares > [+]
2. Set Path: path to your movie directory on the server
3. Map all users to root: if you want to give write access select yes
4. Authorised network: Subclass C of your network e.g. 192.168.1.1/24
5. Press Add
6. Apply changes and wait for NFS service to start

## Step 2: Modification through SSH

1. SSH to FreeNAS7
2. Change user to root (`su`)
3. Edit `/etc/exports` (e.g. `vi /etc/exports`)
4. If you have multiple directories on one mounting point that you want to share on the same network, make sure to add them all in one line. e.g. `/mnt/disk1/music /mnt/disk1/video`
5. Remove mask and network part and add the client IP address that you want to have access from. e.g. `192.168.1.2`
6. Optional: add `-mapall=YOURUSERNAME` to give write access to share directory
7. Your config file should look like: `/mnt/disk1/music /mnt/disk1/video -mapall=pi3ch 192.168.1.2`
8. Restart NFS service: `kill -HUP \`cat /var/run/mountd.pid\``

## Step 3: Check and mount share directories

On the client host run:

```bash
showmount -e FREENASIP
```

If you can see the share directories, congratulations! If not, have a look at the logs (WebGUI > Diagnostics > Log)

To mount a NFS share on the client host run (as a root):

```bash
mount FREENASIP:FULLPATHTODIR MOUNTPOINT
# e.g. mount 192.168.1.1:/mnt/disk1/music music
```

Enjoy the speed of NFS!
