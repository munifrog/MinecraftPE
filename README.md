# Minecraft Pocket Edition (PE) Raspberry Pi Server

## Description
This project is for setting up a Minecraft Pocket Edition (PE) Server on a Raspberry Pi.
This Minecraft PE server allows for users of iOS and Android mobile devices, connected on the same sub-network, to play together.

## Requirements
Users logging into Microsoft accounts still need to connect to Microsoft servers for validation and permission enforcement.
Otherwise technically, users and Raspberry Pi could all connect to a router lacking outside internet.

The Raspberry Pi server must be configured within each mobile device as a server to look for.

When the Raspberry Pi server becomes out-of-date for the mobile devices, the `Nukkit` JAR must be updated.
(See update script.)

## Purchasing a Raspberry Pi
A Minecraft PE server could use as much processing power and memory as you are willing to put into it.

For this project, I am using (and therefore testing with):
  * Raspberry Pi 4
  * 4GB memory
  * A Raspberry Pi case with a cooling fan
  * Ubuntu Server (64-bit)
  * 16 GB microSD card

## Imaging Raspberry Pi Operation System
Note that for this project we will be using SSH to connect to the Raspberry Pi and manage the Minecraft server.
This removes any need for a Graphical User Interface (GUI), as provided by _desktop_ OS images.
In my previous iteration, I used [Raspberry Pi OS Lite (Built upon Debian Buster)](https://www.raspberrypi.org/downloads/raspberry-pi-os/).
For the second iteration, I went with [Ubuntu Server (64-bit)](https://ubuntu.com/download/raspberry-pi).
The main reason being that I could try out 64-bit processing.
I also expected even fewer unnecessary installations with the Ubuntu Server download.
Since both of these OS's are built on Debian, the instructions are fairly compatible.

 1. If the download is compressed (*.img.xz), unpack the image
    ```
    unxz *.img.xz
    ```

    The file extension should be `.img` to image a microSD card
 1. Image the microSD card. The imager provided by the makers of Raspberry Pi is quite easy to use:
    * [Ubuntu Linux](https://downloads.raspberrypi.org/imager/imager_amd64.deb)
    * [Windows](https://downloads.raspberrypi.org/imager/imager.exe)
    * [macOS](https://downloads.raspberrypi.org/imager/imager.dmg)

    Of course, there are other methods available online for imaging the microSD card.
    For instance, the powerful and dangerous `dd` on Linux and macOS.

 1. Eject the microSD card (unless you know how to remount the drive without this step).

## Personalizing Your Setup:
(Also see [Ubuntu's Instructions](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview))

### Connecting the Raspberry Pi to the Internet
The easiest way to connect your Raspberry Pi to the internet is by using an ethernet cable.
This may be preferred while you are figuring out how to communicate connection details to your Raspberry Pi.
But ultimately, the Raspberry Pi and mobile devices should connect to the same sub-network, in the same manner (usually _wi-fi_).
If you have access to the wi-fi router administration, then you can look at the connected devices to determine the IP address assigned to the Raspberry Pi.

An easy way to establish a _wi-fi_ connection is by placing a `wpa_supplicant.conf` file within the `/boot` folder:
  ```
  country=us
  update_config=1
  ctrl_interface=/var/run/wpa_supplicant

  network={
    scan_ssid=1
    ssid="My Home Network"
    psk="Passw0rd"
  }

  network={
    scan_ssid=1
    ssid="Work Employee Network"
    psk="Pa55word"
  }
  ```
Copy the `sample_wpa_supplicant.conf` as `wpa_supplicant.conf`, modify it according to your credentials, and place a copy in the `/boot` folder.
When you power on the Raspberry Pi this file will be placed into `/boot/firmware/wpa_supplicant.conf`.

An alternative file that you could modify is `network-config`, that comes with the Ubuntu image in the `/boot` folder.
Copy it from the `/boot` folder, back it up if desired, modify it, and replace the original.

When you are done providing the network details:
 1. Eject the microSD card
 1. Insert the microSD card into the Raspberry Pi
 1. Power on the router (if not already done)
 1. Power on the Raspberry Pi

### Connecting to Your Raspberry Pi Using SSH

If you have access to the router administration, it helps to look at the connected devices to see what IP address the Raspberry Pi (called `ubuntu` on the network) has been assigned.
Otherwise, another device on the same sub-network, such as a macOS or Ubuntu machine, can use `arp` to identify the Rapberry Pi:
  ```
  arp -na | grep -i "dc:a6:32"
  arp -na | grep -i "b8:27:eb"
  ```
If your Raspberry Pi successfully established an internet connection, then one of these commands should find the MAC address (and corresponding IP address) used by your Pi.
Be sure you have given the Raspberry Pi sufficient time to start up and acquire an IP address, before searching for it on the sub-network.

With the IP address of the Raspberry Pi known, you can connect to the Raspberry Pi from a device on the same sub-network.
(For example, I have installed `Termuius` on my phone so I can gracefully shut down the Raspberry Pi when I am away from home using a travel router.)
  ```
  ssh ubuntu@<IP address discovered earlier>
  ```
The initial password is `ubuntu`, which you will be required to change immediately upon logging in for the first time.

## Setting up the Raspberry Pi for Minecraft

Now that the Raspberry Pi is imaged and you can connect to it using SSH, it is time to clone this repository and set up the Minecraft PE service.

### Cloning this Repository

It is entirely possible that `git` is already installed on the Ubuntu Operating System.
To check if `git` is installed, type `which git`.
If `git` is installed, this command will tell you its executable file location.

Clone this repository using the following command:
  ```
  git clone https://github.com/munifrog/minecraftpe.git
  ```

### Updating the Operating System
As vulnerabilities are discovered and resolved, it is important that you pull these changes into the operating system within a reasonable timeframe.
(Hackers are also informed of vulnerabilities and can exploit them when not taken care of.)

If you were already able to clone this repository, then you can call the `os-refresh.sh` script now to perform an operating system update and upgrade.

If `git` is not already installed, then you will need to _manually_ execute the commands to refresh the operating system:
  ```
  sudo apt -y update
  sudo apt -y upgrade
  sudo apt -y autoremove
  ```

### Installing Git
If `git` is not already installed, then you can install it after an operating system refresh:
  ```
  sudo apt install -y git
  ```

At this point you can now clone this repository according to earlier instructions.
