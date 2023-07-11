/bin/sh -c #(nop) ADD file:396eeb65c8d737180cc1219713cf59efb214027b79d8ea0b7e58a08e7c8d7a21 in / 
/bin/sh -c #(nop)  CMD ["bash"]
/bin/sh -c #(nop)  ARG GUI=xfce
/bin/sh -c #(nop)  ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true USERNAME=ubuntu HOME=/home/ubuntu GUI=xfce SCREEN_WIDTH=1600 SCREEN_HEIGHT=900 SCREEN_DEPTH=24 SCREEN_DPI=96 DISPLAY=:99 DISPLAY_NUM=99 FFMPEG_UDP_PORT=10000 WEBSOCKIFY_PORT=6900 VNC_PORT=5900 AUDIO_SERVER=1699 VNC_PASSWD=password
/bin/sh -c apt update ; apt install unzip zip -y
/bin/sh -c #(nop) COPY file:c15eaccc60ceb877282b3f86fb0ea02a925e27598eaf38d14fd334ff5b5a6389 in /opt/ 
/bin/sh -c cd /opt/ && unzip otp-bin.zip
/bin/sh -c apt-get -qqy update && apt-get -qqy --no-install-recommends install sudo supervisor dbus-x11 xvfb x11vnc x11-xserver-utils tigervnc-standalone-server tigervnc-common novnc websockify wget curl unzip gettext && bash /opt/bin/apt_clean.sh
/bin/sh -c apt-get -qqy update && apt-get -qqy --no-install-recommends install pulseaudio pavucontrol alsa-base ffmpeg nginx && bash /opt/bin/apt_clean.sh
/bin/sh -c chmod +x /dev/shm
/bin/sh -c mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
/bin/sh -c groupadd $USERNAME --gid 1001 && useradd $USERNAME --create-home --gid 1001 --shell /bin/bash --uid 1001 && usermod -a -G sudo $USERNAME && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers     && echo "$USERNAME:$USERNAME" | chpasswd
/bin/sh -c #(nop) COPY file:12f026a6fad32dbd2446adaebdb0f4433d016bcf45d86f1b9f4fad7091373f3f in /etc/supervisor/ 
/bin/sh -c #(nop) COPY file:beba24635df01ae23be7d417bc7105fdd29f904893de6fcb19acfff2721eb3b6 in /etc/nginx/conf.d/nginx.conf.template 
/bin/sh -c bash /opt/bin/install_gui.sh
/bin/sh -c bash /opt/bin/install_utils.sh
/bin/sh -c bash /opt/bin/setup_audio.sh
/bin/sh -c #(nop) COPY file:bbec793e0d4f234b264e224e70276f27bf40d5f4350bad98c3743295b9c8d89f in /usr/share/ 
/bin/sh -c rm -rf /usr/share/novnc/ && cd /usr/share/ && unzip no-vnc.zip
/bin/sh -c bash /opt/bin/relax_permission.sh
/bin/sh -c sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/share/novnc/app/ui.js
/bin/sh -c sudo apt update; sudo apt install xfce4-goodies -y ;  bash /opt/bin/apt_clean.sh
/bin/sh -c #(nop)  USER ubuntu
/bin/sh -c #(nop)  CMD ["/opt/bin/entry_point.sh"]
WORKDIR /var/lib/apt/lists/partial
RUN /bin/sh -c sudo add-apt-repository ppa:wireshark-dev/stable -y # buildkit
RUN /bin/sh -c sudo apt-get update && sudo apt-get install -y --no-install-recommends libglib2.0-0  libnss3  libatk1.0-0  libatk-bridge2.0-0  cups libdrm2  libgtk-3-0  libgbm1 libasound2 git openssh-server openssh-client ca-certificates libsecret-1-0 libsecret-common bash iproute2 libpcap-dev libusb-1.0-0-dev libnetfilter-queue-dev wireless-tools firefox libu2f-udev file-roller nano && sudo apt-get autoclean -y && sudo apt-get autoremove -y && sudo rm -rf /var/cache/apt/* # buildkit
RUN /bin/sh -c cd /tmp && wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo apt-get install ./google-chrome-stable_current_amd64.deb -y && sudo rm -rf /tmp/* # buildkit
WORKDIR /tmp/
RUN /bin/sh -c wget https://api.getfiddler.com/linux/latest-linux -O fidder-everywhere-latest.AppImage && sudo chmod 755 fidder-everywhere-latest.AppImage && ./fidder-everywhere-latest.AppImage --appimage-extract && sudo -u ubuntu mkdir -p /home/ubuntu/apps && sudo mv squashfs-root /home/ubuntu/apps/fidder-everywhere && sudo chown -R ubuntu:ubuntu /home/ubuntu/apps && sudo rm -rf /tmp/* # buildkit
RUN /bin/sh -c sudo -u ubuntu git clone https://github.com/jenv/jenv.git /home/ubuntu/.jenv && sudo -u ubuntu echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> /home/ubuntu/.bash_profile && sudo -u ubuntu echo 'eval "$(jenv init -)"' >> /home/ubuntu/.bash_profile # buildkit
RUN /bin/sh -c cd /tmp/ && wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && sudo tar -xf *.gz -C /opt/ && sudo chmod -R 755 /opt/jdk-17.0.7 && rm -f *.gz # buildkit
RUN /bin/sh -c sudo -u ubuntu mkdir -p /home/ubuntu/.jenv/versions && sudo chown ubuntu:ubuntu /var/lib/apt/lists/partial && sudo -E -u ubuntu /home/ubuntu/.jenv/bin/jenv add /opt/jdk-17.0.7/ # buildkit
RUN /bin/sh -c sudo -u ubuntu mkdir -p /home/ubuntu/apps/BurpSuite && burpsuite_pro_latest_version=$(curl -s https://portswigger.net/burp/releases | grep -oP "Professional \/ Community \K([\d\.]+)" | head -n 1) && sudo -u ubuntu wget "https://portswigger-cdn.net/burp/releases/download?product=pro&version=${burpsuite_pro_latest_version}&type=Jar" -O /home/ubuntu/apps/BurpSuite/burpsuite_pro_v${burpsuite_pro_latest_version}.jar && burploader_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/h3110w0r1d-y/BurpLoaderKeygen/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') && sudo -u ubuntu wget "$burploader_latest_release_url" -P /home/ubuntu/apps/BurpSuite/ # buildkit
RUN /bin/sh -c sudo -u ubuntu echo "oracle64-17.0.7" >> /home/ubuntu/apps/BurpSuite/.java-version # buildkit
RUN /bin/sh -c sudo -u ubuntu wget "https://downloads.mitmproxy.org/9.0.1/mitmproxy-9.0.1-linux.tar.gz" -P /tmp/ && sudo -u ubuntu mkdir /home/ubuntu/apps/mitmproxy && sudo -u ubuntu tar -xf /tmp/mitmproxy-*.tar.gz -C /home/ubuntu/apps/mitmproxy && sudo rm -rf /tmp/* # buildkit
RUN /bin/sh -c wget -qO- https://www.charlesproxy.com/packages/apt/charles-repo.asc | sudo tee /etc/apt/keyrings/charles-repo.asc && sudo sh -c 'echo deb [signed-by=/etc/apt/keyrings/charles-repo.asc] https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list' && sudo apt-get update && sudo apt-get install charles-proxy # buildkit
RUN /bin/sh -c sudo -u ubuntu wget "https://gist.githubusercontent.com/directentis1/03db0d91ceed266a1237b8be9548292f/raw/62c5eb17c6fa0fa5995ffa49178b18aec533591e/Charles%2520Licenses" -P /home/ubuntu/apps/ # buildkit
RUN /bin/sh -c cd /tmp/ && sudo -u ubuntu charles ssl export charles-proxy-ssl-proxying-certificate.crt && sudo mv charles-proxy-ssl-proxying-certificate.crt /usr/local/share/ca-certificates/ && sudo update-ca-certificates # buildkit
RUN /bin/sh -c sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/30391fe409995443b8d98250e5562d89/raw/b0f395eec26ca6e612e2fd7deb67568087127d07/httptoolkit_installer.sh -O /home/ubuntu/apps/httptoolkit_installer.sh # buildkit
RUN /bin/sh -c sudo -u ubuntu chmod 755 /home/ubuntu/apps/httptoolkit_installer.sh # buildkit
RUN /bin/sh -c sudo -u ubuntu touch /home/ubuntu/apps/Wireshark # buildkit
RUN /bin/sh -c sudo wget https://github.com/directentis1/bettercap/releases/download/v2.32.0-dev/bettercap -O /usr/local/bin/bettercap && sudo chmod 755 /usr/local/bin/bettercap # buildkit
RUN /bin/sh -c sudo bettercap -eval "caplets.update; ui.update; q" # buildkit
WORKDIR /tmp/
RUN /bin/sh -c bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/5dc79a9f8115d00daa518ffc0768ae2f/raw/664ce27eec53aacb875846ffd8ed388af7e2a40a/nmap_downloader)" && bash -c "$(curl -sSL https://gist.githubusercontent.com/directentis1/486bf0f995bb938a7d4fcdec8e96a22e/raw/268b9c85bdf6ed243776448608115bcf630d4993/nmap_debian_installer)" # buildkit
RUN /bin/sh -c sudo -u ubuntu wget https://gist.githubusercontent.com/directentis1/eaf809a6bdd82bc8500964c195b16ee6/raw/a0972ccd4419c4ecd0fa3c8d7b2c4a5dd120bbf1/postman_installer.sh -P /home/ubuntu/apps/ # buildkit
RUN /bin/sh -c sudo -u ubuntu chmod 755 /home/ubuntu/apps/postman_installer.sh # buildkit
WORKDIR /tmp/
RUN /bin/sh -c curl https://getcroc.schollz.com | sudo bash && wget -qO - portal.spatiumportae.com | sudo bash && wormholers_latest_release_url=$(curl -s -H "Accept: application/vnd.github+json" https://api.github.com/repos/magic-wormhole/magic-wormhole.rs/releases/latest | grep 'browser_' | cut -d\" -f4 | awk 'NR==1') && sudo wget -O /usr/local/bin/wormhole-rs "$wormholers_latest_release_url" && sudo chmod 755 /usr/local/bin/wormhole-rs && sudo rm -rf /tmp/* # buildkit
WORKDIR /
