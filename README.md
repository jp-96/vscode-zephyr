# vscode-zephyr

This repository provides a **setup guide for developing micro:bit v1/v2 applications using Zephyr RTOS in a Windows + WSL2 + Docker environment**. Flashing and debugging via CMSIS-DAP is also supported through `usbipd-win`.

## 📦 Target Environment

| Component         | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| RTOS              | [Zephyr RTOS](https://www.zephyrproject.org/)                               |
| Boards            | `bbc_microbit` (v1), `bbc_microbit_v2` (v2)                                 |
| OS                | Windows 11 with WSL2                                                        |
| IDE               | Visual Studio Code                                                          |
| Container Runtime | Docker Desktop for Windows                                                  |
| USB Bridge        | [usbipd-win](https://github.com/dorssel/usbipd-win)                         |
| Debug Probe       | CMSIS-DAP (micro:bit built-in support)                                      |

---

## 🔧 Setup Instructions

Install the following tools on your Windows 11 system:

- [Git](https://git-scm.com/)  
- [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)  
- [usbipd-win](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)  
- [Visual Studio Code](https://azure.microsoft.com/en-us/products/visual-studio-code)  

Open this project in VS Code and connect to the container environment.

---

## ⚙️ Building the Sample Code

From VS Code, open the menu:  
**Terminal → Run Build Task...**  
Select `Generate micro:bit universal hex`.

This builds for both v1 and v2 boards, producing a single `microbit-universal.hex` file.

To flash the sample code, drag and drop this file onto the micro:bit drive using Windows File Explorer.

---

## 🐞 Flashing and Debugging via CMSIS-DAP

You can flash or debug directly from VS Code without manually generating a hex file.

### 🔗 Binding the USB Device

1. Connect the micro:bit via USB.  
2. Run Command Prompt as Administrator.  
3. List USB devices:
   ```bash
   usbipd list
   ```
4. Identify the micro:bit by its `VID:PID` value: `0d28:0204`.  
5. Bind the device using its BUSID:
   ```bash
   usbipd bind --busid <BUSID>
   ```

### 📎 Attaching the USB Device

After binding, the micro:bit must be attached each time it is reconnected via USB.

Run the included `microbit_attach.bat` on Windows to make the device accessible from the container via CMSIS-DAP.

---

### ⚡ Build and Flash

From VS Code:  
**Terminal → Run Build Task... → Build and Flash**

This will build the project and automatically flash it to the connected micro:bit via CMSIS-DAP.

---

### 🧪 Debugging

From VS Code:  
**Run and Debug (Ctrl + Shift + D) → (GDB) micro:bit**

You can set breakpoints and step through the code execution in the debugger.

---

## 🎓 Learn Zephyr RTOS with micro:bit

This setup provides a hands-on environment for exploring real-time operating systems using accessible, low-cost hardware. Whether you're diving into thread management, scheduling, or hardware abstraction layers, the micro:bit platform—paired with Zephyr—makes it easy to gain practical experience with RTOS development in a fully containerized workflow.

Happy hacking and learning!
