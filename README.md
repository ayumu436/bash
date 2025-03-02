SysBoost - 

SysBoost is a simple but effective system optimizer for Linux. it cleans junk, optimizes ram, and improves cpu performance without bloat.
it’s written in pure bash, runs fast, and does exactly what it says.
features

    junk cleanup – removes package cache and unnecessary system files.
    ram optimization – Frees up cached memory.
    cpu optimization – disables unnecessary background services.
    scheduled optimization – automate cleanups.
    CLI-Only –

installation

SysBoost works on any Linux distro because it’s just a Bash script.
Arch (AUR)

once it's up on AUR, install it with:

yay -S sysboost


manual install (For Other Distros)

git clone https://github.com/ayumu436/bash.git sysboost
cd sysboost
sudo cp sysboost.sh /usr/bin/sysboost
sudo chmod +x /usr/bin/sysboost


how to use it

run it from the terminal:

sysboost --clean              # Clean junk files  
sysboost --optimize-ram       # Free up memory  
sysboost --optimize-cpu       # Disable useless background services  
sysboost --schedule enable    # Enable scheduled cleanup  
sysboost --schedule disable   # Disable scheduled cleanup  
sysboost --uninstall          # Uninstall SysBoost  
sysboost --version            # Check version  
sysboost --help               # Get help  



MIT, use it however you want.
contributing

got ideas? open an issue or send a pull request.
support

if you like it, cool. if not, that’s fine too
