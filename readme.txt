
Script for running sing-box on Asus routers with Merlin firmware.

I. Nuances.
1. You should be able to create or at least modify configurations for sing-box to suit your needs. Documentation can be found at https://sing-box.sagernet.org/. A template of my configuration is installed along with the sing-box script.
2. Specifying DNS servers in the router's configuration file breaks the routing rules specified in this configuration. However, it works fine for me without specifying DNS servers—using the DNS configured in the router.
3. Your router should have a mounted flash drive with Entware installed, where we will install sing-box and all necessary components. Installing it in the router's internal memory is not recommended and often not possible due to its limitations, and is not considered.
4. You can experiment with the script and configurations. If you achieve notable successes, such as overcoming the above-mentioned nuances, please share them with me https://4pda.to/forum/index.php?showuser=1525408.

II. Installing sing-box.
Execute the following command in the router's console:
wget -O /jffs/scripts/sb-script-install https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sb-script-install && chmod 775 /jffs/scripts/sb-script-install && /jffs/scripts/sb-script-install
Instructions for further actions are displayed at the end of the installation.

III. What to change manually before the initial setup of the sing-box script.
1. After installing sing-box, you will have a directory /jffs/addons/sing-box containing my configuration template config.json. Before starting the initial setup of the sing-box script, at a minimum, you must fill in the fields marked with Xs in the configuration template with your values, or replace the configuration entirely with your own, taking into account the above-mentioned nuances. Note that my template uses my personal ruleset, which is loaded from my GitHub page (https://github.com/Dr4tez/my_domains). It may not contain the domains you need to unblock, and traffic goes to direct by default.
2. By default, the latest stable release of sing-box is installed. If you want a different version, you can replace the sing-box file in the /opt/root/sing-box directory with the version you need, just don't forget to give it execution rights and, if necessary, change the configuration according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.

IV. Initial script setup.
Before the first start of sing-box, after completing the previous steps, be sure to configure the script! To do this, execute the following command in the router's console:
sbs setup
In the field for entering the IP addresses of devices, be sure to enter your own. You can leave the specified routing table number 555.

V. Control commands.
If you want to completely stop the script and do not want the script to start automatically when the router reboots, execute the following command in the console:
sbs stop
You can see the full list of commands with their descriptions by executing the command sbs in the console.