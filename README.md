        ____   _____ _____ _   _ _______                 _        _____ _ _       _   
       / __ \ / ____|_   _| \ | |__   __|     /\        | |      |  __ (_) |     | |  
      | |  | | (___   | | |  \| |  | |       /  \  _   _| |_ ___ | |__) || | ___ | |_  
      | |  | |\___ \  | | | .   |  | |      / /\ \| | | | __/ _ \|  ___/ | |/ _ \| __|
      | |__| |____) |_| |_| |\  |  | |     / ____ \ |_| | || (_) | |   | | | (_) | |_ 
       \____/|_____/|_____|_| \_|  |_|    /_/    \_\__,_|\__\___/|_|   |_|_|\___/ \__|
                                                                                 
                                                                                 
__AutoPilot__ combines your favourite OSINT tools in one script to ease the process while bundling all results in a neat project structure.

Currently the following steps are covered:

 <ol>
  <li>Subdomain enumeration - <a href="https://github.com/OWASP/Amass"><b>Amass</b> @OWASP</a></li>
  <li>Check for live targets - <a href="https://github.com/tomnomnom/httprobe"><b>httprobe</b> @tomnomnom</a></li>
  <li>Take webscreenshots, grab html - <a href="https://github.com/michenriksen/aquatone"><b>aquatone</b> @michenriksen </a></li>
  <li>Crawl targets to find endpoints, keys - <a href="https://github.com/s0md3v/Photon"><b>Photon</b> @s0md3v</a></li>
</ol>

Feel free to fork and extend to your own needs! e.g.

<ul>
  <li>Content discovery - <a href="https://github.com/ffuf/ffuf"><b>ffuf</b> @ffuf</a></li>
  <li>Service scanning - <a href="https://github.com/nmap/nmap"><b>nmap</b> @nmap</a></li>
  <li>XSS scanning - <a href="https://github.com/s0md3v/XSStrike"><b>XSStrike</b> @s0md3v</a></li>
</ul>

#### Setup
1. Install recon tools mentioned above
2. The script searches for the tools under `~/tools`, change if necessary or add to $PATH
3. Projects will be stored at your home directory by default, change `project_hub_path` variable to change this
