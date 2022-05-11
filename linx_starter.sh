#!/bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install figlet lolcat -y

figlet "LINX IMPULSE" | lolcat
echo "---------------------------------------"

echo "Acabou de entrar na linx, parabéns! Vamo manda bala? Primeiro de tudo me diz seu nome pra gente começar:"
read varName

echo "
Prazer em te conhecer $varName, vou te explicar como eu funciono, consisto de três partes:
1. Preciso de umas informações pra ir completando a instalação pra ti, assim tu não precisa ficar voltando aqui pra preencher ;) 
2. Depois disso vou instalar tudo que pode ser feito pelo terminal
3. Por último te explicar passo-a-passo e fornecer links para as partes que eu não consigo fazer sozinho - nessa parte conto contigo para me ajudar!
Terminando, vai estar tudo certo e podes começar a trabalhar!
"
# PART 1 - GET INFORMATION #
figlet "PARTE 1 - Coletando dados"

gitConfirm=""
while [ "$gitConfirm" != "s" || "$gitConfirm" != "n" ]; do
    echo "Você ja tem uma conta no github? (s/n)"
    read varConfirm
done
if [ "$gitConfirm" == "s" ]; then
    # git user.name
    varConfirm=""
    while [ "$varConfirm" != "s" ]; do
        echo "Para eu configurar o git, me diz qual nome queres que eu use, lembra, esse nome vai aparecer para as outras pessoas da empresa poderem te reconhecer, geralmente usam o primeiro e último nome: "
        read varGitUserName

    
        echo "Confirma o nome $varGitUserName (s/n)?"
        read varConfirm
    done

    # git user.email
    varConfirm=""
    while [ "$varConfirm" != "s" ]; do
        echo "Para eu configurar o git, me diz qual o email da tua conta:"
        read varGitUserEmail

    
        echo "Confirma o email $varGitUserEmail (s/n)?"
        read varConfirm
    done
fi
###############
platConfirm=""
while [ "$platConfirm" != "s" || "$platConfirm" != "n" ]; do
    echo "Você ja tem uma conta no platform? (s/n)"
    read platConfirm
done
if [ "$platConfirm" == "s" ]; then
    # platform user
    varConfirm=""
    while [ "$varConfirm" != "s" ]; do
        echo "Vou configurar o plat pra ti, me passa o teu usuário, geralmente é algo assim: joao.pereira
        Qual o teu:
        " 
        read varPlatUser

    
        echo "Confirma o usuário $varPlatUser (s/n)?"
        read varConfirm
    done

    #platform password
    varConfirm=""
    while [ "$varConfirm" != "s" ]; do
        echo "E agora a tua senha:" 
        read varPlatPassword

    
        echo "Confirma a senha $varPlatPassword (s/n)?"
        read varConfirm
    done
fi
# PART 2 - installing
figlet "PARTE 2 - Instalando"

## INSTALL MINIMAL ##
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt install jq vim git zsh curl build-essential htop -y

# install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
# nvm install node
# nvm install 10

if [ "$gitConfirm" ==  "s" ]; then
    # config git
    git config --global user.name "$varGitUserName"
    git config --global user.email "$varGitUserEmail"
fi

# install oh-my-zsh
yes "y" | git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
cp -v ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
echo "zsh" > ~/.bashrc

# install pritunl - vpn
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt focal main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get install pritunl-client-electron -y

# DOCKER CONFIG -----------------------
# install docker
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo docker run hello-world

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version
# needs to add this commands
# sudo groupadd docker
# sudo usermod -aG docker \$USER
# newgrp docker
#----------------------------------
# install microsoft teams
cd ~/Downloads && wget -O teams.deb https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_1.3.00.5153_amd64.deb && sudo apt install ./teams.deb

# install slack via snap
sudo snap install slack --classic

# install discord via apt
sudo snap install discord

# install vscode via snap
sudo snap install code --classic

#configure git in github
if [ "$gitConfirm" ==  "s" ]; then
    # creating ssh key
    yes "" | ssh-keygen
    sudo chmod 600 ~/.ssh/id_rsa
    sudo chmod 644 ~/.ssh/id_rsa.pub
    ssh-add

    # PART 3
    # add ssh-key to github
    figlet "PARTE 3 - Trabalhando em equipe"
    echo "----------------------------------------------
    Agora chegou o momento que eu vou precisar da tua ajuda! A gente precisa adicionar essa chave ssh aqui de baixo no github:
    "
    cat ~/.ssh/id_rsa.pub
    echo "
    Segue esse passo-a-passo aqui que ele te ensina como faz: (pode começar a partir do segundo passo, o primeiro é só pegar essa linha aqui de cima, ja fui adiantando pra ti) 
    https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
    PELO AMOR DE DEUS, NÃO APERTA CTRL + C, COPIAR É CTRL + SHIFT + C

    Aperta enter quando terminar
    "
    read
fi

#install platform
if [ "$platConfirm" == "s" ];
then
    mkdir ~/workspace
    cd ~/workspace
    git clone git@github.com:chaordic/platform-api-tools.git
    sudo ln -s ~/workspace/platform-api-tools/plat-get-client /bin
    sudo ln -s ~/workspace/platform-api-tools/plat-update-client /bin

    echo "
    export PLAT_HOME=/opt/platform-api-tools/
    export PATH=\$PATH:\$PLAT_HOME
    # Credentials
    export PLAT_USER=$varPlatUser
    export PLAT_PASSWORD=$varPlatPassword
    " > ~/.zshrc
fi

# end of script
echo "------------------"
figlet "FIM"
echo "
Entrando no zsh em 5 segundos"
sleep 5
zsh
