varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "Para eu configurar o git, me diz qual nome queres que eu use, lembra, esse nome vai aparecer para as outras pessoas da empresa poderem te reconhecer, geralmente usam o primeiro e último nome: "
    read varGitUserName


    echo "Confirma o nome $varGitUserName (s/n)?"
    read varConfirm
done

varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "Para eu configurar o git, me diz qual o email da tua conta:"
    read varGitUserEmail


    echo "Confirma o email $varGitUserEmail (s/n)?"
    read varConfirm
done

varConfirm=""
while [ "$varConfirm" != "s" ]
do
    echo "Vou configurar o plat, me passa o teu usuário, geralmente é algo assim: joao.pereira
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
    echo "E agora a senha:" 
    read varPlatPassword


    echo "Confirma a senha $varPlatPassword (s/n)?"
    read varConfirm
done

# config git
git config --global user.name "$varGitUserName"
git config --global user.email "$varGitUserEmail"

yes "" | ssh-keygen
ssh-add

echo "Agora precisamos adicionar a chave publica do ssh no github,  aperta enter quando terminar"
read

mkdir /workspace
cd /workspace
git clone git@github.com:chaordic/platform-api-tools.git
sudo ln -s /workspace/platform-api-tools/plat-get-client /bin
sudo ln -s /workspace/platform-api-tools/plat-update-client /bin

echo "
export PLAT_HOME=/opt/platform-api-tools/
export PATH=\$PATH:\$PLAT_HOME
# Credentials
export PLAT_USER=$varPlatUser
export PLAT_PASSWORD=$varPlatPassword
" > ~/.bashrc