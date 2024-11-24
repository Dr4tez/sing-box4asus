A script to run sing-box on Asus routers with Merlin firmware and Entware installed on a USB drive.

I. Basics.

 1. You should be able to create configuration files for sing-box. Documentation: https://sing-box.sagernet.org/.

 2. Only routers with ARM/AArch processor architectures are supported (you can find out by running the 'uname -m' command in the router command line) and a system kernel version not lower than 4.1 (you can find out by running the 'uname -r' command in the router command line).

 3. If IPv6 is enabled in your router settings, it is not recommended to use this script, as it will likely not function as intended in most cases.

 4. A USB drive with Entware installed must be connected to your router. The sing-box core will be installed on it, and during its operation, a directory with UI and a cache file will be created there. Installing these components in the router's internal memory is not desirable and often impossible due to its limitations, and is not considered.

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

 2. Then, to enter the script setup menu, run the command 'sbs setup'. But, you can get to this menu only if the tun interface is specified in your config.json, otherwise you have nothing to configure there, and you will only get a message about it.
  2.1 The first item in this menu is to configure the IP addresses of the devices whose traffic you want to route through the sing-box.
  2.2 If your config.json file contains settings for working via fakeip, then the second point in the script settings menu will be setting up the IP addresses of devices that should work via fakeip.
  For more information about the settings specified in points 2.1 and 2.2 of this section, see section IV of this readme.
  2.3 The next point in the script setup menu will be changing the routing table number for the sing-box.
  These are not mandatory items. If you don't know why it is necessary, then you don't need it.
  2.4 When you select option 0 to exit the script setup menu, you will be prompted to run sing-box. If you are ready, agree.

IV. About configuring device IP addresses to route them via regular routing or fakeip.
The script has the ability to route device IP addresses via regular routing (using the first point of menu 'sbs setup'), and/or specify them for using fakeip (using the second point of menu 'sbs setup', if the config.json file contains fakeip settings). Different options require different, appropriately composed sing-box configuration files, which requires advanced skills in compiling them. You can find templates for all the options listed below on the page of this project https://github.com/Dr4tez/sing-box4asus.

 1. If you want to route device IP addresses only via regular routing, then specify them only in the first point of the 'sbs setup' menu. If you specify a subnet in CIDR format here, for example 192.168.50.0/24, then after entering it, a prompt will appear to enter exception IP addresses that should not be routed via sing-box.
 Write IP addresses in one line, separating them only with spaces. This also applies to subsequent variants.
 Attention! If you need access from WAN to any device in your router's network via port forwarding, do not add the IP address of this device in the first point of the 'sbs setup' menu, otherwise there will be no access. The same is true when adding an entire subnet - there will be no access from WAN via port forwarding to the router's web interface and to all devices in the subnet, except for those whose IP addresses you specify at the stage of entering IP addresses of exceptions.
 For this option, the sing-box configuration file template named config.json, which is automatically downloaded when installing the script, is suitable.

 2. If you want to configure IP addresses to work only via fakeip, then specify them only in the second point of the 'sbs setup' menu. If you specify a subnet in CIDR format here, then after entering it, a prompt will appear to enter IP addresses of exceptions that should not work through fakeip.
 For this option, the sing-box configuration file template is called config-2.json. If you want to use it, just copy its contents into the config.json file downloaded during script installation, replacing its contents.

 3. If you want to route the entire subnet through regular routing, specifying it in the first point of the 'sbs setup' menu, and configure some IP addresses from it to work through fakeip, then you need to specify these IP addresses in the exceptions of regular routing and specify them in the second point.
 For this option, the sing-box configuration file template is called config-3.json. If you want to use it, just copy its contents into the config.json file downloaded during script installation, replacing its contents. Instead of IP addresses 192.168.50.14 and 192.168.50.15 in this configuration file, you can insert your IP addresses of the devices that you want to configure to work via fakeip.

 4. If you want to configure the entire subnet via fakeip by specifying it in the second point of the 'sbs setup' menu, and send some IP addresses from it via regular routing, then it is enough to specify these IP addresses only in the first point.
 For this option, the sing-box configuration file template is called config-4.json. If you want to use it, just copy its contents into the config.json file downloaded during script installation, replacing its contents. Instead of IP addresses 192.168.50.14 and 192.168.50.15 in this configuration file, you can insert your IP addresses of devices that you want to route via the sing-box using regular routing.

V. Features of configuring sing-box on a router.
Here are listed the conditions that must be observed when creating sing-box configuration files for the router, as well as the necessary settings in the router web interface.

 1. General conditions:
  1.1 Do not use the '"auto_route": true' setting in config.json, it does not function correctly on the router and disrupts routing.
  1.2 Do not use the '"strict_route": true' setting in config.json, this may cause loss of access to the router's command line and routing problems.
  1.3 Do not use the setting '"auto_detect_interface": true' in config.json, on the router it incorrectly detects the interface for direct outbound, which causes the lack of access through the sing-box to resources in the home network.
  1.4 The script only supports one tun interface, so do not add more than one to config.json.

 2. For sing-box to work with DNS servers specified in the config.json, all of the following conditions must be met:
  2.1 In the "LAN - DHCP Server" section of the router's web interface:
   1) The "DNS Server 1" and "DNS Server 2" fields must be empty,
   2) The "Advertise router's IP in addition to user-specified DNS" option must be set to "Yes",
   3) In the "DNS Server (Optional)" fields for the devices whose traffic is routed through sing-box, "Default" should be specified;
  2.2 In the "LAN - DNS Director" section of the router's web interface, there should be no settings for the devices whose traffic is routed through sing-box.
  2.3 The following blocks must be present in config.json:
   1) In the inbounds section:
    {
      "type": "direct",
      "tag": "dns4tunin",
      "listen": "0.0.0.0",
      "listen_port": 55553,
      "override_port": 53
    }
   This block is an inbound direct interface named dns4tunin. It accepts DNS requests on port 55553 from devices whose traffic is routed through the sing-box, and redirects them to port 53.
   2) In the route rules section:
    {
      "inbound": "dns4tunin",
      "outbound": "dns-out"
    }
   This block sends dns requests received by the inbound direct interface dns4tunin for processing by DNS rules.
  The listen_port value does not necessarily have to be 55553, if this port is already occupied by your router for other purposes, you can enter any free 4- or 5-digit port instead.
  These blocks are present in my config.json template, which is downloaded when installing the script.

 3. The instructions for setting up the 3x-ui panel that I came across on the Internet do not mention one important nuance- if you want your DNS requests to be processed by DNS servers specified in the sing-box configuration file, then in the 3x-ui panel, in the connection settings, turn off Sniffing, otherwise DNS requests sent to the proxy tunnel will be processed by DNS servers configured on the server or in the 3x-ui panel itself.

VI. Script management commands.
To start the sing-box script, run the following command in the router's command line:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, run the following command:
sbs stop
To remove the script and all the results of its activity, run the following command:
sbs remove
You can see a complete list of commands with their descriptions by running the following command:
sbs

VII. About the sing-box core.
During installation, by default, the latest stable release of sing-box core from the developer's GitHub page https://github.com/SagerNet/sing-box/releases/latest is downloaded and installed. If you want to use a different core version, you can replace the core file named sing-box in the /opt/root/sing-box directory with the one you need. Just don't forget to give it execute permissions and, if necessary, change the configuration file according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.
