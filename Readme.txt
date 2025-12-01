A script to run sing-box on Asus routers with Merlin firmware and Entware installed on a USB drive.

I. Basics.

 1. You should be able to create configuration files for sing-box. Documentation: https://sing-box.sagernet.org/.

 2. Only routers with ARM/AArch processor architectures are supported (you can find out by running the 'uname -m' command in the router command line) and a system core version not lower than 4.1 (you can find out by running the 'uname -r' command in the router command line). If the router's CPU architecture or the system core version does not meet these requirements, the script installation will be cancelled.

 3. If IPv6 is enabled in your router settings, it is not recommended to use this script, as it will likely not function as intended in most cases.

 4. A USB drive with Entware installed must be connected to your router. The sing-box core will be permanently located in it, and temporary files will be periodically created and deleted during the installation of the script and its updates. Installing these components in the internal memory of the router is not desirable, and sometimes impossible due to its limitations, and is not considered.

 5. If you notice bugs in the script or can improve/optimize the script, please share this information with me.

II. Installing the script.
Run the following command in the router's command line:
wget -O /jffs/scripts/sbs https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sbs && chmod 775 /jffs/scripts/sbs && /jffs/scripts/sbs install

III. Initial setup and running of the script.
After installing the script, before the first start of sing-box, be sure to configure it! To do this, follow these steps.

 1. First, you need to edit the sing-box configuration file template, located at /jffs/addons/sing-box-script/config.json.
 You can do this in the menu called by the 'sbs config' command, selecting the first item there. You can also do this in any other way convenient for you, for example, using WinSCP.
 At a minimum, you should enter your values ​​​​in the config.json template in the lines with X's. Please note that it uses my personal ruleset, downloaded from my GitHub page (https://github.com/Dr4tez/my_domains), it may not contain the blocked domains you need. According to this template, traffic of devices routed via sing-box is routed according to the following rules: domains contained in rule_set "my_domains" go to the proxy tunnel, and everything else goes to direct.
 Of course, you can completely replace the template with your own configuration file, the main thing is that it has the name config.json, and it must comply with the sing-box configuration features on the router, specified in section V of this Readme.
 Do not edit the config.json configuration file while sing-box is running. Make sure to stop it before doing so, otherwise bugs will appear that you will not be able to get rid of without certain knowledge. But if you use the first point of menu 'sbs config' to edit config.json, sing-box does not need to be stopped first, it will be stopped automatically.

 2. Then, to enter the menu for setting up devices routing via sing-box, run the command 'sbs setup'. But, you can get to this menu only if your config.json has tun or tproxy interface, otherwise there is no point in setting anything up there, and you will only get a message about it.
  2.1 The first point in this menu is "1. Configuring IP addresses of devices for standard routing via sing-box."
  Within this point there is a submenu with two more points: "1. Set IP addresses for routing via sing-box." and "2. Set IP addresses to exclude from routing via sing-box." Point 2 will be available for entering values ​​only if at least one subnet in CIDR format was specified in point 1.
  2.2 The second point in this menu is "2. Configuring IP addresses of devices for routing via sing-box using fakeip."
  Within this point there is a submenu with two more points: "1. Set IP addresses for routing via sing-box." and "2. Set IP addresses to exclude from routing via sing-box." Point 2 will be available for entering values ​​only if at least one subnet in CIDR format was specified in point 1.
  For more information about the settings specified in points 2.1 and 2.2 of this section, see section IV of this readme.
  2.3 The third point in this menu is "3. Optional expert settings."
  Within this point there is a submenu with two more points: "1. Change the routing table number for sing-box." and "2. Change fw-mark for sing-box."
  Both points in this submenu are optional and are for those who need them. If you do not know what they are for and what they should be, then do not touch them.
  2.4 To exit the menu for setting up devices routing via sing-box, press Enter without entering any values, and if sing-box is stopped, you will be prompted to start sing-box. If you are ready, agree.

