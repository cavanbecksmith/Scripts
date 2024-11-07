# Function to install Docker for root
install_docker_root() {
    # Install Docker prerequisites
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    # Set Docker repository and GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Install Docker as root
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
}

# Function to install Docker in rootless mode
install_docker_rootless() {
    # Install Docker prerequisites
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    # Install Docker as rootless
    curl -fsSL https://get.docker.com/rootless | sh

    # Set up environment variables for rootless Docker
    export PATH=/home/$USER/bin:$PATH
    export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
    echo "export PATH=/home/$USER/bin:\$PATH" >> ~/.bashrc
    echo "export DOCKER_HOST=unix:///run/user/\$(id -u)/docker.sock" >> ~/.bashrc
}


if [ $1 = "root" ]; then
    install_docker_root
elif [ $1 = "rootless"];then
    install_docker_rootless
fi