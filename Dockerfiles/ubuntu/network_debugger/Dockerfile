### Web/proxy debugging set tools for Linux
### API Development/Testing set tools for Linux

### BurpSuite Pro + Fiddler + Charles + mitmproxy +.... in a docker image ###
# Based on the base image from Thuonghai: 
## Ubuntu 22.04 has installed noVNC server already
### https://hub.docker.com/layers/thuonghai2711/ubuntu-novnc-pulseaudio/22.04/images/sha256-e72ee80ea972ba776183d2b6296a69b30a45ce89fcfb168fdfe07997ccc51a53?context=explore

FROM thuonghai2711/ubuntu-novnc-pulseaudio:22.04
WORKDIR /var/lib/apt/lists/partial
RUN sudo add-apt-repository ppa:wireshark-dev/stable -y
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends libglib2.0-0  libnss3  libatk1.0-0  libatk-bridge2.0-0  cups libdrm2  libgtk-3-0  libgbm1 libasound2 git openssh-server openssh-client ca-certificates libsecret-1-0 libsecret-common bash iproute2 libpcap-dev libusb-1.0-0-dev libnetfilter-queue-dev wireless-tools firefox libu2f-udev file-roller nano \
    && sudo apt-get autoclean -y && sudo apt-get autoremove -y \
    && sudo rm -rf /var/cache/apt/*

## Get and install latest chrome browser
RUN cd /tmp \
    && wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt-get install ./google-chrome-stable_current_amd64.deb -y && sudo rm -rf /tmp/*
#** sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt install --fix-broken -y **#


# Add Fidder-everywhere 
##  Fidder-everywhere directory can get by extract Fiddler-everywhere for Linux AppImage with command `./Fidder.AppImage --appimage-extract && mv sq* fidder-everywhere`
## ADD fidder-everywhere /home/ubuntu/apps/fidder-everywhere
WORKDIR /tmp/
RUN wget https://api.getfiddler.com/linux/latest-linux -O fidder-everywhere-latest.AppImage \
    && sudo chmod 755 fidder-everywhere-latest.AppImage \
    && ./fidder-everywhere-latest.AppImage --appimage-extract \
    && sudo -u ubuntu mkdir -p /home/ubuntu/apps \
    && sudo mv squashfs-root /home/ubuntu/apps/fidder-everywhere \
    && sudo chown -R ubuntu:ubuntu /home/ubuntu/apps \
    && sudo rm -rf /tmp/*


# Add Burp Suite Pro 
## Install jenv tool and download oracle java-21 and add it with jenv
RUN sudo -u ubuntu git clone https://github.com/jenv/jenv.git /home/ubuntu/.jenv && sudo -u ubuntu echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> /home/ubuntu/.bash_profile && sudo -u ubuntu echo 'eval "$(jenv init -)"' >> /home/ubuntu/.bash_profile

### Java 17 was the last version supported by Burp in the version 2024.1.1.6.
## Java 21 is required for later updates.
## See more: [It no longer works in the latest versions, will we have an update from you soon? · Issue #13 · h3110w0r1d-y/BurpLoaderKeygen](https://github.com/h3110w0r1d-y/BurpLoaderKeygen/issues/13)
## RUN cd /tmp/ && wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && sudo tar -xf jdk-17_linux-x64_bin.tar.gz -C /opt/ && sudo chmod -R 755 /opt/jdk-* && rm -f *.gz

RUN cd /tmp/ && wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz && sudo tar -xf jdk-21_linux-x64_bin.tar.gz -C /opt/ && sudo chmod -R 755 /opt/jdk-* && rm -f *.gz

RUN sudo -u ubuntu mkdir -p /home/ubuntu/.jenv/versions && sudo chown ubuntu:ubuntu /var/lib/apt/lists/partial && sudo -E -u ubuntu /home/ubuntu/.jenv/bin/jenv add /opt/jdk-*/

