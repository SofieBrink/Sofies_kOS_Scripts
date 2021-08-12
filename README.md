# Sofies_kOS_Scripts
A general collection of code i decided was good enough to upload

For the Starship Extensions Script, See the two pictures included for the required kOS tags.
it is optional to also tag the Raptor Vacuum Engines with "Rvac" and enable the ShowRvacButton line in the script.
there is a few more user changable variables at the start of the script.

A quick Rundown, The button at the top right of the script is a minimize button. pressing this will collapse the GUI down into a smaller form factor when you do not need it.
The three buttons in the shape of a triangle correspond to the states of the Sea Level engines on the ship. Keep in mind these buttons assume Umbilical side up and Heatshield side down.
So if you are falling upside down somehow think about what engines to use!
The two sliders speak for themselves, these  set the deploy angles on the Front and Aft flaps.
The "Link Sliders" button will figuratively connect the Front and Aft sliders together, Meaning that if you adjust one The other will do the same.
The Authority slider once more speaks for itself. It sets the control Authority on all flaps.
Next up, The "Landing Assist" Button, Possibly the most usefull part of the GUI.
Enabling Landing Assist is only possible while you are falling, When you click the Landing Assist button Nothing will seem to happen at first.
The "assist" only does something when you throttle up to relight the raptor engines. when you do this the Aft flaps will tuck in, the RCS will enable and the Front flaps will completly fold out.
If you have the "SAS Control" button enabled it will also set your SAS Mode to retrograde.
once the flip is complete the Front flaps will tuck in also and the SAS Mode will be set to Radial out when its safe to do so.
it will also automatically deploy the landing legs when you are getting close to the ground and repeatedly press Action group 10 for autoleveling which some starships might have.
After landing the Script will reset the flaps to their default angles and turn off the RCS, ready for another flight!

Pressing the backspace button or clicking the abort button next to the altimeter will reset the computer incase anything is going wrong,
This feature can be disabled with the User changable variables at the start of the script.
There is another feature which can only be enabled of the AbortReset is false. It will ignite all (Defined*) engines on you starship and set the throttle to full if you are not in orbit, Landed or on an escape trajectory.

* = If you have the Rvac's tagged Rvac but you have the button for them disabled they WILL NOT be lit.

Also keep in mind that you will still need to manually deploy the flaps either using action groups or some other way.

Last but not least, I am not responsible for any Starship crashes that may occur!
