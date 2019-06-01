https://www.reddit.com/r/RetroPie/comments/7m6m2n/retropie_and_8bitdo_sn30_pro/


UPDATE! So I've got it working wirelessly now, all buttons mapped. I DID have to put it in Switch mode (Start + Y), but in order to get the Pi to recognize it via bluetooth, I had to delete es_input.cfg from /opt/retropie/configs/all/emulationstation/ 


EDIT: I was able to get my controller working by doing the following actions:

PAIRING

Enable SSH, and SSH into the Pi. Run the command sudo ~/RetroPie-Setup/retropie_setup.sh. It's important that you SSH instead of running the command on the Pi itself.
Go to "Configuration / tools > bluetooth"
Turn on the controller in Nintendo Switch mode (START + Y), then hold down the pairing button on the controller until the cycling lights stop and restart.
Pair the controller by selecting "Register and Connect to Bluetooth Device" and then choose your controller (will probably say something like "Pro Controller"). Use the topmost pairing option.
Once paired, set up the udev rule for the controller.
POST-PAIRING

Disconnect all peripherals from your Raspberry Pi. This is really important.
Run the command killall emulationstation.
Run the command sudo ~/RetroPie-Setup/retropie_setup.sh, and navigate to "Configuration / tools > emulationstation > Clear/Reset Emulation Station input configuration". Again, it's important that you do it this way. Simply deleting "es_input.cfg" will not completely reset the input configuration.
In the same menu, check to make sure that "Auto Configuration" is enabled. If not, enable it.
sudo shutdown -r now (or go to the main menu of the script and choose "Perform reboot").
When EmulationStation starts up, press START on your controller. If your controller is still on but does not connect, hold down START for 3-5 seconds to turn it off, then press START to turn it back on.
Configure your controller input as you normally would.
This is how I was able to get my controller to function in games, and correctly send input in EmulationStation. Hope this helps you!