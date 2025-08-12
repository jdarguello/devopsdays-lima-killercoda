#aws-cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#flux
curl -s https://fluxcd.io/install.sh | sudo bash
. <(flux completion bash)

#devbox
curl -fsSL https://get.jetify.com/devbox | bash