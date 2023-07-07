### Web/proxy debugging set tools for Linux
### API Development/Testing set tools for Linux

### BurpSuite Pro + Fiddler + Charles + mitmproxy +.... in a docker image ###
# Get base image from Thuonghai
## Ubuntu 22.04 has installed noVNC server
FROM thuonghai2711/ubuntu-novnc-pulseaudio:22.04
WORKDIR /var/lib/apt/lists/partial
RUN sudo add-apt-repository ppa:wireshark-dev/stable -y
RUN sudo apt-get update && sudo apt-get install -y libglib2.0-0  libnss3  libatk1.0-0  libatk-bridge2.0-0  cups libdrm2  libgtk-3-0  libgbm1 libasound2 git openssh-server openssh-client ca-certificates libsecret-1-0 libsecret-common bash iproute2 libpcap-dev libusb-1.0-0-dev libnetfilter-queue-dev wireless-tools firefox libu2f-udev file-roller nano

## Get and install latest chrome browser
RUN cd /tmp && wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt install --fix-broken -y


# Add Fidder-everywhere 
##  Fidder-everywhere directory can get by extract Fiddler-everywhere for Linux AppImage with command `./Fidder.AppImage --appimage-extract && mv sq* fidder-everywhere`
## ADD fidder-everywhere /home/ubuntu/apps/fidder-everywhere
WORKDIR /tmp/
RUN wget https://api.getfiddler.com/linux/latest-linux -O fidder-everywhere-latest.AppImage && sudo chmod 755 fidder-everywhere-latest.AppImage && ./fidder-everywhere-latest.AppImage --appimage-extract && sudo -u ubuntu mkdir -p /home/ubuntu/apps && sudo mv squashfs-root /home/ubuntu/apps/fidder-everywhere

# Add Burp Suite Pro 
## Install jenv tool and download oracle java-17 and add it with jenv
RUN sudo -u ubuntu git clone https://github.com/jenv/jenv.git /home/ubuntu/.jenv && sudo -u ubuntu echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> /home/ubuntu/.bash_profile && sudo -u ubuntu echo 'eval "$(jenv init -)"' >> /home/ubuntu/.bash_profile
RUN cd /tmp/ && wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && sudo tar -xf *.gz -C /opt/ && sudo chmod -R 755 /opt/jdk-17.0.7 && rm -f *.gz
RUN sudo -u ubuntu mkdir -p /home/ubuntu/.jenv/versions && sudo chown ubuntu:ubuntu /var/lib/apt/lists/partial && sudo -E -u ubuntu /home/ubuntu/.jenv/bin/jenv add /opt/jdk-17.0.7/

RUN sudo chown -R ubuntu:ubuntu /home/ubuntu/apps
RUN sudo rm -rf /tmp/*

## Download BurpSuite pro and its LoaderKeygen
RUN sudo mkdir -p /home/ubuntu/apps/BurpSuite && sudo wget "https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.7&type=Jar" -O /home/ubuntu/apps/BurpSuite/burpsuite_pro_v2023.7.jar && burploader_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/h3110w0r1d-y/BurpLoaderKeygen/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') && sudo wget "$burploader_latest_release_url" -P /home/ubuntu/apps/BurpSuite/ && sudo chown -R ubuntu:ubuntu /home/ubuntu/apps/BurpSuite
RUN sudo -u ubuntu echo "oracle64-17.0.7" >> /home/ubuntu/apps/BurpSuite/.java-version

# Add mitmproxy
RUN sudo -u ubuntu wget "https://downloads.mitmproxy.org/9.0.1/mitmproxy-9.0.1-linux.tar.gz" -P /tmp/
RUN sudo -u ubuntu mkdir /home/ubuntu/apps/mitmproxy && sudo -u ubuntu tar -xf /tmp/mitmproxy-*.tar.gz -C /home/ubuntu/apps/mitmproxy && sudo rm -rf /tmp/*

# Add Charles
RUN wget -qO- https://www.charlesproxy.com/packages/apt/charles-repo.asc | sudo tee /etc/apt/keyrings/charles-repo.asc && sudo sh -c 'echo deb [signed-by=/etc/apt/keyrings/charles-repo.asc] https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list' && sudo apt-get update && sudo apt-get install charles-proxy
RUN sudo -u ubuntu wget "https://gist.githubusercontent.com/directentis1/03db0d91ceed266a1237b8be9548292f/raw/62c5eb17c6fa0fa5995ffa49178b18aec533591e/Charles%2520Licenses" -P /home/ubuntu/apps/
RUN cd /tmp/ && sudo -u ubuntu charles ssl export charles-proxy-ssl-proxying-certificate.crt && sudo mv charles-proxy-ssl-proxying-certificate.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates

# Add HTTP Toolkit installer script
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/30391fe409995443b8d98250e5562d89/raw/b0f395eec26ca6e612e2fd7deb67568087127d07/httptoolkit_installer.sh -O /home/ubuntu/apps/httptoolkit_installer.sh
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/httptoolkit_installer.sh

# Add Wireshark placehodler
RUN sudo -u ubuntu touch /home/ubuntu/apps/Wireshark

# Add Bettercap
RUN sudo wget https://github.com/directentis1/bettercap/releases/download/v2.32.0-dev/bettercap -O /usr/local/bin/bettercap && sudo chmod 755 /usr/local/bin/bettercap
RUN sudo bettercap -eval "caplets.update; ui.update; q"

# Add nmap
WORKDIR /tmp/
## Download nmap rpm packages from their website
RUN bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/5dc79a9f8115d00daa518ffc0768ae2f/raw/664ce27eec53aacb875846ffd8ed388af7e2a40a/nmap_downloader)"
## Convert them to debian packages, install them and clean the leftovers
RUN bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/486bf0f995bb938a7d4fcdec8e96a22e/raw/60d25622321fbccb003e6819555d6fc662c91d6c/nmap_debian_installer)"

### Postman ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/eaf809a6bdd82bc8500964c195b16ee6/raw/a0972ccd4419c4ecd0fa3c8d7b2c4a5dd120bbf1/postman_installer.sh -P /home/ubuntu/apps/
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/postman_installer.sh


# Misc
## Peer-to-peer download tools
WORKDIR /tmp/
RUN curl https://getcroc.schollz.com | sudo bash && wget -qO - portal.spatiumportae.com | sudo bash && wormholers_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/magic-wormhole/magic-wormhole.rs/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') && sudo wget -O /usr/local/bin/wormhole-rs "$wormholers_latest_release_url" && sudo chmod 755 /usr/local/bin/wormhole-rs

# Post-stage
## Cleaning
RUN sudo apt-get autoclean -y && sudo apt-get autoremove -y && sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/*

## Return to root directory
WORKDIR /
