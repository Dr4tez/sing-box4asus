
Script for running sing-box on Asus routers with Merlin firmware.

I. Details.
1. You should be able to create or at least edit configs for sing-box. Documentation: https://sing-box.sagernet.org/. A template of my config is attached.
2. Setting DNS servers in the router config breaks the routing rules set in this config. However, it works fine without specifying DNS servers as it uses the DNS configured on the router.
3. It's better to install on a flash drive with Entware. You can install it in the /jffs/ directory, but the config will not work if it contains the cache_file section in the experimental section. Further instructions assume installation on a flash drive with Entware.
4. You can experiment with the script and configs. If you achieve noteworthy success, such as resolving the mentioned issues, please share them with me at https://4pda.to/forum/index.php?showuser=1525408.

II. Extracting the script archive.
1. If you are reading this readme, you have already extracted the top layer of the archive and have this readme.txt file and another archive sing-box-script.tar.gz. Transfer the sing-box-script.tar.gz archive to the /root/ directory on the flash drive with Entware, for example using WinSCP. My path is /mnt/entware/entware/root/, your path may be different, but it must be the /root/ directory on the mounted flash drive with Entware installed. Everywhere in this readme where you see the path /mnt/entware/entware/root/, replace it with your path!
2. Execute the following command in the router console to extract the sing-box-script.tar.gz archive into the /mnt/entware/entware/root/ directory on the flash drive with Entware:
tar -xvpzf /mnt/entware/entware/root/sing-box-script.tar.gz -C /mnt/entware/entware/root/
3. After completing the previous step, you will have a /sing-box/ directory with the necessary files inside in your /mnt/entware/entware/root/ directory on the flash drive with Entware. They will immediately have the necessary permissions.

III. Manual changes.
1. In the config.json file, make the necessary changes as it is a template based on my config. Note that it uses my personal ruleset loaded from my GitHub page (https://github.com/Dr4tez/my_domains). It may not have the domains you need to block, and the default traffic goes to direct.
2. By default, it uses sing-box version 1.10.0-alpha.18-linux-arm64. If you want a different version, you can replace the sing-box file in the sing-box folder with the one you need, just don't forget to give it execution permissions and, if necessary, modify the config according to the Migration section (https://sing-box.sagernet.org/migration/) in the sing-box documentation.

IV. Initial script setup.
Before the first start of sing-box, after completing the previous steps, you must configure the script! To do this, run the following command in the router console:
/mnt/entware/entware/root/sing-box/sing-box.sh setup
and choose from the options presented during the script execution. After finishing, you can proceed to the next section.

V. Script management commands.
1. In the router console, to reconfigure the script, execute:
/mnt/entware/entware/root/sing-box/sing-box.sh setup
To start sing-box, execute:
/mnt/entware/entware/root/sing-box/sing-box.sh start
To stop sing-box, execute:
/mnt/entware/entware/root/sing-box/sing-box.sh stop
To restart sing-box, execute:
/mnt/entware/entware/root/sing-box/sing-box.sh restart
2. The script setup mode (/mnt/entware/entware/root/sing-box/sing-box.sh setup) does not affect the current sing-box session. To start sing-box with the new script settings, start it (/mnt/entware/entware/root/sing-box/sing-box.sh start) or restart it (/mnt/entware/entware/root/sing-box/sing-box.sh restart) if it is already running. If you have made changes to the config, first run the script in setup mode to make necessary changes, then start or restart the script if it is already running.
3. After executing the command
/mnt/entware/entware/root/sing-box/sing-box.sh start
or
/mnt/entware/entware/root/sing-box/sing-box.sh restart
the script will work correctly until you close the console. Therefore, after starting or restarting the script and closing the console, reboot the router so that the script will start automatically after the router reboots and will work correctly without the console.
4. If you want to completely stop the script and prevent it from starting automatically upon router reboot, execute the following command in the console:
/mnt/entware/entware/root/sing-box/sing-box.sh stop
After this command, a router reboot is not required.

V. Complete script removal.
In the router console, execute the command:
/mnt/entware/entware/root/sing-box/sing-box.sh stop
After this, delete the /mnt/entware/entware/root/sing-box directory using the command:
rm -r /mnt/entware/entware/root/sing-box
and, if you haven't deleted it earlier, delete the sing-box-script.tar.gz archive from the /mnt/entware/entware/root/ directory using the command:
rm /mnt/entware/entware/root/sing-box-script.tar.gz
