A script to run sing-box on Asus routers with Merlin firmware and Entware installed on a USB drive.

I. Basics.

 1. You should be able to create, or at least edit, configuration files for sing-box. Documentation: https://sing-box.sagernet.org/. My config file template is installed with the script.

 2. Only routers with the following processor architectures are supported: ARMv8/AArch64 and ARMv7/AArch32.

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
 Do not edit the config.json configuration file while sing-box is running. Make sure to stop it before doing so, otherwise bugs will appear that you will not be able to get rid of without certain knowledge.

 2. Then, to enter the script setup menu, run the command 'sbs setup'. But, you can get to this menu only if the tun interface is specified in your config.json, otherwise you have nothing to configure there, and you will only get a message about it.
  2.1 The first item in this menu is to configure the IP addresses of the devices whose traffic you want to route through the sing-box.
When entering IP addresses, you can enter the entire subnet in CIDR format, for example 192.168.50.0/24, then the next step will ask you to enter the IP addresses from this subnet for the devices whose traffic you want to exclude from the sing-box.
 Write the IP addresses in one line, separating them only with spaces.
  Attention! If you need access from WAN to any device in your router's network via port forwarding, do not add the IP address of this device when configuring the script, otherwise there will be no access. The same is true when adding an entire subnet - there will be no access from WAN via port forwarding to the router's web interface and to all devices in the subnet, except for those whose IP addresses you specify at the stage of entering IP addresses of exceptions.
  2.2 The second menu item is the selection of DNS servers for the sing-box.
  You can choose to either use the DNS servers configured in the router's web interface in the "WAN - Internet Connection" section, or use the DNS servers specified in the sing-box configuration file.
  After installing the script, the DNS servers configured in the router's web interface are selected by default.
  This is not a mandatory item unless you want to use DNS servers according to the DNS rules specified in the config.json.
  2.3 The third item in the script settings menu allows you to change the routing table number for the sing-box.
  These are not mandatory items. If you don't know why it is necessary, then you don't need it.
  2.4 When you select option 0 to exit the script setup menu, you will be prompted to run sing-box. If you are ready, agree.

IV. Script management commands.
To start the sing-box script, run the following command in the router's command line:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, run the following command:
sbs stop
To remove the script and all the results of its activity, run the following command:
sbs remove
You can see a complete list of commands with their descriptions by running the following command:
sbs

V. Features of configuring sing-box on a router.
Here are listed the conditions that must be observed when creating sing-box configuration files for the router, as well as the necessary settings in the router web interface.

 1. General conditions:
  1.1 Do not use the '"auto_route": true' setting in config.json, it does not function correctly on the router and disrupts routing.
  1.2 Do not use the '"strict_route": true' setting in config.json, this may cause loss of access to the router's command line and routing problems.
  1.3 Do not use the setting '"auto_detect_interface": true' in config.json, on the router it incorrectly detects the interface for direct outbound, which causes the lack of access through the sing-box to resources in the home network.
  1.4 The script only supports one tun interface, so do not add more than one to config.json.

In the script setup menu, which is opened by the command 'sbs setup' in the router command line, there is an item for selecting DNS servers for sing-box - DNS servers configured in the router web interface, or DNS servers specified in the config.json.
 2. For sing-box to work with DNS servers configured in the router's web interface, the following conditions must be met:
  2.1 Through the 'sbs setup' menu, the use of the router's DNS must be selected;
  2.2 The General conditions listed in paragraph 1 must also be observed.
 3. For sing-box to work with DNS servers specified in the config.json, all of the following conditions must be met:
  3.1 Through the 'sbs setup' menu, the use DNS of the sing-box configuration file must be selected;
  3.2 In the "LAN - DHCP Server" section of the router's web interface:
   1) The "DNS Server 1" and "DNS Server 2" fields must be empty,
   2) The "Advertise router's IP in addition to user-specified DNS" option must be set to "Yes",
   3) In the "DNS Server (Optional)" fields for the devices whose traffic is routed through sing-box, "Default" should be specified;
  3.3 In the "LAN - DNS Director" section of the router's web interface, there should be no settings for the devices whose traffic is routed through sing-box.
  3.4 The following blocks must be present in config.json:
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
  3.5 The General conditions listed in paragraph 1 must also be observed.
  The listen_port value does not necessarily have to be 55553, if this port is already occupied by your router for other purposes, you can enter any free 4- or 5-digit port instead.
  My config.json template, downloaded when installing the script, contains all these blocks.

 4. The instructions for setting up the 3x-ui panel that I came across on the Internet do not mention one important nuance- if you want your DNS requests to be processed by DNS servers specified in the sing-box configuration file, then in the 3x-ui panel, in the connection settings, turn off Sniffing, otherwise DNS requests sent to the proxy tunnel will be processed by DNS servers configured on the server or in the 3x-ui panel itself.

VI. About the sing-box core.
During installation, by default, the latest stable release of sing-box core from the developer's GitHub page https://github.com/SagerNet/sing-box/releases/latest is downloaded and installed. If you want to use a different core version, you can replace the core file named sing-box in the /opt/root/sing-box directory with the one you need. Just don't forget to give it execute permissions and, if necessary, change the configuration file according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.
