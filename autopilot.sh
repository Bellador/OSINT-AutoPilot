#!/bin/bash
# Script to automate common recon steps

echo "  ____   _____ _____ _   _ _______                 _        _____ _ _       _   "
echo " / __ \ / ____|_   _| \ | |__   __|     /\        | |      |  __ (_) |     | |  "
echo "| |  | | (___   | | |  \| |  | |       /  \  _   _| |_ ___ | |__) || | ___ | |_ " 
echo "| |  | |\___ \  | | | .   |  | |      / /\ \| | | | __/ _ \|  ___/ | |/ _ \| __|"
echo "| |__| |____) |_| |_| |\  |  | |     / ____ \ |_| | || (_) | |   | | | (_) | |_ "
echo " \____/|_____/|_____|_| \_|  |_|    /_/    \_\__,_|\__\___/|_|   |_|_|\___/ \__|"

echo "powered by github.com/Bellador"

# get project name from user
echo "[?] Enter the project name: "  
read project_name
project_hub_path=~/projects
project_path=${project_hub_path}/${project_name}
# check if projects directory exsits
if [[ ! -d ${project_hub_path} ]]; then
	# create new project folder
	echo "[*] Creating project HUB folder at ${project_hub_path}"
	mkdir ${project_hub_path}
fi
# check if project_name directory exists already
if [[ ! -d ${project_path} ]]; then
	# create new project folder
	echo "[*] Creating new project folder at ${project_path}"
	mkdir ${project_path}
else
	echo "[*] project directory exists already. Want to continue (potentially overwriting files)? [n/Y]"
	read choice_continue
	if [[ ${choice_continue} == "n" ]]; then
		echo "[*] exiting..."		
		exit 1
	fi
fi
# get target list from user
echo "[?] Enter absolute path to target list: "  
read targets_path

echo "[*] Updating system and needed tools..."
sudo apt-get -y update && sudo apt-get -y upgrade
python3 ~/tools/Photon/photon.py --update

echo "---------------------------------------"
echo "1. Amass for subdomain enumeration..."
amass_path=${project_path}/amass_output
if [[ ! -d ${amass_path} ]]; then
	mkdir ${amass_path}
fi
sudo amass enum -v -config ~/tools/amass/config.ini -o ${amass_path}/subdomains.txt -df ${targets_path}

echo "---------------------------------------"
echo "2. Httprobe to check live hosts..."
httprobe_path=${project_path}/httprobe_output
if [[ ! -d ${httprobe_path} ]]; then
	mkdir ${httprobe_path}
fi
sudo cat ${amass_path}/subdomains.txt | sort -u | ~/bin/httprobe -c 50 | tee ${httprobe_path}/alive.txt

echo "---------------------------------------"
echo "3. Aquatone to take screenshots of the live hosts..."
aquatone_path=${project_path}/aquatone_output
if [[ ! -d ${aquatone_path} ]]; then
	mkdir ${aquatone_path}
fi
#eyewitness -f ./alive.txt -d ./screenshots
#webscreenshot -i ./alive.txt -w 20 -r chromium -o ./screenshots
sudo cat ${httprobe_path}/alive.txt | ~/tools/aquatone/aquatone -out ${aquatone_path}

echo "---------------------------------------"
echo "4. Photon to discover endpoints, urls with parameters..."
photon_path=${project_path}/photon_output
if [[ ! -d ${photon_path} ]]; then
	mkdir ${photon_path}
fi
len_alive=$(wc -l ${httprobe_path}/alive.txt)
echo "[*]Iterativing over ${len_alive} subdomains..."
counter=1
sudo cat ${httprobe_path}/alive.txt | while read line 
do
	echo "[*] ${counter} of ${len_alive} subdomains..."
	# trim line name (subdomain name) of protocol (e.g https:// not allowed in directory name)
	REGEX="^([^\/]+):\/\/(.+)"
	if [[ $line =~ $REGEX ]]; then
		subdomain_dir_name="${BASH_REMATCH[1]}_${BASH_REMATCH[2]}"
	fi
	# create a new folder for each alive subdomain
	subdomain_dir_path=${photon_path}/${subdomain_dir_name}
	if [[ ! -d ${subdomain_dir_path} ]]; then
		mkdir ${subdomain_dir_path}
	fi
   	sudo python3 ~/tools/Photon/photon.py -u ${line} -l 3 -o ${subdomain_dir_path} --wayback --keys
	((counter++))
done

echo "---------------------------------------"
echo "[*] OSINT AutoPilot done. Results can be found at ${project_path}" 