IV. Configuring IP addresses of devices to route them via sing-box using standard routing or using fakeip.
The script has the ability to route device IP addresses via sing-box using standard routing, using the first menu point 'sbs setup', or specify these IP addresses for routing via sing-box using fakeip, using the second menu point 'sbs setup'. Please note that the second point (2. Configuring IP addresses of devices for routing via sing-box using fakeip.) is always available for editing values, but the script will apply it when starting sing-box only if your config.json configuration file contains fakeip settings.
Different situations may require different variants of the config.json configuration file, which may require advanced skills in compiling them.
Below are 4 variants for using configuration file templates for sing-box versions 1.12.*, which you can find on the project page https://github.com/Dr4tez/sing-box4asus. If you want to use one of them with other sing-box core versions, don't forget to change the configuration file according to the Migration section of the sing-box documentation https://sing-box.sagernet.org/migration/ if necessary.

 1. If you want to route the traffic of selected devices via sing-box using only standard routing, then go to the 'sbs setup' menu using the appropriate command in the router command line, then go to the submenu "1. Configuring IP addresses of devices for standard routing via sing-box.", in the first point of which specify the IP addresses of these devices.
 If you specify at least one subnet in CIDR format in the first point of this submenu, for example, 192.168.50.0/24, then in the second point you can enter IP addresses from this subnet that should not be routed via sing-box, for example, a single IP address 192.168.50.1 or a subnet 192.168.50.0/28, which must be smaller than the subnet specified in the first point of this submenu. Enter single IP addresses and/or subnets on a single line, separated only by spaces. This paragraph also applies to other template variants.
 Attention! If you need access from the WAN to a device on your router's network via port forwarding, do not add that device's IP address to the standard routing via sing-box, otherwise it will not be accessible from the WAN. The same applies if you add the entire router subnet to the standard routing via sing-box. WAN access via port forwarding will not be possible to the router's web interface or to any devices in this subnet, except for those whose IP addresses you specify in point "2. Set IP addresses to exclude from routing via sing-box."
The sing-box configuration file template named config.json, which is automatically downloaded during script installation, is suitable for this variant.

 2. If you want to route the traffic of selected devices via sing-box using only fakeip, then go to the 'sbs setup' menu using the appropriate command in the router command line, then go to the submenu "2. Configuring IP addresses of devices for routing via sing-box using fakeip.", in the first point of which specify the IP addresses of these devices.
 For this variant, the sing-box configuration file template is called config-2.json. If you want to use it, simply copy its contents into the config.json file downloaded during script installation, replacing its contents.

 3. If you want to route subnet traffic via sing-box using standard routing, and route some IP addresses from this subnet via sing-box using fakeip, then specify this subnet in the first point of the submenu "1. Configuring IP addresses of devices for standard routing via sing-box.", and specify some IP addresses in the first point of the submenu "2. Configuring IP addresses of devices for routing via sing-box using fakeip."
 For this variant, the sing-box configuration file template is called config-3.json. If you want to use it, simply copy its contents into the config.json file downloaded during script installation, replacing its contents. Replace the IP addresses 192.168.50.14 and 192.168.50.15 in this template with the IP addresses of the devices you want to route via sing-box using fakeip.

 4. If you want to route subnet traffic via sing-box using fakeip, and route some IP addresses from this subnet via sing-box using standard routing, then specify this subnet in the first point of the submenu "2. Configuring IP addresses of devices for routing via sing-box using fakeip.", and specify some IP addresses in the first point of the submenu "1. Configuring IP addresses of devices for standard routing via sing-box."
 For this variant, the sing-box configuration file template is called config-4.json. If you want to use it, simply copy its contents into the config.json file downloaded during script installation, replacing its contents. Replace the IP addresses 192.168.50.14 and 192.168.50.15 in this template with the IP addresses of the devices you want to route via sing-box using standard routing.

