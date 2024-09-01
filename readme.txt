A script to run sing-box on Asus routers with Merlin firmware and Entware installed on a USB drive.

I. Basics.
1. You should be able to create, or at least edit, configuration files for sing-box. Documentation: https://sing-box.sagernet.org/. My config file template is installed with the script.
2. Only routers with the following processor architectures are supported: ARMv8/AArch64 and ARMv7/AArch32.
3. If IPv6 is enabled in your router settings, it is not recommended to use this script, as it will likely not function as intended in most cases.
4. A USB drive with Entware installed must be connected to your router. The sing-box core will be installed on it, and during its operation, a directory with UI and a cache file will be created there. Installing these components in the router's internal memory is not desirable and often impossible due to its limitations, and is not considered.
5. If you notice bugs in the script or can improve/optimize the script, please share this information with me.

II. Features of configuring sing-box on a router.
1. Generally, DNS servers and their rules are specified at the beginning of the sing-box configuration file (config.json). However, on a router, these settings are ignored for the sing-box tun interface due to the router's dnsmasq, which intercepts DNS requests. As a result, all DNS requests from devices whose traffic is routed through the sing-box tun interface are always directed to the DNS server specified in the router's settings. Nevertheless, DNS settings in the configuration file are still necessary for the proper functioning of inbounds, which act as proxy servers, such as mixed, they rely on these DNS settings.
2. It is not recommended to include clash_mods in the DNS rules within config.json. Under certain settings and actions, this can cause the sing-box process to quickly consume all available RAM and lead to the router freezing.
3. Do not use the '"auto_route": true' setting in config.json, it does not function correctly on the router and disrupts routing.
4. Do not use the '"strict_route": true' setting in config.json; it is pointless without '"auto_route": true' and can also cause loss of access to the router's command line and routing issues.

III. Installing the script.
Run the following command in the router's command line:
wget -O /jffs/scripts/sbs https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sbs && chmod 775 /jffs/scripts/sbs && /jffs/scripts/sbs install

IV. Initial setup and running of the script.
After installing the script, before the first start of sing-box, be sure to configure it! To do this, follow these steps. 
1. First, you need to edit the sing-box configuration file located at /jffs/addons/sing-box-script/config.json. You can do this in the menu called by the 'sbs edit' command, selecting the first item there. You can also do this in any other way convenient for you, for example, using WinSCP. At a minimum, you must enter your values ​​​​in the lines with X's. Please note that this config.json uses my personal ruleset, downloaded from my GitHub page (https://github.com/Dr4tez/my_domains), it may not contain the blocked domains you need. Traffic for the first TUN interface is routed according to the rules specified in this config.json - domains from the ruleset and IP 31.131.253.250 go to the proxy tunnel, and everything else goes to direct. Traffic for the second TUN interface by default goes entirely to the proxy tunnel. Of course, you can replace the configuration file with your own, the main thing is that it has the name config.json, and it must comply with the sing-box configuration features on the router specified in section II. 
2. Then, to enter the script setup menu, run the 'sbs setup' command. If one or two TUN interfaces are specified in your config.json, the menu will also contain one or two first items for configuring the IP addresses of devices whose traffic you want to route through the corresponding TUN interface of the sing-box. When entering IP addresses, you can enter the entire subnet in CIDR format, for example 192.168.50.0/24, then the next step will ask you to enter IP addresses from this subnet for devices whose traffic you want to exclude from the corresponding TUN interface of the sing-box. At each step, enter the required IP addresses in one line, separating them only with spaces.
Attention! If you need direct access from the WAN to certain device in your router's network via port forwarding, do not add the IP address of this device when configuring the script, otherwise there will be no access. The same is true when adding the entire subnet - there will be no direct access from the WAN to the router's web interface and to all devices except those whose IP addresses you specified at the stage of entering the IP addresses of exceptions.
3. If your config.json specifies one or two TUN interfaces, the script settings menu will also have one or two items for changing the routing table numbers for these TUN interfaces. These are optional items. If you don't know why you need this, then you don't need it.
4. Also in the script settings menu, you can edit the script settings file in the nano editor by selecting the item with the corresponding name. This is not a mandatory item. In it, you can manually do everything described in the two previous items. For some, this may be more convenient if you only need to delete some of the IP addresses from the list, or, conversely, add some addresses to the existing lists. But you must understand the structure of the file and what can be entered where, so as not to disrupt the routing. The file contains explanations for this. If you are not sure, then it is better not to use this tool.
5. When you select the item to exit the script settings menu, you will be prompted to run sing-box. If you are ready, agree.

V. About the sing-box core.
During installation, by default, the latest stable release of sing-box core from the developer's GitHub page https://github.com/SagerNet/sing-box/releases/latest is downloaded and installed. If you want to use a different version, you can replace the sing-box file in the /opt/root/sing-box directory with the one you need. Just don't forget to give it execute permissions and, if necessary, change the configuration file according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.

VI. Script management commands.
To start the sing-box script, run the following command in the router's command line:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, run the following command:
sbs stop
To remove the script and all the results of its activity, run the following command:
sbs remove
You can see a complete list of commands with their descriptions by running the following command:
sbs
