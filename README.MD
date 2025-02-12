GeNArch - Gentleman’s Set for Arch Linux
=========================================
- [GeNArch English](README.MD)
- [GeNArch Russian](README-RU.MD)

What is the problem?
--------------------
I really love Arch, but I don’t particularly enjoy installing it. The problem is not with the installation itself, as one might think. The issue is that I always forget what packages are actually needed for proper system functioning. It’s frustrating when, after a week, you realize that `less` isn’t even installed.

This repository contains a set of scripts that I will use for my own Arch installations. Suggestions and feedback are welcome. The only file that is not up for discussion is 005. It will contain applications that I personally need. You are free to run the scripts in any order, fork them as you like, and create your own set of programs that should always be at hand.

The scripts are designed with the assumption that at least `sudo` is installed and configured, and that you have an internet connection. You need to take care of this yourself.

Script descriptions
-------------------

### 000 - Starter
This script allows you to run other scripts from one place.

### 001 - Post Install
This script installs the bare minimum set of packages required for basic system functionality. The packages I believe should ideally be part of the base system. This includes `less`, `curl`, `git`, as well as various drivers for hardware.

### 002 - Pacman Tweaks
An optional script that minimally configures `pacman`. It enables `multilib`, configures `reflector`, sets up parallel downloads, and of course, some candy.

### 003 - Additional
This script installs `yay` and a bunch of extra packages for any normal system: archivers, printers, utilities. Everything that is not tied to a specific DE.

### 004-1 - Hyprland
This script installs [JaKooLit Hyprland](https://github.com/JaKooLit/Arch-Hyprland). Why this one? Well, after trying a dozen others, I can confidently say this build is the most complete, flexible, and provides a 100% ready-for-work environment.

### 004-2 - Plasma
This script installs the full Plasma package along with several additional packages that should ideally be included with it.

### 005 - My Apps
An optional script that installs my personal applications. Everything I need for work. The main set of programs I use every day. As you might guess, this script isn’t necessary for most people.

### 006 - Plymouth
Another optional script with a tweak. It installs and configures `Plymouth`.