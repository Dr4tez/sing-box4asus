A script to run sing-box on Asus routers with Merlin firmware and Entware installed on a USB drive.

I. Basics.

 1. You should be able to create configuration files for sing-box. Documentation: https://sing-box.sagernet.org/.

 2. Only routers with ARM/AArch processor architectures are supported (you can find out by running the 'uname -m' command in the router command line) and a system core version not lower than 4.1 (you can find out by running the 'uname -r' command in the router command line). If the router's CPU architecture or the system core version does not meet these requirements, the script installation will be cancelled.

 3. If IPv6 is enabled in your router settings, it is not recommended to use this script, as it will likely not function as intended in most cases.

 4. A USB drive with Entwar installed must be connected to your router. The sing-box core will be permanently located in it, and temporary files will be periodically created and deleted during the installation of the script and its updates. Installing these components in the internal memory of the router is not desirable, and sometimes impossible due to its limitations, and is not considered.

 5. If you notice bugs in the script or can improve/optimize the script, please share this information with me.

II. Installing the script.
Run the following command in the router's command line:
wget -O /jffs/scripts/sbs https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sbs && chmod 775 /jffs/scripts/sbs && /jffs/scripts/sbs install

III. Initial setup and running of the script.
After installing the script, before the first start of sing-box, be sure to configure it! To do this, follow these steps.

 1. First, you need to edit the sing-box configuration file template, located at /jffs/addons/sing-box-script/config.json.
 You can do this in the menu called by the 'sbs edit' command, selecting the first item there. You can also do this in any other way convenient for you, for example, using WinSCP.
 At a minimum, you should enter your values ​​​​in the config.json template in the lines with X's. Please note that it uses my personal ruleset, downloaded from my GitHub page (https://github.com/Dr4tez/my_domains), it may not contain the blocked domains you need. According to this template, traffic of devices directed through the sing-box is routed according to the following rules: domains contained in rule_set "my_domains" go to the proxy tunnel, and everything else goes to direct.
 Of course, you can completely replace the template with your own configuration file, the main thing is that it has the name config.json, and it must comply with the sing-box configuration features on the router, specified in section V of this Readme.
 Do not edit the config.json configuration file while sing-box is running. Make sure to stop it before doing so, otherwise bugs will appear that you will not be able to get rid of without certain knowledge. But if you use the first point of menu 'sbs config' to edit config.json, sing-box does not need to be stopped first, it will be stopped automatically.

 2. Then, to enter the script setup menu, run the command 'sbs setup'. But, you can get to this menu only if your config.json has tun or tproxy interface, otherwise you have nothing to configure there, and you will only get a message about it.
  2.1 The first item in this menu is to configure the IP addresses of the devices whose traffic you want to route through the sing-box.
  2.2 If your config.json file contains settings for working via fakeip, then the second point in the script settings menu will be setting up the IP addresses of devices that should work via fakeip.
  For more information about the settings specified in points 2.1 and 2.2 of this section, see section IV of this readme.
  2.3 The next item in the script settings menu will be a submenu of advanced, but optional settings.
  In it, you can change the routing table number for sing-box. Also, if your sing-box configuration file has a tproxy interface, there will be an option to change the tproxy-mark.
  All items in this submenu are optional, they are for those who need them. If you do not know what they are for and what they should be, then do not touch them.
  2.4 When you select option 0 to exit the script setup menu, you will be prompted to run sing-box. If you are ready, agree.

IV. About configuring device IP addresses to route them via regular routing or fakeip.
The script has the ability to route the device IP addresses through normal routing using the first menu item 'sbs setup', and/or specify them for use by fakeip via the second menu item 'sbs setup', which will only appear if the config.json file contains fakeip settings. Different options require different, appropriately composed sing-box configuration files, which requires advanced skills in compiling them.
Configuration file templates for sing-box 1.11.* cores for all the variants listed below can be found on the project page https://github.com/Dr4tez/sing-box4asus. If you want to use one of them with other sing-box core versions, don't forget to change the config according to the Migration section of the sing-box documentation https://sing-box.sagernet.org/migration/ if necessary.

 1. If you want to route device IP addresses only via regular routing, then specify them only in the first point of the 'sbs setup' menu. If you specify a subnet in CIDR format here, for example 192.168.50.0/24, then after entering it, a prompt will appear to enter exception IP addresses that should not be routed via sing-box.
 Write IP addresses in one line, separating them only with spaces. This also applies to subsequent variants.
 Attention! If you need access from WAN to any device in your router's network via port forwarding, do not add the IP address of this device in the first point of the 'sbs setup' menu, otherwise there will be no access. The same is true when adding an entire subnet - there will be no access from WAN via port forwarding to the router's web interface and to all devices in the subnet, except for those whose IP addresses you specify at the stage of entering IP addresses of exceptions.
 For this option, the sing-box configuration file template named config.json, which is automatically downloaded when installing the script, is suitable.

 2. If you want to configure IP addresses to work only via fakeip, then specify them only in the second point of the 'sbs setup' menu. If you specify a subnet in CIDR format here, then after entering it, a prompt will appear to enter IP addresses of exceptions that should not work through fakeip.
 For this option, the sing-box configuration file template is called config-2.json. If you want to use it, just copy its contents into the config.json file downloaded during script installation, replacing its contents.

 3. If you want to route the entire subnet via regular routing, specifying it in the first item of the 'sbs setup' menu, and configure some IP addresses from it to work via fakeip, then specify these IP addresses in the second item.
 For this option, the sing-box configuration file template is called config-3.json. If you want to use it, just copy its contents into the config.json file downloaded during script installation, replacing its contents. Instead of IP addresses 192.168.50.14 and 192.168.50.15 in this configuration file, you can insert your IP addresses of the devices that you want to configure to work via fakeip.

 4. If you want to route the entire subnet via fakeip, specifying it in the second item of the 'sbs setup' menu, and configure some IP addresses from it to work via regular routing, then specify these IP addresses in the first item.
 For this option, the sing-box configuration file template is called config-4.json. If you want to use it, just copy its contents into the config.json file downloaded during script installation, replacing its contents. Instead of IP addresses 192.168.50.14 and 192.168.50.15 in this configuration file, you can insert your IP addresses of devices that you want to route via the sing-box using regular routing.

