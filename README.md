# unifi-doorbell
Unifi Doorbell Hacks

The below will replace the welcome graphic on a UNIFI G4 Pro Doorbell.  Note that the graphic will revert to the UNIFI supplied gif on reboot.  In addition, your gif will NOT LOOP.


### Create the Graphic
I followed the directions [posted here](https://www.reddit.com/r/Ubiquiti/comments/18c2dw1/g4_pro_doorbell_christmas_animations/) on how to create the graphics. 


### Copy Graphic
To copy the graphic from local machine to unifi doorbell, from the cli of your local machine.  Note that ssh must be enabled see:  ([How to enable SSH](https://nicholassaraniti.com/2023/12/08/enabling-ubiquiti-camera-ssh-on-unvr/))

`scp -O ~/path/santa-sprite.png ubnt@local.ip:/etc/persistent/santa-sprite.png`


### Mount Graphic
ssh into the doorbell ([How to enable SSH](https://nicholassaraniti.com/2023/12/08/enabling-ubiquiti-camera-ssh-on-unvr/)) and run

`mount -o bind /etc/persistent/santa-sprite.png /usr/etc/gui/screen_240x240/Welcome_Anim_60.png`


### Automating
change_sprite.sh is a simple bash script that automates the process and can be scripted in cron to change the graphics based upon date. The script "Should" run on any *nix. change_sprite.sh requires the following parameters:
    -s /path/and/filename/of/sprite.png
    -i local ip address of doorbell
    -p ssh password of doorbell

example usage
`./change_sprite.sh -i 10.11.12.12 -s ./new-year-sprite.png -p YOURSSHPASSWORD`

cron.example is an example cron file which changes the doorbell sprite each month.


