
#!/bin/bash

# Check if flag.txt exists
if [ ! -f ./flag.txt ]; then
    echo "Flag does not exists. First time boot..."
    # Update the system
    echo "Updating the system..."
    sudo apt-get update
    sudo apt-get upgrade -y

    # Install necessary tools for C++ development
    echo "Installing necessary tools for C++ development..."
    sudo apt-get install -y clang cmake

    # Install additional utilities
    echo "Installing additional utilities..."
    sudo apt-get install -y curl wget unzip git bc

    # Install Rust
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

    # Configure Git with your information
    echo "Configuring Git..."
    # read -p "Enter your GitHub name: " github_name
    # read -p "Enter your GitHub email: " github_email

    git config --global user.name "janmajayamall"
    git config --global user.email "janmajayamall@protonmail.com"
    git config --global credential.helper cache
    # 1 month == 2.6 million seconds
    # 3 monthds == 7.8 million seconds
    git config --global credential.helper 'cache --timeout=7800000'

    # Prompt for GitHub Personal Access Token
    # echo "Please enter your GitHub Personal Access Token."
    # read -p "Token: " token

    # Set up GitHub authentication
    # echo "Setting up GitHub authentication..."
    # git config --global credential.helper store
    # git credential-store --file ~/.git-credentials store

    # # Store the token in the credentials file
    # echo "Storing GitHub token in the credentials file..."
    # echo "https://github.com:${token}@github.com" > ~/.git-credentials

    # Install Fish shell
    echo "Installing Fish shell..."
    sudo apt-get install -y fish

    # Set Fish shell as the default shell
    echo "Setting Fish shell as the default shell..."
    echo "/usr/bin/fish" | sudo tee -a /etc/shells
    chsh -s /usr/bin/fish

    # Set cargo bin path to Fish shell
    echo "Adding cargo path to fish config"
    fish_config="/root/.config/fish/config.fish"
    config_dir=$(dirname "$fish_config")
    mkdir -p "$config_dir"
    # Check if the fish.config file exists
    if [ ! -f "$fish_config" ]; then
        # Create the fish.config file if it doesn't exist
        touch "$fish_config"
    fi
    echo 'set PATH $PATH /root/.cargo/bin' >> "$fish_config"
    # echo 'set PATH $PATH /root/.rustup/bin' >> "$fish_config"


    # Create flag.txt
    echo "This is the flag." > ./flag.txt

    echo "Installation complete and created flag.txt"
else
  echo "flag.txt already exists. Not first time boot..."
fi

# run idle script

# Define the number of consecutive checks required for idle state
consecutive_checks=30

# Define the threshold for CPU load (change as needed)
threshold=0.1

# Initialize idle check counter
idle_counter=0

# Check CPU usage and idle state
while true; do
    
  # Get the CPU load average for the past 1 minute
  load_average=$(uptime | sed -e 's/.*load average: //g' | awk '{ print $1 }') # 1-minute average load
  load_average="${load_average//,}" # remove trailing comma

  # Check if CPU load is below the threshold
  if (( $(echo "$load_average < $threshold" | bc -l) )); then
    idle_counter=$((idle_counter + 1))
    echo "CPU load is below the threshold. Idle counter: $idle_counter"
  else
    idle_counter=0
    echo "CPU load is above the threshold. Resetting idle counter."
  fi
  
  # Check if the idle counter reaches the consecutive check limit
  if [ $idle_counter -ge $consecutive_checks ]; then
    echo "The CPU has been idle for $consecutive_checks consecutive checks. Shutting down..."
    sudo poweroff
    exit 0
  fi
  
 
  sleep 60
done