V. Features of configuring sing-box on a router.
Here are listed the conditions that must be observed when creating sing-box configuration files for the router, as well as the necessary settings in the router web interface.

 1. General conditions:
  1.1 Do not use the following functions in your config.json: '"auto_route": true', '"auto_detect_interface": true' and others that contain the word 'auto' in their name. They do not work correctly in the router and disrupt routing.
  1.2 Do not use the '"strict_route": true' setting in config.json, this may cause loss of access to the router's command line and routing problems.
  1.3 The script only supports one tun or tproxy interface, so do not add more than one to config.json.

 2. For sing-box to work with DNS servers specified in the config.json, all of the following conditions must be met:
  2.1 In the "LAN - DHCP Server" section of the router's web interface:
   1) The "DNS Server 1" and "DNS Server 2" fields must be empty,
   2) The "Advertise router's IP in addition to user-specified DNS" option must be set to "Yes",
   3) In the "DNS Server (Optional)" fields for the devices whose traffic is routed through sing-box, "Default" should be specified;
  2.2 In the "LAN - DNS Director" section of the router's web interface, there should be no settings for the devices whose traffic is routed through sing-box.
  2.3 The following block should be present in the inbounds section of config.json:
    {
      "type": "direct",
      "tag": "dns-in",
      "listen": "0.0.0.0",
      "listen_port": 55553,
      "override_port": 5553
    }
  This block is an inbound direct interface called dns-in. It accepts DNS requests on port 55553 from devices whose traffic is routed through the sing-box and redefines them to port 5553. The listen_port value does not necessarily have to be 55553, if this port is already occupied by your router for other purposes, you can enter any free 4- or 5-digit port instead. The override_port value does not necessarily have to be 5553, if this port is already occupied by your router or sing-box for other purposes, you can enter any free 4- or 5-digit port instead.
  This block is present in the template of my config.json, downloaded during the installation of the script.

VI. Script management commands.
To start the sing-box script, run the following command in the router's command line:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, run the following command:
sbs stop
To remove the script and all the results of its activity, run the following command:
sbs remove
You can see a complete list of commands with their descriptions by running the following command:
sbs

VII. Updating the script.

 1. From script versions 1.8 and newer, updating to the latest version is done through the menu called by the command 'sbs update', in which you just need to select the first item.

 2. Updating to the latest version of the script from versions 1.7 and older is possible only by reinstalling the script according to the following instructions:
  1) Save your configuration file config.json located in the directory /jffs/addons/sing-box-script somewhere.
  2) Remove the previous version using the 'sbs remove' command in the router command line.
  3) Install the latest version by running the following command in the router command line:
wget -O /jffs/scripts/sbs https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sbs && chmod 775 /jffs/scripts/sbs && /jffs/scripts/sbs install
  4) Place your configuration file config.json in the directory /jffs/addons/sing-box-script instead of the template downloaded when installing the script.
  5) Configure the script according to Section III of this Readme by running the 'sbs setup' command in the router command line.

VIII. About the sing-box core.

 1. During the installation of the script, the latest stable release of the sing-box core is downloaded and installed by default from the developer's GitHub page https://github.com/SagerNet/sing-box/releases/latest.

 2. If instead of the original sing-box developer repository you want to use a custom repository (fork) with extended functionality of the sing-box core, you can specify and select it in the repository selection menu, which is located along the following path: menu 'sbs update' -> item 3 -> item 1. You can specify up to two custom repositories. For example, mine with integrated AmneziaWG support: Dr4tez/sing-box-mod (https://github.com/Dr4tez/sing-box-mod/releases). The code for adding AmneziaWG support to my repository is taken from the shtorm-7/sing-box-extended repository (https://github.com/shtorm-7/sing-box-extended/releases), which you can also add if you wish. The sing-box cores in it have more advanced functionality, but when using it, like any other third-party repositories, do not count on my support, since I cannot constantly monitor their code and guarantee their security and operability.
 An example of using AmneziaWG in wireguard endpoint, when using the sing-box core from the Dr4tez/sing-box-mod or shtorm-7/sing-box-extended repositories, is in the AmneziaWG_example.txt file on the page of this project https://github.com/Dr4tez/sing-box4asus

 3. If you want to use a different core version instead of the latest stable release of the sing-box core, you can select it in the core version selection menu, which is located at the following path: menu 'sbs update'->item 3->item 2. In this menu, you can select the latest stable release, the latest pre-release, or a specified version.
 In this menu, you can also set the search depth, for example '90', and the specified version, as well as the latest stable release or the latest pre-release, will be searched among the specified number of recent releases. If not specified, the default value is used - 30.
 After changing the core version, do not forget, if necessary, to change the config according to the Migration section (https://sing-box.sagernet.org/migration/) of the sing-box documentation.
