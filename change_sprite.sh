#!/usr/bin/env bash
#
# A script for chnaging the sprite on
# a unifi doorbell.  Note you must pass the
# sprite name and IP of the doorbell

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Changes the sprite (animated gif) on a UNIFI Doorbell"
   echo ""
   echo "Nicholas Saraniti 2023 (https://nicholassaraniti.com/)"
   echo "https://github.com/tracerrx/unifi-doorbell"
   echo ""
   echo "Syntax: change_sprite [-h|i|s]"
   echo "options:"
   echo "   h     Print this Help."
   echo "   i     IP address of UNIFI Doorbell (REQUIRED)."
   echo "   s     Name of Sprite to upload with path i.e. ./easter-sprite.png (REQUIRED)."
   echo "   p     ssh password of doorbell (REQUIRED)."
   echo
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################
while getopts s:i:p:h flag
do
    case "${flag}" in
        s) SPRITEPATH=${OPTARG};;
        i) IP=${OPTARG};;
        p) PASSWORD=${OPTARG};;
        h) Help
           exit;;
    esac
done

############Check That SSHPASS is installed###############
if ! command -v sshpass &> /dev/null
then
    echo "sshpass could not be found and must be installed."
    exit 1
fi

############Check Doorbell IP is Reachable###############
if ping -t 3 -c 1 $IP &> /dev/null
then
  echo "Able to Ping Doorbell at $IP"
else
  echo "error: Unable to ping doorbell at $IP."
  exit 1;
fi

############Check That Sprite file Exists Locally###############
if test -f $SPRITEPATH; 
then
  echo "File $SPRITEPATH exists."
  SPRITE="$(basename -- $SPRITEPATH)"
  echo "Sprite Name is $SPRITE"
else
  echo "error: Unable to read file $SPRITEPATH."
  exit 2;
fi

############SCP the Sprite to the doorbell###############
sshpass -p $PASSWORD scp -O $SPRITEPATH ubnt@$IP:/etc/persistent/$SPRITE
if [ $? -eq 0 ];
then
    echo "Sprite copied to doorbell"
else
    echo "error: Could not copy Sprite to doorbell"
    exit 3;
fi

############Run Mount command Remotely via SSH###############
echo "Attempting to unmount in case doorbell has not rebooted since last update"
sshpass -p $PASSWORD ssh ubnt@$IP "umount /usr/etc/gui/screen_240x240/Welcome_Anim_60.png"
echo "Mounting New Sprite" 
sshpass -p $PASSWORD ssh ubnt@$IP "mount -o bind /etc/persistent/$SPRITE /usr/etc/gui/screen_240x240/Welcome_Anim_60.png"
if [ $? -eq 0 ];
then
    echo "Sprite mounted on doorbell, alldone!"
else
    echo "error: Could not mount Sprite on doorbell"
    exit 4;
fi