V. Features of configuring sing-box on a router.
Here are listed the conditions that must be observed when creating sing-box configuration files for the router, as well as the necessary settings in the router web interface.

 1. General conditions:
  1.1 Do not use the following functions in your config.json: '"auto_route": true', '"auto_detect_interface": true' and others that contain the word 'auto' in their name. They do not work correctly in the router and disrupt routing.
  1.2 Do not use the '"strict_route": true' setting in config.json, this may cause loss of access to the router's command line and routing problems.
  1.3 The script only supports one tun or tproxy interface, so do not add more than one of them to config.json.

 2. For sing-box to work with DNS servers specified in the config.json, all of the following conditions must be met:
  2.1 In the "LAN - DHCP Server" section of the router's web interface:
   1) The "DNS Server 1" and "DNS Server 2" fields must be empty,
   2) The "Advertise router's IP in addition to user-specified DNS" option must be set to "Yes",
   3) In the "DNS Server (Optional)" fields for the devices whose traffic is routed through sing-box, "Default" should be specified;
  2.2 In the "LAN - DNS Director" section of the router's web interface, there should be no settings for the devices whose traffic is routed through sing-box.

VI. Configuring memory limits.
Some sing-box users have reported that the sing-box process gradually consumes all available RAM on their routers, causing router performance to slow down. To prevent this, the script, since version 2.4.0, includes a menu for configuring RAM usage limits, accessed with the 'sbs limit' command.

 1. For most users, specifying the limit in the option "1. Simple setup." is sufficient. As this limit is approached, the GO garbage collector in the sing-box core will begin to more actively free up RAM occupied but not actually used by the sing-box process. If the RAM used by the sing-box process reaches the set limit, the process will restart.

 2. For experts familiar with the GO garbage collector and related GO language parameters, it is possible to manually specify any values ​​in the submenu of point "2. Optional expert settings." The first point in this submenu sets a hard limit, the size of which represents the unique memory used by the sing-box process, i.e., the difference between its RES and SHR. When the sing-box process reaches the hard limit, it is restarted. The specifics of the second and third points of this submenu should be familiar to experts.
 As the unique memory used by the sing-box process approaches the GOMEMLIMIT value, the router's CPU load will begin to increase. To ensure that the sing-box process restarts before excessive CPU load occurs, it is recommended to use GOMEMLIMIT in conjunction with the "Hard limit" and set the GOMEMLIMIT value approximately 10% higher than the "Hard limit."

VII. Script management commands.
To start the sing-box script, run the following command in the router's command line:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, run the following command:
sbs stop
To remove the script and all the results of its activity, run the following command:
sbs remove
You can see a complete list of commands with their descriptions by running the following command:
sbs

VIII. Updating the script.

 1. Since script version 1.8, updating to the latest version is done through the menu called by the command 'sbs update', in which you just need to select the first point.

 2. The only way to correctly update to the latest version of the script from versions 1.7 and older is to completely reinstall the script.

IX. About the sing-box core.

 1. During the installation of the script, the latest stable release of the sing-box core is downloaded and installed by default from the sing-box developer's page https://github.com/SagerNet/sing-box/releases/latest

 2. If instead of the original sing-box developer repository you want to use a custom repository (fork) with extended functionality of the sing-box core, you can specify and select it in the repository selection submenu, which is located along the following path: menu 'sbs update' -> point 3 -> point 1.
 An example of specifying a custom repository is: shtorm-7/sing-box-extended Its full address is: https://github.com/shtorm-7/sing-box-extended/ This fork has integrated support for AmneziaWG, XHTTP, and some other enhancements not found in the original repository. However, i do not control the code of the shtorm-7/sing-box-extended repository, as well as any other, and do not guarantee its security and functionality.

 3. If you want to use a different core version instead of the latest stable release of the sing-box core, you can select it in the core version selection menu, which is located at the following path: menu 'sbs update' -> point 3 -> point 2. In this menu, you can select the latest stable release, the latest pre-release, or a specified version.
 In this menu, you can also set the search depth, for example '90'. As a result, the given version, as well as the latest stable release or the latest pre-release, will be searched among the given number of recent releases. If not specified, the default value is used- 30.
 After changing the core version, do not forget, if necessary, to change the configuration file according to the Migration section (https://sing-box.sagernet.org/migration/) of the sing-box documentation.
