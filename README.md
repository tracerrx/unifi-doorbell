# unifi-doorbell
Unifi Doorbell Hacks

The below will replace the welcome graphic.  Note that the graphic will revert to the UNIFI supplied gif on reboot.  In addition, your gif will NOT LOOP.

### Create the Graphic

### Copy Graphic
To copy the graphic from local machine to unifi doorbell, from the cli of your local machine.

`scp -O ~/path/santa-sprite.png ubnt@local.ip:/etc/persistent/santa-sprite.png`

### Mount Graphic
ssh into the doorbell ([How to enable SSH](https://nicholassaraniti.com/2023/12/08/enabling-ubiquiti-camera-ssh-on-unvr/)) and run

`mount -o bind /etc/persistent/santa-sprite.png /usr/etc/gui/screen_240x240/Welcome_Anim_60.png`





