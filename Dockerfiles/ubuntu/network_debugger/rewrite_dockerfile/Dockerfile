FROM ubuntu:jammy

CMD ["bash"]
ARG GUI=xfce
ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true USERNAME=ubuntu HOME=/home/ubuntu GUI=xfce SCREEN_WIDTH=1600 SCREEN_HEIGHT=900 SCREEN_DEPTH=24 SCREEN_DPI=96 DISPLAY=:99 DISPLAY_NUM=99 FFMPEG_UDP_PORT=10000 WEBSOCKIFY_PORT=6900 VNC_PORT=5900 AUDIO_SERVER=1699 VNC_PASSWD=password

RUN set -ex \
    && apt-get -qqy update \
    && apt install unzip zip -y \
    && apt-get -qqy --no-install-recommends install sudo supervisor dbus-x11 xvfb x11vnc x11-xserver-utils tigervnc-standalone-server tigervnc-common novnc websockify wget curl unzip gettext \
    && apt-get -qqy --no-install-recommends install pulseaudio pavucontrol alsa-base ffmpeg nginx \
    \
    && chmod +x /dev/shm && mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix \
    && groupadd $USERNAME --gid 1001 && useradd $USERNAME --create-home --gid 1001 --shell /bin/bash --uid 1001 && usermod -a -G sudo $USERNAME && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers && echo "$USERNAME:$USERNAME" | chpasswd \
    \
    &&  if [ "${GUI}" == "xfce" ]; then apt-get -qqy --no-install-recommends install xfce4 && echo -e '#!/usr/bin/env bash\n/usr/bin/startxfce4' > /opt/bin/start-ui.sh; fi \
    \
    && apt-get -qqy --no-install-recommends install htop terminator software-properties-common gpg-agent \
        && add-apt-repository -y ppa:mozillateam/ppa \
        && echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' | tee /etc/apt/preferences.d/mozilla-firefox \
    \
    && apt-get install xfce4-goodies -y \
    && add-apt-repository ppa:wireshark-dev/stable -y \
    \
    && apt-get update && sudo apt-get install -y --no-install-recommends libglib2.0-0  libnss3  libatk1.0-0  libatk-bridge2.0-0  cups libdrm2  libgtk-3-0  libgbm1 libasound2 git openssh-server openssh-client ca-certificates libsecret-1-0 libsecret-common bash iproute2 libpcap-dev libusb-1.0-0-dev libnetfilter-queue-dev wireless-tools firefox libu2f-udev file-roller nano \
    \
    && wget -qO- https://www.charlesproxy.com/packages/apt/charles-repo.asc | sudo tee /etc/apt/keyrings/charles-repo.asc && sudo sh -c 'echo deb [signed-by=/etc/apt/keyrings/charles-repo.asc] https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list' && sudo apt-get update && sudo apt-get install charles-proxy -y \
    \
    && apt-get autoclean -y && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# RUN chmod +x /dev/shm
# RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# RUN groupadd $USERNAME --gid 1001 && useradd $USERNAME --create-home --gid 1001 --shell /bin/bash --uid 1001 && usermod -a -G sudo $USERNAME && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers && echo "$USERNAME:$USERNAME" | chpasswd

# Copy some scripts file
COPY bin /opt/bin

#(nop) COPY file:12f026a6fad32dbd2446adaebdb0f4433d016bcf45d86f1b9f4fad7091373f3f in /etc/supervisor/ 
COPY supervisord.conf /etc/supervisor/
#(nop) COPY file:beba24635df01ae23be7d417bc7105fdd29f904893de6fcb19acfff2721eb3b6 in /etc/nginx/conf.d/nginx.conf.template 
COPY nginx.conf.template /etc/nginx/conf.d/nginx.conf.template

# COPY no-vnc.zip /usr/share/
# RUN rm -rf /usr/share/novnc
COPY novnc /usr/share/novnc

# bash /opt/bin/setup_audio.sh
RUN wget --no-check-certificate -q -O /usr/share/novnc/jsmpeg.min.js https://raw.githubusercontent.com/phoboslab/jsmpeg/master/jsmpeg.min.js

# Relaxing permissions for other non-sudo environments
RUN FOLDERS="/opt/bin/ /var/run/supervisor /var/log/supervisor /etc/nginx /usr/share/novnc" && mkdir -p $FOLDERS && chmod -R 777 $FOLDERS /etc/passwd && chgrp -R 0 $FOLDERS && chmod -R g=u $FOLDERS
RUN sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/share/novnc/app/ui.js

#### My own script ####
## Setup the default user
## Set appropriate permissions for ubuntu home directory -> Still don't understand why those commands above has didn't make that, like as the original image file of Thuonghai do? I'll check them leter.
RUN chown -R ubuntu:ubuntu /home/ubuntu && chmod 755 /home/ubuntu
USER ubuntu
## Config default command
CMD ["bash", "/opt/bin/entry_point.sh"]

