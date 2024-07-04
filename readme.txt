Script for running sing-box on Asus routers with Merlin firmware.
First, read the readme file completely before proceeding.

I. Nuances.
1.You must be able to create, or at least customize, configurations for sing-box. Documentation is available at https://sing-box.sagernet.org/. A template of my configuration is included with the sing-box script.
2.Adding DNS servers in the router's configuration breaks the routing rules specified in this configuration. However, it works fine for me without specifying DNS servers—using the DNS configured on the router.
3.Your router must have a mounted flash drive with Entware installed, where we will install sing-box and all necessary components. Installation in the router's internal memory is not recommended and often not possible due to its limitations, and thus is not considered.
4.Feel free to experiment with the script and configurations. If you achieve noteworthy successes, such as overcoming the nuances mentioned above, please share them with us.

II. Installing sing-box.
Execute the following command on the router's console:
wget -O /jffs/scripts/sing-box_script-install https://raw.githubusercontent.com/Dr4tez/sing-box4asus/main/sing-box_script-install && chmod 775 /jffs/scripts/sing-box_script-install && /jffs/scripts/sing-box_script-install
Upon installation completion, follow the displayed instructions and command list for managing the sing-box script. Keep them handy for reference.

III. Manual adjustments before initial sing-box setup.
1.After installing sing-box, a directory /sing-box/ will appear in the /root/ directory of your mounted flash drive with Entware. It contains a config.json template of my configuration. Before initiating the initial setup of the sing-box script, you must at least fill in your own values in the template config's placeholder fields or replace the config entirely with your own, considering the aforementioned nuances. Note that it includes my personal rule set loaded from my GitHub page (https://github.com/Dr4tez/my_domains), which may not include domains you wish to block, with default traffic going to dir.
2.By default, the latest stable release of sing-box is installed. If you want a different version, replace the sing-box file in the /sing-box/ directory with your desired version. Ensure it has execution permissions and, if necessary, modify the config according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.

IV. Initial setup of the script.
Before the first run of sing-box, after completing the previous steps, it's mandatory to configure the script! To do this, execute the following command in the router's console:
***/sing-box/sing-box.sh setup
During the script's operation, choose options offered during the process. In the input field for device IP addresses, enter your own. You can leave the routing table number as the existing 222. For other questions you may not fully understand, you can simply answer 'Yes' by entering 2.
In this command and subsequent commands, replace *** with your path to the /root/ directory on the flash drive with Entware. You can see the full command in the console at the end of installation (Section II).

V. Script management commands.
You have seen the full correct commands at the end of installation (Section II). Throughout this readme, replace the entire path to the /root/ directory in all commands with *** because I cannot know it, and the script determines it automatically.
1.To reconfigure the script in the router's console:
***/sing-box/sing-box.sh setup
To start sing-box:
***/sing-box/sing-box.sh start
To stop sing-box:
***/sing-box/sing-box.sh stop
To restart sing-box:
***/sing-box/sing-box.sh restart
2.The script configuration mode (***/sing-box/sing-box.sh setup) does not affect the current session of sing-box. To begin using sing-box with the new script settings, start it (***/sing-box/sing-box.sh start) or restart it (***/sing-box/sing-box.sh restart) if it's already running. If changes have been made to the config, start the script in setup mode first to make adjustments if needed, then start or restart the script.
3.After executing the command:
***/sing-box/sing-box.sh start
or
***/sing-box/sing-box.sh restart
the script works correctly until you close the console. Therefore, after starting or restarting the script and closing the console, reboot the router. This way, the script will automatically start working correctly without the console.
4.If you want to completely stop the script from running and prevent it from starting automatically upon router reboot, execute the following command in the console:
***/sing-box/sing-box.sh stop
After this command, rebooting the router is not necessary.

VI. Complete removal of the script.
Execute the following command in the router's console:
***/sing-box/sing-box.sh stop
Then execute:
rm -r ***/sing-box /jffs/scripts/sing-box_script-install