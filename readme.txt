Script to run sing-box on Asus routers with Merlin firmware and a flash drive with Entware.

I. Nuances.
1. You must be able to create, or at least edit for yourself, configurations for sing-box. Documentation is available at https://sing-box.sagernet.org/. A template of my config is installed along with the sing-box script.
2. Your router must have a mounted flash drive with Entware installed on it. The sing-box core will be installed in it, and during its operation, a directory with UI and a cache file will be created there as well. Installing these components into the router's internal memory is undesirable and often impossible due to its limitations, and is not considered.
3. Specifying DNS servers in the sing-box configuration on the router breaks the routing rules specified in this configuration. However, it works fine for me without specifying DNS servers in the config, while using the DNS set up in the router.
4. If you notice bugs in the script's operation and/or can improve/optimize the script, please share this information with me here.

II. Installing sing-box.
Execute the following command in the router's console:
wget -O /jffs/scripts/sbs https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sbs && chmod 775 /jffs/scripts/sbs && /jffs/scripts/sbs install
Instructions for further actions will be displayed at the end of the installation.

III. About the sing-box core.
During the installation, the latest stable release of sing-box from the developer's GitHub page https://github.com/SagerNet/sing-box/releases/latest is downloaded and installed by default. If you want to use another version, you can replace the sing-box file in the /opt/root/sing-box directory with the one you need. Just don't forget to make it executable and, if necessary, modify the config according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.

IV. Initial script setup.
After installing the script, be sure to configure it before starting sing-box for the first time! To do this, execute the following command in the router's console:
sbs setup
1. Firstly, during the execution of the command, be sure to enter the IP addresses of the devices whose traffic you want to route through sing-box.
2. Then you will be prompted to edit the config.json (sing-box configuration file) in the nano editor. If you do not agree to edit in nano, be sure to edit it in another convenient way (e.g., WinSCP) before starting sing-box for the first time. The config.json file is located in the /jffs/addons/sing-box-script directory. At a minimum, you must enter your values in the fields with X's in the config template. Of course, you can replace the config with your own, but considering the nuance #3 mentioned above. Note that my template uses my personal rule set, downloaded from my GitHub page (https://github.com/Dr4tez/my_domains), it may not have the blocked domains you need, and traffic goes directly by default.
3. You can leave the specified routing table number as 555.

V. Updating.
To start the update, execute the following command in the router's console:
sbs update
This will update the main script files sbs-ru, sbs-monitor* script, and the sing-box core if you confirm its update. Your config.json will remain untouched, as will the script settings, since they are stored in a separate sbs-conf file.

VI. Management commands.
To start the sing-box script, execute the following command in the router's console:
sbs start
If you want to completely stop the script and do not want it to start automatically when the router reboots, execute the following command in the console:
sbs stop
You can see the full list of commands with their descriptions by executing the following command in the console:
sbs

*sbs-monitor- auxiliary script that is active only during the operation of sing-box. It monitors and restores the rules and routes created by the main script if they were deleted during certain system events.