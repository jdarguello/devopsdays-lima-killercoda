#Usar el contexto del clúster local
export current_context=$(k config current-context)

#Descargar el repositorio con el custom-cli
cd ~/
git clone --recurse-submodules https://github.com/lima-demos-days/CloudManager
cd ~/CloudManager/platform-engineering/CLI/

#Definir .env
echo "GITHUB_TOKEN=$(k get secrets backstage-secrets -o jsonpath="{.data.GITHUB_TOKEN}" | base64 -d)" > .env
echo "GITHUB_USER=$(k get secrets backstage-secrets -o jsonpath="{.data.GITHUB_USER}" | base64 -d)" >> .env
echo "AWS_ACCESS_KEY_ID=$(k get secrets awssm-secret -o jsonpath="{.data.access-key}" | base64 -d)" >> .env
echo "AWS_SECRET_ACCESS_KEY=$(k get secrets awssm-secret -o jsonpath="{.data.secret-access-key}" | base64 -d)" >> .env

#Retornar al cluster del usuario
k config use-context $current_context