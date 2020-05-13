#!/bin/bash
if grep -Eq 'debian|ubuntu' "/etc/os-release"; then
    LINUX_DISTRO='debian'
    if grep -q 'ubuntu' /etc/os-release; then
        DEBIAN_DISTRO='ubuntu'
    elif [ "$(cat /etc/issue | cut -c 1-4)" = "Kali" ]; then
        DEBIAN_DISTRO='kali'
    fi

elif grep -Eqi "Fedora|CentOS|Red Hat|redhat" '/etc/os-release'; then
    LINUX_DISTRO='redhat'
    if [ "$(cat /etc/os-release | grep 'ID=' | head -n 1 | cut -d '"' -f 2)" = "centos" ]; then
        REDHAT_DISTRO='centos'
    elif grep -q 'Fedora' "/etc/os-release"; then
        REDHAT_DISTRO='fedora'
    fi

elif grep -q "Alpine" '/etc/issue' || grep -q "Alpine" '/etc/os-release'; then
    LINUX_DISTRO='alpine'

elif grep -Eq "Arch|Manjaro" '/etc/os-release' || grep -Eq "Arch|Manjaro" '/etc/issue'; then
    LINUX_DISTRO='arch'

elif grep -qi 'Void' '/etc/issue'; then
    LINUX_DISTRO='void'

elif grep -qi 'suse' '/etc/os-release'; then
    LINUX_DISTRO='suse'

elif grep -Eq "gentoo|funtoo" '/etc/os-release'; then
    LINUX_DISTRO='gentoo'
fi
#####################
DEPENDENCIES=""
if [ ! -e /bin/bash ]; then
    DEPENDENCIES="${DEPENDENCIES} bash"
fi

if [ ! -e "/usr/lib/command-not-found" ]; then
    if [ "${LINUX_DISTRO}" = "debian" ]; then
        DEPENDENCIES="${DEPENDENCIES} command-not-found"
    fi
fi
##################
if [ "${LINUX_DISTRO}" = "debian" ]; then
    if [ ! -f "/tmp/.openwrtcheckfile" ]; then
        if [ ! -d /usr/share/command-not-found ]; then
            DEPENDENCIES="${DEPENDENCIES} command-not-found"
        fi
    fi

    if [ ! -d /usr/share/doc/fonts-powerline ]; then
        DEPENDENCIES="${DEPENDENCIES} fonts-powerline"
    fi
fi
###########################################
if [ ! -e /usr/bin/git ]; then
    if [ "${LINUX_DISTRO}" = "openwrt" ]; then
        DEPENDENCIES="${DEPENDENCIES} git git-http"
    elif [ "${LINUX_DISTRO}" = "gentoo" ]; then
        DEPENDENCIES="${DEPENDENCIES} dev-vcs/git"
    else
        DEPENDENCIES="${DEPENDENCIES} git"
    fi
fi
####################################
if [ ! -e /usr/bin/wget ]; then
    if [ "${LINUX_DISTRO}" = "gentoo" ]; then
        DEPENDENCIES="${DEPENDENCIES} net-misc/wget"
    else
        DEPENDENCIES="${DEPENDENCIES} wget"
    fi
fi
###########################

if [ ! -e /bin/zsh ]; then
    if [ "${LINUX_DISTRO}" = "alpine" ]; then
        DEPENDENCIES="${DEPENDENCIES} zsh zsh-vcs"
    elif [ "${LINUX_DISTRO}" = "gentoo" ]; then
        DEPENDENCIES="${DEPENDENCIES} app-shells/zsh"
    else
        DEPENDENCIES="${DEPENDENCIES} zsh"
    fi
fi
#############################
if [ ! -z "${DEPENDENCIES}" ]; then
    echo "正在安装相关依赖..."

    if [ "${LINUX_DISTRO}" = "debian" ]; then
        apt update
        apt install -y ${DEPENDENCIES} || apt install -y command-not-found zsh git wget whiptail

    elif [ "${LINUX_DISTRO}" = "alpine" ]; then
        apk add ${DEPENDENCIES}
        #apk add xz newt tar zsh git wget bash zsh-vcs pv

    elif [ "${LINUX_DISTRO}" = "arch" ]; then
        pacman -Syu --noconfirm ${DEPENDENCIES}

    elif [ "${LINUX_DISTRO}" = "redhat" ]; then
        dnf install -y ${DEPENDENCIES} || yum install -y ${DEPENDENCIES}
        #dnf install -y zsh git pv wget xz tar newt || yum install -y zsh git pv wget xz tar newt

    elif [ "${LINUX_DISTRO}" = "openwrt" ]; then
        #opkg update
        opkg install ${DEPENDENCIES} || opkg install whiptail

    elif [ "${LINUX_DISTRO}" = "void" ]; then
        xbps-install -S
        xbps-install -y ${DEPENDENCIES}

    elif [ "${LINUX_DISTRO}" = "gentoo" ]; then
        emerge -avk ${DEPENDENCIES}

    elif
        [ "${LINUX_DISTRO}" = "suse" ]
    then
        zypper in -y ${DEPENDENCIES}

    else
        apt update
        apt install -y command-not-found zsh git wget whiptail command-not-found || port install ${DEPENDENCIES} || guix package -i ${DEPENDENCIES} || pkg install ${DEPENDENCIES} || pkg_add ${DEPENDENCIES} || pkgutil -i ${DEPENDENCIES}
    fi
fi
###############################
if [ -e "/usr/bin/curl" ]; then
    curl -Lo /usr/local/bin/debian-i 'https://gitee.com/mo2/linux/raw/master/tool.sh'
else
    wget -qO /usr/local/bin/debian-i 'https://gitee.com/mo2/linux/raw/master/tool.sh'
fi
chmod +x /usr/local/bin/debian-i
#########################
rm -rf ${HOME}/.oh-my-zsh
#https://github.com/ohmyzsh/ohmyzsh
git clone --depth=1 https://gitee.com/mirrors/oh-my-zsh.git ${HOME}/.oh-my-zsh
#chmod 755 -R "${HOME}/.oh-my-zsh"
if [ ! -f "${HOME}/.zshrc" ]; then
    cp "${HOME}/.oh-my-zsh/templates/zshrc.zsh-template" "${HOME}/.zshrc" || curl -Lo "${HOME}/.zshrc" 'https://gitee.com/mirrors/oh-my-zsh/raw/master/templates/zshrc.zsh-template'
    #https://github.com/ohmyzsh/ohmyzsh/raw/master/templates/zshrc.zsh-template
fi
######################
chsh -s /usr/bin/zsh || chsh -s /bin/zsh

RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')

printf "$BLUE"
cat <<-'EndOFneko'
			               .::::..                
			    ::::rrr7QQJi::i:iirijQBBBQB.      
			    BBQBBBQBP. ......:::..1BBBB       
			    .BuPBBBX  .........r.  vBQL  :Y.  
			     rd:iQQ  ..........7L   MB    rr  
			      7biLX .::.:....:.:q.  ri    .   
			       JX1: .r:.r....i.r::...:.  gi5  
			       ..vr .7: 7:. :ii:  v.:iv :BQg  
			       : r:  7r:i7i::ri:DBr..2S       
			    i.:r:. .i:XBBK...  :BP ::jr   .7. 
			    r  i....ir r7.         r.J:   u.  
			   :..X: .. .v:           .:.Ji       
			  i. ..i .. .u:.     .   77: si   1Q  
			 ::.. .r .. :P7.r7r..:iLQQJ: rv   ..  
			7  iK::r  . ii7r LJLrL1r7DPi iJ     r 
			  .  ::.:   .  ri 5DZDBg7JR7.:r:   i. 
			 .Pi r..r7:     i.:XBRJBY:uU.ii:.  .  
			 QB rJ.:rvDE: .. ri uv . iir.7j r7.   
			iBg ::.7251QZ. . :.      irr:Iu: r.   
			 QB  .:5.71Si..........  .sr7ivi:U    
			 7BJ .7: i2. ........:..  sJ7Lvr7s    
			  jBBdD. :. ........:r... YB  Bi      
			     :7j1.                 :  :       

		EndOFneko
printf "$RESET"
###############
configure_power_level_10k() {
    echo "Configuring zsh theme 正在配置zsh主题(powerlevel 10k)..."
    mkdir -p ${HOME}/.oh-my-zsh/custom/themes
    cd ${HOME}/.oh-my-zsh/custom/themes
    rm -rf "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
    git clone --depth=1 https://gitee.com/mo2/powerlevel10k.git "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k" || git clone --depth=1 git://github.com/romkatv/powerlevel10k "${HOME}/.oh-my-zsh/custom/themes/powerlevel10k"
    sed -i '/^ZSH_THEME/d' "${HOME}/.zshrc"
    sed -i "1 i\ZSH_THEME='powerlevel10k/powerlevel10k'" "${HOME}/.zshrc"
    # sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnosterzak"/g' ~/.zshrc
    echo '您可以输p10k configure来配置powerlevel10k'
    if ! grep -q '.p10k.zsh' "${HOME}/.zshrc"; then
        if [ -e "/usr/bin/curl" ]; then
            curl -sLo /root/.p10k.zsh 'https://gitee.com/mo2/Termux-zsh/raw/p10k/.p10k.zsh'
        else
            wget -qO /root/.p10k.zsh 'https://gitee.com/mo2/Termux-zsh/raw/p10k/.p10k.zsh'
        fi

        cat >>${HOME}/.zshrc <<-"ENDOFPOWERLEVEL"
					  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh 
				ENDOFPOWERLEVEL
    fi
}
###################
if [ "$(uname -m)" = "mips" ]; then
    echo "Configuring zsh theme 正在配置zsh主题(agnoster)..."
    sed -i '/^ZSH_THEME/d' "${HOME}/.zshrc"
    sed -i "1 i\ZSH_THEME='agnoster'" "${HOME}/.zshrc"
else
    configure_power_level_10k
fi
#############################
chroot_export_language_and_home() {
    grep -q 'unset LD_PRELOAD' ${HOME}/.zshrc >/dev/null 2>&1 || sed -i "1 a\unset LD_PRELOAD" ${HOME}/.zshrc >/dev/null 2>&1
    grep -q 'zh_CN.UTF-8' ${HOME}/.zshrc >/dev/null 2>&1 || sed -i "$ a\export LANG=zh_CN.UTF-8" ${HOME}/.zshrc >/dev/null 2>&1
    grep -q 'HOME=/root' ${HOME}/.zshrc >/dev/null 2>&1 || sed -i "$ a\export HOME=/root" ${HOME}/.zshrc >/dev/null 2>&1
    grep -q 'cd /root' ${HOME}/.zshrc >/dev/null 2>&1 || sed -i "$ a\cd /root" ${HOME}/.zshrc >/dev/null 2>&1
}
#######################
if [ -e "/tmp/.Chroot-Container-Detection-File" ]; then
    chroot_export_language_and_home
fi
#######################
cd ~

cat >~/.zlogin <<-'EndOfFile'
			cat /etc/os-release | grep PRETTY_NAME |cut -d '"' -f 2

			if [ -f "/root/.vnc/startvnc" ]; then
				/usr/local/bin/startvnc
				echo "已为您启动vnc服务 Vnc service has been started, enjoy it!"
				rm -f /root/.vnc/startvnc
			fi

			if [ -f "/root/.vnc/startxsdl" ]; then
			    echo '检测到您在termux原系统中输入了startxsdl，已为您打开xsdl安卓app'
				echo 'Detected that you entered "startxsdl" from the termux original system, and the xsdl Android application has been opened.'
				rm -f /root/.vnc/startxsdl
			    echo '9s后将为您启动xsdl'
			    echo 'xsdl will start in 9 seconds'
			    sleep 9
				/usr/local/bin/startxsdl
			fi
			ps -e 2>/dev/null | tail -n 20
		EndOfFile
#########################
configure_command_not_found() {
    if [ -e "/usr/lib/command-not-found" ]; then
        grep -q 'command-not-found/command-not-found.plugin.zsh' ${HOME}/.zshrc 2>/dev/null || sed -i "$ a\source ${HOME}/.oh-my-zsh/plugins/command-not-found/command-not-found.plugin.zsh" ${HOME}/.zshrc
        if [ "${DEBIAN_DISTRO}" != "ubuntu" ]; then
            echo "正在配置command-not-found插件..."
            apt-file update 2>/dev/null
            update-command-not-found 2>/dev/null
        fi
    fi
}
######################
if [ "${LINUX_DISTRO}" != "redhat" ]; then
    sed -i "1 c\cat /etc/issue" .zlogin
fi
#######################
if [ "${LINUX_DISTRO}" = "debian" ]; then
    configure_command_not_found
fi
############################
echo "正在克隆zsh-syntax-highlighting语法高亮插件..."
rm -rf ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting 2>/dev/null
mkdir -p ${HOME}/.oh-my-zsh/custom/plugins

git clone --depth=1 https://gitee.com/mo2/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || git clone --depth=1 git://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh-syntax-highlighting ${HOME}/.oh-my-zsh/custom/plugins/

grep -q 'zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ${HOME}/.zshrc >/dev/null 2>&1 || sed -i "$ a\source ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ${HOME}/.zshrc
#echo -e "\nsource ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${HOME}/.zshrc
#######################
echo "正在克隆zsh-autosuggestions自动补全插件..."
rm -rf ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions 2>/dev/null

git clone --depth=1 https://gitee.com/mo2/zsh-autosuggestions.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions || git clone --depth=1 git://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestionszsh-autosuggestions

grep -q '/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh' ${HOME}/.zshrc >/dev/null 2>&1 || sed -i "$ a\source ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ${HOME}/.zshrc
#echo -e "\nsource ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${HOME}/.zshrc
#####################################
if grep -Eq 'Bionic|Buster' /etc/os-release; then
    sed -i 's/plugins=(git)/plugins=(git extract)/g' ~/.zshrc
fi

if [ "${LINUX_DISTRO}" = "debian" ] || [ "${LINUX_DISTRO}" = "arch" ]; then
    sed -i 's/plugins=(git)/plugins=(git extract z)/g' ~/.zshrc
else
    sed -i 's/plugins=(git)/plugins=(git extract)/g' ~/.zshrc
fi
############################
if [ -f "/tmp/.openwrtcheckfile" ]; then
    ADMINACCOUNT="$(ls -l /home | grep ^d | head -n 1 | awk -F ' ' '$0=$NF')"
    cp -rf /root/.z* /root/.oh-my-zsh /root/*sh /home/${ADMINACCOUNT}
    rm -f /tmp/.openwrtcheckfile
fi
########################
echo 'All optimization steps have been completed, enjoy it!'
echo 'zsh配置完成，2s后将为您启动Tmoe-linux工具'
echo "您也可以手动输${YELLOW}debian-i${RESET}进入"
echo 'After 2 seconds, Tmoe-linux tool will be launched.'
echo 'You can also enter debian-i manually to start it.'
sleep 2s
bash /usr/local/bin/debian-i
exec zsh -l || source ~/.zshrc
