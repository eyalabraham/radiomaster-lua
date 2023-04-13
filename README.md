# Radiomaster TX16S LUA scripts

LUA script collection for Radiomaster TX16S running EdgeTX 2.7.1 (or higher)

> Free to use with the full understanding that what you - the user - are doing something that can result in a crash that is dangerous and that you are responsible for your and others' safety!

## Useless

A useless tools script created as a test script for practice. Place the script and ```.png``` file in the ```/SCRIPTS/TOOLS``` directory of the SD card and access the script by pressing the SYS button and to open the TOOLS page.  
The script displays a gray page with the current radio's code level and a 'Click me' button. Click anywhere on the page to hear a low pitch tone, and click the button to hear a high pitch tone. Exit by pressing an holding the RTN button.

![Useless](img/useless-main.png)

## Dual rudder stick

If you have a 3-channel RC model plane and you want your rudder stick to respond to both the right (CH1) and left (CH4) sticks then use this script together with a channel mix. You will need to enable LUA mix scripts on your radio by flashing the appropriate firmware, usually with ```-luamixer-``` in the name. If the LUA icon appears in the top settings bar to the right of the telemetry icon then you have LUA mix scripts installed and enabled.  

![LUA mix scripts](img/drudd-lua.png)

Place the script in the ```/SCRIPTS/MIXES``` directory on your SD card and you will be able to select it and assign it to one of the LUAn variable. Next configure the script's properties by providing a name and assigning the right and left input variables to the right and left sticks on channel 1 and 4.  

![LUA mix scripts](img/drudd-properties.png)

Finally, create a mix in MIXES that 'Adds' or 'Replaces' right stick's (CH1) input. This will ensure that if the LUA mix script is disabled by the radio's operating system, you will still maintain control using the right (CH1) stick.  

![LUA mix scripts](img/drudd-mix.png)

## Battery percent widget

TBD
