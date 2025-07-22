---
date: '2011-05-15T10:00:00+10:00'
title: 'Persian/Farsi Language for Android'
draft: false
tags: ["android", "persian", "farsi", "keyboard", "language"]
---

## Problem

Stock android-based devices do not have support for Persian/Farsi languages as yet (up to version 4.0) but there are some custom modified android devices that some-how support Persian languages. What I mean by Persian language support is the functionality to write and read Persian content. Since I have published one keyboard app for Persian language, many people have contacted me saying "app doesn't work" or how to install Persian fonts on their android devices. Here I am going to share some workarounds on how to install, setup, and configure Persian language support (or any other language) on your android device. This article might be in advanced level so you might ask Android-geek-guy to do it for you!

## Persian keyboard for Android

Persian for AnySoftkeyboard is a Persian language keyboard layout for android devices. It can run on all android devices from v1.5+. You can see below app's screenshots:

Persian Numbers | Persian keyboard | Pinglish Keyboard
:-------------------------:|:-------------------------:|:-------------------------:
![Persian numbers](/blog/images/persian_keyboard_android_number.png) | ![Persian keyboard](/blog/images/persian_keyboard_android_type.png) | ![Pinglish keyboard](/blog/images/persian_keyboard_android_pinglish.png)

## Features

- Full Persian keyboards
- Persian words suggestion and auto completion
- Persian numbers
- Pinglish keyboard with Pinglish words suggestions

## Usage

The key and main step to enable Persian language support is to have 'rooted' devices. What does it mean? It means that you should be able to modify android core files (including font files). No matter what android device you have (HTC, LG, Samsung, Nexus, Motorola etc), all of them are not-rooted. What does that mean? It means you cannot modify/install/add any font on your device. So no Persian language support! ... but wait! Nothing is impossible right? Some geeks have already found some solutions!

## Root your device

There are different ways for each android device to get rooted. Here I list some articles for different devices. REMEMBER by rooting your android devices you MIGHT void your device guarantee. Keep this in mind and read the articles below to get your device rooted.

- HOWTO root HTC Hero: [link](http://theunlockr.com/2009/08/27/how-to-root-your-htc-hero-in-one-click/), [another link](http://theunlockr.com/2010/09/27/how-to-root-the-htc-hero-androot-method/)
- HOWTO root HTC Desire: [link](http://theunlockr.com/2010/06/07/how-to-root-the-htc-desire/)
- HOWTO root HTC Desire HD: [link](http://theunlockr.com/2010/11/15/universal-android-rooting-method-visionary-method/)
- HOWTO root HTC Legend: [link](http://theunlockr.com/2010/07/26/how-to-root-the-htc-incredible-unrevoked-method/)
- HOWTO root HTC Incredible: [link](http://theunlockr.com/2010/07/26/how-to-root-the-htc-incredible-unrevoked-method/)
- HOWTO root other Android devces (LG, Samsung, Motorola, Nexus, Sony etc): [link](http://theunlockr.com/how-tos/android-how-tos/)
- 2 universal ways to root any Android devices: [link1](http://theunlockr.com/2010/10/26/universal-android-rooting-procedure-rage-method/), [link2](http://theunlockr.com/2011/02/28/universal-rooting-app-procedure-z4root/)

Congratulation! Your android device is not virgin anymore! Now you can go ahead and play with different part of your device!

## Add Persian language support to android (Solution 1)

1. You have rooted device? Okay go ahead.

2. Get Arabic or Persian fonts from [here](http://code.google.com/p/softkeyboard/downloads/detail?name=cm_fonts.rar&can=2&q=) or [here](https://sites.google.com/a/ut.utm.edu/arabic-android/downloads/Dejavu_Fonts_By_Aman_Alshurafa.zip?attredirects=0&d=1).

3. Connect your device to the computer and run following commands ([wth?](http://theunlockr.com/2009/10/06/how-to-set-up-adb-usb-drivers-for-android-devices/))

```bash
adb root
adb shell mount -o rw,remount -t yaffs2 /dev/block/mtdblock3 /system
```

4. Transfer fonts from /home/pi3ch/fonts/ to /system/fonts directory on your device and reboot.

```bash
adb push /home/pi3ch/fonts/ /system/fonts/
adb shell reboot
```

5. Go to Google Play and search for AnySoftKeyboard, download and install it on your device.

6. Search for "Persian for AnySoftKeyboard" on Play, download and install on your device.

7. Select AnySoftKeyboard as your default keyboard and choose Persian as your keyboard in AnySoftKeyboard settings ([Need help?](http://code.google.com/p/softkeyboard/wiki/HowTo)).

8. Enjoy typing and searching in Persian!

## Add Persian language support to android (Solution 2)

1. You have rooted device? Okay go ahead.

2. Download and flash one of the custom-made ROMs for your android device. What does it mean? There are some geeks out there that have spare time to modify android core files and make a better android system for your device. These modified android systems are called custom ROMs. Cyanogen (or CM) is a name of one the most famous custom ROMs that also support Persian language. Below link can help you to find a CM-based ROM for your device. [CyanogenMod (CM) based roms for most of android devices](http://wiki.cyanogenmod.org/w/Devices)

3. Go to Play and search for AnySoftKeyboard, download and install it on your device.

4. Search for "Persian for AnySoftKeyboard" on Play, download and install on your device.

5. Select AnySoftKeyboard as your default keyboard and choose Persian as your keyboard in AnySoftKeyboard settings ([Need help?](http://code.google.com/p/softkeyboard/wiki/HowTo)).

6. Enjoy typing and searching in Persian!

## Pinglish keyboard

Pinglish keyboard has similar layout to English keyboard layout, the only difference is the suggested wordlist. To see this layout when you are on Persian layout, simply tap on ' > ABC >'. For example if you have enabled English and Persian and Persian (Pinglish) layouts the order going to be English (tap > ABC >) Persian (tap > ABC >) Persian (Pinglish) (tap > ABC >) English ...

## Download

Download from [Google play](https://play.google.com/store/apps/details?id=com.anysoftkeyboard.languagepack.persian)

## Tips for using Persian keyboard

- Tap and hold on some letters to get alternative letters or numbers (e.g. گ ژ ی).
- Tap on ی to get Persian ی.
- To read Persian website you can use either Persian Web Browser or Opera Mini on your device.

## Notes

- Persian ی that comes in the middle of sentence coverts to a square with some android fonts. That's the reason I set the default to Arabic ی.
- This is open source application. Feel free to contribute: [GitHub repository](https://github.com/pi3ch/persian_anysoftkeyboard)
- If you have any issues/feedback/comment use github issues or comments below.
