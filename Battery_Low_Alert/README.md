# **Low Battery Alert Script for macOS**  

## **Overview**  
This script runs in the background and continuously monitors the MacBook’s battery percentage. It provides **a sound alert and a notification** when the battery drops below **15%**, and **stops the alerts when the charger is plugged in**.  

---

## **1. Full Script**
Save the following script as `low_battery_alert.sh` in your home directory (`~`):  

```sh
#!/bin/bash

while true; do
    # Get the battery percentage
    battery_level=$(pmset -g batt | grep -Eo '[0-9]+%' | cut -d% -f1)

    # Check if charger is connected
    charger_status=$(pmset -g batt | grep "AC Power")

    if [ -z "$charger_status" ] && [ "$battery_level" -le 15 ]; then
        # Play alert sound
        afplay /System/Library/Sounds/Ping.aiff
        
        # Show a notification
        osascript -e 'display notification "Battery Low! Plug in charger." with title "Low Battery Alert"'

        # Optional: Voice alert
        say "Battery Low! Please plug in the charger."
    fi

    # Wait for 300 seconds before checking again
    sleep 300
done
```

---

## **2. Installation & Setup**  
### **Step 1: Save and Make the Script Executable**
1. Open **Terminal**.
2. Create and edit the script file:
   ```sh
   nano ~/low_battery_alert.sh
   ```
3. Paste the script into the file.
4. Save the file:
   - Press **Ctrl + X** → **Y** → **Enter**.
5. Make the script executable:
   ```sh
   chmod +x ~/low_battery_alert.sh
   ```

---

### **Step 2: Grant Full Disk & Accessibility Access**
macOS may block certain scripts from running properly due to security settings. To avoid this, follow these steps:

1. **Go to System Settings → Privacy & Security → Full Disk Access**.
2. Click **“+”** and add:
   - **Terminal** (or **iTerm** if you use it).
   - **Automator** (if you use it for scripts).
3. **Go to Privacy & Security → Accessibility**.
4. Click **“+”** and add:
   - **Terminal** (or **iTerm**).
   - **Automator**.
5. **Restart Terminal** and try running the script again.

---

### **Step 3: Run the Script Manually (For Testing)**
To check if it works, run:
```sh
~/low_battery_alert.sh &
```
- This starts the script in the background.
- If your battery is **≤ 15% and unplugged**, you should hear a sound and see a notification.

---

### **Step 4: Set Up Auto-Start on Login**
To **automatically start the script** when you log in:

#### **Option 1: Add to `.zshrc` (Recommended)**
1. Open Terminal and edit the shell config file:
   ```sh
   nano ~/.zshrc
   ```
2. Add the following line at the bottom:
   ```sh
   ~/low_battery_alert.sh &
   ```
3. Save and exit (**Ctrl + X → Y → Enter**).
4. Apply changes:
   ```sh
   source ~/.zshrc
   ```

#### **Option 2: Add to macOS Login Items**
1. Open **System Settings** → **Users & Groups**.
2. Select your **user account** and go to **Login Items**.
3. Click **"+"**, navigate to `~/low_battery_alert.sh`, and **add it**.
4. Restart your Mac to verify.

---

## **3. Troubleshooting**

### **Issue 1: Script Doesn’t Start on Boot**
✔ **Fix:** Check if it is correctly added to **`~/.zshrc`** or **Login Items**.  
Run:
```sh
cat ~/.zshrc | grep low_battery_alert.sh
```
If the script is missing, **add it again** (see Step 4 above).

---

### **Issue 2: No Notifications Appear**
✔ **Fix 1: Allow Terminal to Send Notifications**
1. Go to **System Settings** → **Notifications**.
2. Find **Terminal** (or iTerm) and enable **"Allow Notifications"**.

✔ **Fix 2: Try an Alert Instead of a Notification**  
Run this command to see if pop-ups work:
```sh
osascript -e 'display alert "Battery Low!" message "Plug in charger now!"'
```
If this works, **replace `display notification` with `display alert`** in the script.

---

### **Issue 3: Script is Running But No Sound**
✔ **Fix:** Test sound manually:
```sh
afplay /System/Library/Sounds/Ping.aiff
```
- If there’s no sound, check **System Settings → Sound** and ensure **alerts are enabled**.

---

### **Issue 4: Script Won’t Stop Even When Charging**
✔ **Fix:** Check charger status manually:
```sh
pmset -g batt
```
If `"AC Power"` is missing, try updating macOS (`System Settings → Software Update`).

---

### **Issue 5: Check if Script is Running**
✔ **Fix:** Run:
```sh
ps aux | grep low_battery_alert.sh
```
- If it’s **not listed**, restart the script:
  ```sh
  ~/low_battery_alert.sh &
  ```
- If you see multiple instances, kill them:
  ```sh
  pkill -f low_battery_alert.sh
  ```

---

### **Issue 6: Changes to the Script Aren't Applied**
✔ **Fix:** Restart the script:
1. Stop the current script:
   ```sh
   pkill -f low_battery_alert.sh
   ```
2. Start the updated script:
   ```sh
   ~/low_battery_alert.sh &
   ```

---

## **4. Uninstall or Disable the Script**
If you want to **stop or remove the script**, follow these steps:

1. **Stop the script manually**:
   ```sh
   pkill -f low_battery_alert.sh
   ```

2. **Remove it from `.zshrc`**:
   ```sh
   nano ~/.zshrc
   ```
   - Delete the line: `~/low_battery_alert.sh &`
   - Save and exit (**Ctrl + X → Y → Enter**).

3. **Remove it from macOS Login Items**:
   - Go to **System Settings → Users & Groups → Login Items**.
   - Find the script and remove it.

4. **Delete the script file**:
   ```sh
   rm ~/low_battery_alert.sh
   ```

---

## **Conclusion**
Now, your MacBook will notify you when the battery is low **only if the charger is unplugged**. 🚀🔋  
With the added **Full Disk & Accessibility permissions**, the script should work without issues.  

Let me know if you need any modifications! 😊
