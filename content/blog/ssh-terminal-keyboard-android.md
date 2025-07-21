---
date: '2012-07-16T10:00:00+10:00'
title: 'SSH Terminal Keyboard for Android'
draft: false
tags: ["android", "ssh", "mobile"]
---

If you've ever tried to use SSH from your Android device, you've likely encountered the frustrating limitation of missing terminal keys on the stock keyboard. Essential keys like CTRL and arrow keys are nowhere to be found, making terminal navigation and command execution challenging. While some SSH apps like ConnectBot provide workarounds through key combinations or device buttons, this solution falls short for phones without physical navigation buttons or trackballs (like the HTC Wildfire S).

## SSH for AnySoftKeyboard: The Solution

SSH for AnySoftKeyboard is a specialized virtual keyboard that adds these missing terminal keys, making SSH sessions on Android much more practical. It's designed specifically for SSH clients and terminal emulators, providing a more desktop-like terminal experience on your mobile device.

Command completion             | Special keys
:-------------------------:|:-------------------------:
![Screenshot of SSH for AnySoftKeyboard](/blog/images/ssh_keyboard_android1.jpg) | ![Screenshot of SSH for AnySoftKeyboard](/blog/images/ssh_keyboard_android2.jpg)

### Key Features

- **Special Keys**: Full access to essential terminal keys including:
  - CTRL
  - Arrow keys
  - Tab key
- **Smart Command Suggestions**: Includes auto-completion based on your most frequently used commands
- **Customizable**: Ability to add your own commands that will appear in future suggestions

### Setup Instructions

1. Install [AnySoftKeyboard](https://play.google.com/store/apps/details?id=com.menny.android.anysoftkeyboard) from Google Play
2. Install the SSH for AnySoftKeyboard extension
3. Enable the SSH keyboard layout in AnySoftKeyboard settings
4. For command suggestions:
   - Tap and hold the Enter key
   - Select SSH as the default dictionary for this keyboard
   - (Note: This won't affect settings for your other keyboards)

### Where to Get It

- Source code is available on [GitHub](https://github.com/pi3ch/ssh_anysoftkeyboard)

### Important Notes

- The command suggestion feature has been primarily tested with VX ConnectBot
- Command suggestions will learn and improve as you use the keyboard more frequently
- Your custom commands are saved and will appear in future auto-suggestions

This keyboard extension significantly improves the terminal experience on Android, making it much more practical to manage servers or run commands from your mobile device.
