A script to run sing-box on Asus routers with Merlin firmware and a flash drive with Entware.

I. Basics.
1. You should be able to create or at least edit sing-box configs for yourself. Documentation: https://sing-box.sagernet.org/. A template of my config is installed with the sing-box script.
2. Only routers with the following processor architectures are supported: ARMv8/AArch64 and ARMv7/AArch32.
3. If IPv6 is enabled in your router settings, it is not recommended to use this script, as it will likely not function as intended in most cases.
4. Your router must have a mounted flash drive with Entware installed on it. The sing-box core will be installed on it, and during its operation, a directory with UI and a cache file will be created there. Installing these components in the router's internal memory is not desirable and often impossible due to its limitations, and is not considered.
5. If you notice bugs in the script or can improve/optimize the script, please share this information with me.

II. Features of configuring sing-box on a router.
1. Generally, DNS servers and their rules are specified at the beginning of the sing-box configuration file (config.json). However, on a router, these settings are ignored for the sing-box tun interface due to the router's dnsmasq, which intercepts DNS requests. As a result, all DNS requests from devices whose traffic is routed through the sing-box tun interface are always directed to the DNS server specified in the router's settings. Nevertheless, DNS settings in the configuration file are still necessary for the proper functioning of inbounds, which act as proxy servers, such as mixed, they rely on these DNS settings.
2. It is not recommended to include clash_mods in the DNS rules within config.json. Under certain settings and actions, this can cause the sing-box process to quickly consume all available RAM and lead to the router freezing.
3. Do not use the '"auto_route": true' setting in config.json, it does not function correctly on the router and disrupts routing.
4. Do not use the '"strict_route": true' setting in config.json; it is pointless without '"auto_route": true' and can also cause loss of access to the router's command line and routing issues.
5. When configuring the script with the 'sbs setup' command, do not specify the entire router subnet instead of the device IP addresses, for example 192.168.50.0/24, this will disrupt the normal operation of the router.

III. Installing sing-box.
Run the following command in the router's command line:
wget -O /jffs/scripts/sbs https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sbs && chmod 775 /jffs/scripts/sbs && /jffs/scripts/sbs install
At the end of the installation, instructions for further actions will be displayed.

IV. About the sing-box core.
During installation, by default, the latest stable release of sing-box core from the developer's GitHub page https://github.com/SagerNet/sing-box/releases/latest is downloaded and installed. If you want to use a different version, you can replace the sing-box file in the /opt/root/sing-box directory with the one you need. Just don't forget to give it execute permissions and, if necessary, change the configuration file according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.

V. Initial setup and running the script.
After installing the script, before the first start of sing-box, be sure to configure it! To do this, run the following command in the router's command line:
sbs setup
1. First, you will be prompted to edit config.json (the sing-box configuration file) in the nano editor. If you do not agree to edit in nano, be sure to edit it in another convenient way (e.g., WinSCP) before proceeding to the next step. config.json is located in the /jffs/addons/sing-box-script directory. At a minimum, you should enter your values in the fields marked with Xs in config.json. Of course, you can replace the config with your own, but take into account the features of configuring the sing-box on the router, specified in section II.
   Note that this config.json template uses my personal rule set, which is loaded from my GitHub page (https://github.com/Dr4tez/my_domains). It may not contain the blocked domains you need. Traffic for the first TUN interface is routed according to the rules specified in this config.json - domains from the rule set and IP 31.131.253.250 go to the proxy tunnel, and everything else goes direct. Traffic for the second TUN interface by default goes entirely to the proxy tunnel.
2. Then, if your config.json specifies one or two TUN interfaces, you will be prompted to enter your devices' IP addresses for each of these interfaces. Traffic from the specified IP addresses will go through the corresponding sing-box TUN interfaces.
3. In the last step, if your config.json specifies one or two TUN interfaces, you will be prompted to change the routing table numbers for each of these interfaces. It is recommended to decline changing them, as the numbers indicated there are likely not used by your router. They may already be occupied only if you have set it up that way yourself, which means you understand how best to proceed in this case.
4. After this, you will be prompted to run the sing-box script. If you are ready, agree.

VI. Update.
To start the update, run the following command in the router's command line:
sbs update
When executed, the main sbs script and the sbs-monitor* script files will be updated, as well as the sing-box core, if you confirm its update. Your config.json will remain untouched, as will the script settings, since they are stored in a separate sbs-conf file.

VII. Management commands.
To start the sing-box script, run the following command in the router's command line:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, run the following command in the command line:
sbs stop
You can see a complete list of commands with their descriptions by running the following command in the command line:
sbs

*sbs-monitor- an auxiliary script that is active only during the operation of sing-box. It monitors and restores rules and routes created by the main script if they were deleted during certain system events.
