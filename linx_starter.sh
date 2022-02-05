#!/user/bin/env bash
sudo apt update
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
# git user.name
varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "Para eu configurar o git, me diz qual nome queres que eu use, lembra, esse nome vai aparecer para as outras pessoas da empresa poderem te reconhecer, geralmente usam o primeiro e último nome: "
    read varGitUserName

  
    echo "Confirma o nome $varGitUserName (s/n)?"
    read varConfirm
done

# git user.email
varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "Para eu configurar o git, me diz qual o email da tua conta:"
    read varGitUserEmail

  
    echo "Confirma o email $varGitUserEmail (s/n)?"
    read varConfirm
done

# platform user
varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "Vou configurar o plat pra ti, me passa o teu usuário, geralmente é algo assim: joao.pereira
    Qual o teu:
    " 
    read varPlatUser

  
    echo "Confirma o usuário $varPlatUser (s/n)?"
    read varConfirm
done

#platform password
varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "E agora a tua senha:" 
    read varPlatUser

  
    echo "Confirma a senha $varPlatPassword (s/n)?"
    read varConfirm
done

# PART 2 - installing
figlet "PARTE 2 - Instalando"

## INSTALL MINIMAL ##

sudo apt upgrade -y

sudo apt autoremove -y

sudo apt install jq vim git zsh curl build-essential htop -y

# install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh

cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo zsh > ~/.bashrc

# install pritunl - vpn

sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt focal main
EOF

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt-get update
sudo apt-get install pritunl-client-electron -y

# CONFIGURE #

# install nvm - nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

echo "
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"  # This loads nvm bash_completion
" > ~/.zshrc

nvm install 10

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

#----------------------------------

# install slack via snap
sudo snap install slack --classic

# install discord via snap
sudo snap install discord

# install vscode via snap
sudo snap install code --classic

# creating ssh key
yes "" | ssh-keygen -t ed25519 -C \"$varGitUserEmail\"
ssh-add ~/.ssh/id_ed25519


# PART 3
# add ssh-key to github
figlet "PARTE 3 - Trabalhando em equipe"
echo "----------------------------------------------
Agora chegou o momento que eu vou precisar da tua ajuda! A gente precisa adicionar essa chave ssh aqui de baixo no github:
"
cat ~/.ssh/id_ed25519.pub
echo "
Segue esse passo-a-passo aqui que ele te ensina como faz: (pode começar a partir do segundo passo, o primeiro é só pegar essa chave aqui de cima, ja fui adiantando pra ti) 
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

Aperta enter quando terminar
"
read

#install platform
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

source .zshrc

# end of script
echo "------------------"
figlet "FIM"
echo "
Reiniciando em 10 segundos para mudanças fazerem efeito (CTRL + C para cancelar)"
sleep 10
reboot