## Download latest BurpSuite pro and its LoaderKeygen
RUN sudo -u ubuntu mkdir -p /home/ubuntu/apps/BurpSuite && burpsuite_pro_latest_version=$(curl -s https://portswigger.net/burp/releases | grep -oP "Professional \/ Community \K([\d\.]+)" | head -n 1) && sudo -u ubuntu wget "https://portswigger-cdn.net/burp/releases/download?product=pro&version=${burpsuite_pro_latest_version}&type=Jar" -O /home/ubuntu/apps/BurpSuite/burpsuite_pro_v${burpsuite_pro_latest_version}.jar && sudo -u ubuntu wget "https://github.com/directentis1/Toolset/raw/main/Web%20Debugger/Burp/BurpLoaderKeygen.jar" -P /home/ubuntu/apps/BurpSuite/

### The author of this loader temporary disabled (or deleted) it from their github repos, so, I'll use my backup ###
### burploader_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/h3110w0r1d-y/BurpLoaderKeygen/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') && sudo -u ubuntu wget "$burploader_latest_release_url" -P /home/ubuntu/apps/BurpSuite/ 
#** sudo chown -R ubuntu:ubuntu /home/ubuntu/apps/BurpSuite **# --> It'll be took as the same as storage of the BurpSuite folder after do that command, so it'll better if I do combine it with the command above
RUN sudo -u ubuntu echo "oracle64"-$(ls /opt/ | grep "^jdk-" | cut -f2 -d'-') >> /home/ubuntu/apps/BurpSuite/.java-version

# Add latest mitmproxy
RUN mitmproxy_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/mitmproxy/mitmproxy/releases/latest | grep 'tag_name' | cut -d\" -f4 | egrep -o "[0-9\.]*") \
&& sudo -u ubuntu wget "https://downloads.mitmproxy.org/${mitmproxy_latest_release_url}/mitmproxy-${mitmproxy_latest_release_url}-linux-x86_64.tar.gz" -P /tmp/ && sudo -u ubuntu mkdir /home/ubuntu/apps/mitmproxy && sudo -u ubuntu tar -xf /tmp/mitmproxy-*.tar.gz -C /home/ubuntu/apps/mitmproxy && sudo rm -rf /tmp/*

# Add Charles
RUN wget -qO- https://www.charlesproxy.com/packages/apt/charles-repo.asc | sudo tee /etc/apt/keyrings/charles-repo.asc && sudo sh -c 'echo deb [signed-by=/etc/apt/keyrings/charles-repo.asc] https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list' && sudo apt-get update && sudo apt-get install charles-proxy
RUN sudo -u ubuntu wget "https://gist.githubusercontent.com/directentis1/03db0d91ceed266a1237b8be9548292f/raw/62c5eb17c6fa0fa5995ffa49178b18aec533591e/Charles%2520Licenses" -P /home/ubuntu/apps/
RUN cd /tmp/ && sudo -u ubuntu charles ssl export charles-proxy-ssl-proxying-certificate.crt && sudo mv charles-proxy-ssl-proxying-certificate.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates

# Get latest HTTP Toolkit installer script
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/30391fe409995443b8d98250e5562d89/raw/b0f395eec26ca6e612e2fd7deb67568087127d07/httptoolkit_installer.sh -O /home/ubuntu/apps/httptoolkit_installer.sh
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/httptoolkit_installer.sh

# Add Wireshark placehodler
RUN sudo -u ubuntu touch /home/ubuntu/apps/Wireshark

# Add Bettercap from my own build
RUN sudo wget https://github.com/directentis1/bettercap/releases/download/v2.32.0-dev/bettercap -O /usr/local/bin/bettercap && sudo chmod 755 /usr/local/bin/bettercap
RUN sudo bettercap -eval "caplets.update; ui.update; q"

### Get Latest Nmap and its support packages ##
WORKDIR /tmp/
## Download nmap rpm packages from their website
## And convert them to debian packages, install them and clean the leftovers
RUN bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/5dc79a9f8115d00daa518ffc0768ae2f/raw/664ce27eec53aacb875846ffd8ed388af7e2a40a/nmap_downloader)" && bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/486bf0f995bb938a7d4fcdec8e96a22e/raw/268b9c85bdf6ed243776448608115bcf630d4993/nmap_debian_installer)"

### Get Latest Network Miner Installer
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/2540b19361acf3c8e0fcf4961b45daef/raw/362935eec64d6d6f79a23302c2eafda82d44c3ca/networkminer_installer.sh -P /home/ubuntu/apps/
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/networkminer_installer.sh

### Get Latest ZAProxy Installer ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/0f7c9f772013cfea9ab9d3d6056ad608/raw/eeefc138844568effe43cb7a48c5ec8c3a5e286a/zaproxy_installer.sh -P /home/ubuntu/apps/
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/zaproxy_installer.sh

### Get Latest Postman Installer ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/eaf809a6bdd82bc8500964c195b16ee6/raw/a0972ccd4419c4ecd0fa3c8d7b2c4a5dd120bbf1/postman_installer.sh -P /home/ubuntu/apps/
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/postman_installer.sh

### Get latest httpie installer ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/c0e8760610eb1d9b516e81a72997a141/raw/5fe860339a14710e13b21b8c91995ba3f5fd0109/httpie_installer.sh -P /home/ubuntu/apps/ && sudo -u ubuntu chmod 755 /home/ubuntu/apps/httpie_installer.sh

### Get latest insomnia installer ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/53132758a47aaff2490bec2b6de0ecad/raw/992905152f6a58e81fed04b622cc9cfac47730e7/insomnia_installer.sh -P /home/ubuntu/apps && sudo -u ubuntu chmod 755 /home/ubuntu/apps/insomnia_installer.sh

### Get latest reqable installer ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/c3f26086016f2ca33fb2db81c9ec4dca/raw/24d68e43ee7b210b09e53a5274a15bab6d93d5b3/reqable_installer.sh -P /home/ubuntu/apps && sudo -u ubuntu chmod 755 /home/ubuntu/apps/reqable_installer.sh

### Get apifox installer ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/85262bc10eaf4f30033b65d612feefd5/raw/8f312b320ae946af2ea242ab025b501316690430/apifox_deb_installer.sh -P /home/ubuntu/apps && sudo -u ubuntu chmod 755 /home/ubuntu/apps/apifox_deb_installer.sh

# Misc
## Peer-to-peer download tools
WORKDIR /tmp/
RUN curl https://getcroc.schollz.com | sudo bash \
\
&& wget -qO - portal.spatiumportae.com | sudo bash \
\
&& sudo rm -rf /tmp/*
# && wormholers_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/magic-wormhole/magic-wormhole.rs/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') \
#     && sudo wget -O /usr/local/bin/wormhole-rs "$wormholers_latest_release_url" && sudo chmod 755 /usr/local/bin/wormhole-rs \

# Post-stage
## Cleaning
#** RUN sudo apt-get autoclean -y && sudo apt-get autoremove -y && sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/* **# -> Commented this line cause it's only takes 4.3MB, doens't worth to do so.

## Return to root directory
WORKDIR /