## Get and install latest chrome browser
RUN cd /tmp \
    && wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && sudo apt update \
    && sudo apt-get install ./google-chrome-stable_current_amd64.deb -y \
    && sudo rm -rf /tmp/* \
    && sudo apt-get autoclean -y && sudo apt-get autoremove -y && sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/*
#** sudo dpkg -i google-chrome-stable_current_amd64.deb || sudo apt install --fix-broken -y **#

# Add Fidder-everywhere 
##  Fidder-everywhere directory can get by extract Fiddler-everywhere for Linux AppImage with command `./Fidder.AppImage --appimage-extract && mv sq* fidder-everywhere`
## ADD fidder-everywhere /home/ubuntu/apps/fidder-everywhere
WORKDIR /tmp/
RUN sudo mkdir -p /var/lib/apt/lists/partial && sudo chmod 755 /var/lib/apt/lists/partial
RUN wget https://api.getfiddler.com/linux/latest-linux -O fidder-everywhere-latest.AppImage \
    && sudo chmod 755 fidder-everywhere-latest.AppImage \
    && ./fidder-everywhere-latest.AppImage --appimage-extract \
    && sudo -u ubuntu mkdir -p /home/ubuntu/apps \
    && sudo mv squashfs-root /home/ubuntu/apps/fidder-everywhere \
    && sudo chown -R ubuntu:ubuntu /home/ubuntu/apps && sudo rm -rf /tmp/*


# Add Burp Suite Pro 
## Install jenv tool and download oracle java-17 and add it to jenv
RUN sudo -u ubuntu git clone https://github.com/jenv/jenv.git /home/ubuntu/.jenv && sudo -u ubuntu echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> /home/ubuntu/.bash_profile && sudo -u ubuntu echo 'eval "$(jenv init -)"' >> /home/ubuntu/.bash_profile
RUN cd /tmp/ && wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && sudo tar -xf *.gz -C /opt/ && sudo chmod -R 755 /opt/jdk-17.0.7 && rm -f *.gz
RUN sudo -u ubuntu mkdir -p /home/ubuntu/.jenv/versions && sudo chown ubuntu:ubuntu /var/lib/apt/lists/partial && sudo -E -u ubuntu /home/ubuntu/.jenv/bin/jenv add /opt/jdk-17.0.7/

## Download BurpSuite pro and its LoaderKeygen
RUN sudo -u ubuntu mkdir -p /home/ubuntu/apps/BurpSuite && burpsuite_pro_latest_version=$(curl -s https://portswigger.net/burp/releases | grep -oP "Professional \/ Community \K([\d\.]+)" | head -n 1) && sudo -u ubuntu wget "https://portswigger-cdn.net/burp/releases/download?product=pro&version=${burpsuite_pro_latest_version}&type=Jar" -O /home/ubuntu/apps/BurpSuite/burpsuite_pro_v${burpsuite_pro_latest_version}.jar && burploader_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/h3110w0r1d-y/BurpLoaderKeygen/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') && sudo -u ubuntu wget "$burploader_latest_release_url" -P /home/ubuntu/apps/BurpSuite/ 

#** sudo chown -R ubuntu:ubuntu /home/ubuntu/apps/BurpSuite **# --> It'll be took as the same as storage of the BurpSuite folder after do that command, so it'll better if I do combine it with the command above
RUN sudo -u ubuntu echo "oracle64-17.0.7" >> /home/ubuntu/apps/BurpSuite/.java-version

# Add mitmproxy
RUN mitmproxy_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/mitmproxy/mitmproxy/releases/latest | grep 'tag_name' | cut -d\" -f4) \
&& sudo -u ubuntu wget "https://downloads.mitmproxy.org/${mitmproxy_latest_release_url}/mitmproxy-${mitmproxy_latest_release_url}-linux.tar.gz" -P /tmp/ && sudo -u ubuntu mkdir /home/ubuntu/apps/mitmproxy && sudo -u ubuntu tar -xf /tmp/mitmproxy-*.tar.gz -C /home/ubuntu/apps/mitmproxy && sudo rm -rf /tmp/*

# Add Charles
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
## And convert them to debian packages, install them and clean the leftovers
RUN bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/5dc79a9f8115d00daa518ffc0768ae2f/raw/664ce27eec53aacb875846ffd8ed388af7e2a40a/nmap_downloader)" && bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/486bf0f995bb938a7d4fcdec8e96a22e/raw/268b9c85bdf6ed243776448608115bcf630d4993/nmap_debian_installer)"

### Postman ###
RUN sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/eaf809a6bdd82bc8500964c195b16ee6/raw/a0972ccd4419c4ecd0fa3c8d7b2c4a5dd120bbf1/postman_installer.sh -P /home/ubuntu/apps/
RUN sudo -u ubuntu chmod 755 /home/ubuntu/apps/postman_installer.sh


# Misc
## Peer-to-peer download tools
WORKDIR /tmp/
RUN curl https://getcroc.schollz.com | sudo bash \
    && wget -qO - portal.spatiumportae.com | sudo bash \
    && wormholers_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/magic-wormhole/magic-wormhole.rs/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') \
        && sudo wget -O /usr/local/bin/wormhole-rs "$wormholers_latest_release_url" \
        && sudo chmod 755 /usr/local/bin/wormhole-rs \
        && sudo rm -rf /tmp/*

# Post-stage
## Cleaning
#** RUN sudo apt-get autoclean -y && sudo apt-get autoremove -y && sudo rm -rf /var/lib/apt/lists/* /var/cache/apt/* **# -> Commented this line cause it's only takes 4.3MB, doens't worth to do so.

## Return to root directory
WORKDIR /