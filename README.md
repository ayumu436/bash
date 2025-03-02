# SysBoost  

SysBoost is a simple but effective system optimizer for Linux.  
It cleans junk, optimizes RAM, and improves CPU performance **without bloat**.  
It’s written in **pure Bash**, runs fast, and does exactly what it says.  

---

## **🔥 Features**  
- **Junk Cleanup** – Removes package cache and unnecessary system files.  
- **RAM Optimization** – Frees up cached memory.  
- **CPU Optimization** – Disables unnecessary background services.  
- **Scheduled Optimization** – Automate cleanups.  
- **CLI-Only** – No GUI, just a simple script.  

---

## **📥 Installation**  

### **📌 Arch (AUR)**  
Once it's up on AUR, install it with:  
```sh
yay -S sysboost

📌 Manual Install (For Any Linux Distro)

git clone https://github.com/ayumu436/bash.git sysboost
cd sysboost
sudo cp sysboost.sh /usr/bin/sysboost
sudo chmod +x /usr/bin/sysboost

🚀 How to Use

Run it from the terminal:

sysboost --clean              # Clean junk files  
sysboost --optimize-ram       # Free up memory  
sysboost --optimize-cpu       # Disable useless background services  
sysboost --schedule enable    # Enable scheduled cleanup  
sysboost --schedule disable   # Disable scheduled cleanup  
sysboost --uninstall          # Uninstall SysBoost  
sysboost --version            # Check version  
sysboost --help               # Show help  

📜 License

MIT. Use it however you want.
🤝 Contributing

Got ideas? Open an issue or send a pull request.
💬 Support

If you like it, cool. If not, that’s fine too.
