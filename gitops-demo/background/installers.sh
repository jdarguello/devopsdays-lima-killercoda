#nginx ingress-controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.13.1/deploy/static/provider/cloud/deploy.yaml

#aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#flux
curl -s https://fluxcd.io/install.sh | sudo bash
. <(flux completion bash)

#devbox
curl -fsSL https://get.jetify.com/devbox | bash