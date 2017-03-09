# Pigrow
Raspberry Pi Grow Box Control Software

This is the software required to control a pigrow2, if you don't
know what a pigrow2 is then check out the videos and guides on

     https://www.patreon.com/Pigrow2

Currently everything is at an alpha development stage, a stable release
will happen as soon as possible, in the mean time anyone intereted in
setting up a pigrow should message me personally and i'll help you
directly.

This document will be updated and finished soon but the most upto date build, install and use instructions are abailable

     https://www.reddit.com/r/Pigrow/wiki/index

#First Steps 
  
 Assuming you have an internet connected Pi and you're logged in via ssh or using it with a keyboard and screen attached; 
  
 First you need to install the software, to do that clone the git repository using the command
 
     git clone https://github.com/Pragmatismo/Pigrow

this will copy all the files into /home/pi/Pigrow, now run the setup program 

    cd Pigrow/scripts/config
    ./setup.py
    
this opens a text menu offering a number of options, the first is install dependences slect it by typeing 1 and pressing return, this will download and install all the resources and dependences for the Pigrow, it may take a while. 

Your Pigrow is now ready for use. 

#Setting up a Webcam and starting a Timelapse 

run the webcam config script found in the /Pigrow/scripts/config/ folder and follow the instructions until you're happy with the image captured by your camera when in the lighting conditions you intend to use it in - remember SAVE your settings once you're happy with them. 

run setup.py and select cron run scripts, then select repeating scripts and follow the prompts to choose the camera capture script and repeat rate of your choice -- at the moment your best choice is probably camcap.py every five min. 
  
once this is set your pi will start taking images every N amount of time, this will keep happening even if you restart your pi so to stop it you need to come back into setup.py and remove the cronjob which triggers the camera, this can also be done via the reddit messsage-control script and soon the remote gui.  
  
From the pi you can run Pigrow/scripts/visulaisation/timelapse_assemble.py to construct a timelapse, run the script with the flag -h to get a full list of command line options and some useage instructions. This script can also be run from a linux machine with MPV installed when the files have been downloaded manually or they can be automatically downloaded using the remote gui and the timelapse made using that [work in progress] 

#Everything else

should be fairly obvious or isn't yet finished, any questions message me on the pigrow sub.

#

#old and wrong stuff


The folloeing is out of date but sections of it may still be useful,

----------

##Install and Setup

------

#Test and config scripts;

- LED - test_led.py - simply turns the LED on for 30 seconds

- Relay - test_relay.py - cycles the relays turning them all on then when they're all on it starts turning them off again.
      !!!!!!!!      - config_relay.py - set's and test's which terminal (normally on or normally off) the sockets were plugged into, allows you to assign functions to relays

- Camera - cam_config.py - creates the persistant settings for use when recording a timelapse or viewing the pi.




#scripts to be called by cron;

To add a one of the following timelapse programs to cron simply use;

       sudo crontab -e

and at the bottom of the file after the explanation of how it works add the line;

       */1 * * * * python /home/pi/Pigrow/scripts/camcap_text_simple.py

This will run the script and take an image every one min.

              Camera -
                     - camcap.py - captures just a single image for
                     - camcap_text_simple.py - captures image and adds date and sensor data to it.
            !!!!     - camcap_text_colour.py - text colour changes according to sensor data.


To set up a 12:12 light cycle simple add the two lines;

     0 10 * * * python /home/pi/pigrow3/lamp_on.py
     0 22 * * * python /home/pi/pigrow3/lamp_off.py     

This turns the lamp on at ten am and off at ten pm. Try not to turn on fans and lamps at exactly the same time, it will work but both items cause power-spikes which if combined might trip your RCD.

              Relay -
                    - lamp_on / off - actuates lamp relay
                    - fan_on / off - for manual timing of fan
                    - heat_on / off - for manual timing of heat
                    - dehumi_on / off - for manual timing of dehumidifier

These scripts are run preiodically as with the camera scripts to check the health of the pi or it's friend, you can check many pi's by calling the script many times.

        Sanity Check -
                     - self_awareness - sensor log, camera, health check
                     - nosey_neighbour - check on a brother pigrow

Scripts to be constantly running;

This is some init.d business i'll be back to explain once the script is uploaded...

          autorunlog.py - logs sensor data to file, switches heaters or fans according to sensor data





------- Useful information which might be needed before release of setup scripts

#Installing 3rd party software commands;

--Adafruit DHT sensor drivers,

    git clone https://github.com/adafruit/Adafruit_Python_DHT.git
    cd Adafruit_Python_DHT
    sudo apt-get update
    sudo apt-get install build-essential python-dev python-openssl
    sudo python setup.py install

      -more information at, https://learn.adafruit.com/dht-humidity-sensing-on-raspberry-pi-with-gdocs-logging/software-install-updated

--From linux Repository

     sudo apt-get install uvccapture           #for use with camera

     sudo pip install pexpect                  #for use when logging other pigrows health

     sudo apt-get install python-matplotlib    #for making graphs

     sudo apt-get install sshpass              #for downloadinging images

     sudo apt install mpv                      #for rendering timelapse movies

     pip install python-crontab                #for config of timelapse and relay timing


-on systems other than Raspbian you may also need;

     sudo apt-get install python-pip           #for adding python modules
     pip install pillow                        #PIL the Python Image Library (for camera capture scripts that edit image)
     sudo apt-get install gpicview             #used by the config program (non-vital, easy to change-out in the code)




#directory structure

            mkdir /home/pi/Pigrow/logs
            mkdir /home/pi/Pigrow/config
            mkdir /home/pi/Pigrow/graphs
            mkdir /home/pi/cam_caps

#to set timed events useibg cron (the semi-manual way)

     crontab -e

lines to include might look like;

     0 7 * * * python /home/pi/pigrow2/lampon.py           #turns lamp relay on at 7 am
     0 1 * * * python /home/pi/pigrow2/lampoff.py          #turns lamp relay off at 1 am

     */5 * * * * python /home/pi/Pigrow/scripts/pi_eye_logger.py    #runs pi_eye monitoring script every 5min
