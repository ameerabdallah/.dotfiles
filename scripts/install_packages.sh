#!/bin/bash

indent() {
    sed 's/^/    /'
}

# cyan
info() {
    echo -e "\033[0;36m$1\033[0m"
}

# red
error() {
    echo -e "\033[0;31m$1\033[0m"
}

# yellow
warning() {
    echo -e "\033[0;33m$1\033[0m"
}

# determine OS
os=$(uname)
case "$os" in
    "Linux") # For Linux and WSL        
        packages=(
            "curl"
            "git"
            "gnupg"
            "jq"
            "make"
            "python3"
            "python3-pip"
            "python3-venv"
            "wget"
            "glow"
            "eza"
        )

        missing_packages=()

        # check if packages are installed
        info "Checking if packages are installed..."
        for package in "${packages[@]}"; do
            # if not installed, add to missing_packages
            info "Checking if $package is installed..." | indent
            if ! dpkg -s "$package" >/dev/null 2>&1; then 
                missing_packages+=("$package") 
                warning "$package is not installed" | indent
            fi
        done

        if [ ${#missing_packages[@]} -eq 0 ]; then
            info "All packages are already installed."
            exit 0
        else
            info "The following packages are missing: ${missing_packages[*]}"
        fi

        keyrings_path="/etc/apt/keyrings"
        list_path="/etc/apt/sources.list.d"
        # Setup keyrings
        sudo mkdir -p $keyrings_path

        # Gierens keyring
        gierens_keyring="$keyrings_path/gierens.gpg"
        gierens_list="$list_path/gierens.list"
        # Eza keyring
        if [ ! -f /etc/apt/keyrings/gierens.gpg ]; then
            wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o $gierens_keyring
            echo "deb [signed-by=$gierens_keyring] http://deb.gierens.de stable main" | sudo tee $gierens_list
            sudo chmod 644 $gierens_keyring $gierens_list
        fi

        charm_keyring="$keyrings_path/charm.gpg"
        charm_list="$list_path/charm.list"
        # Glow keyring
        if [ ! -f $charm_keyring ]; then
            curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o $charm_keyring
            echo "deb [signed-by=$charm_keyring] https://repo.charm.sh/apt/ * *" | sudo tee $charm_list
            sudo chmod 644 $charm_keyring $charm_list
        fi

        sudo apt update
        sudo apt install -y "${missing_packages[@]}"

        info "Done installing packages."
        ;;
    "Darwin") # For macOS
        packages=(
            "curl"
            "git"
            "gnupg"
            "jq"
            "make"
            "python"
            "wget"
            "glow"
            "eza"
        )

        missing_packages=()

        # check if packages are installed
        info "Checking if packages are installed..."

        for package in "${packages[@]}"; do
            # if not installed, add to missing_packages
            info "Checking if $package is installed..." | indent
            if ! brew list "$package" >/dev/null 2>&1 ; then
                warning "$package is not installed" | indent
                missing_packages+=("$package") 
            fi
        done

        if [ ${#missing_packages[@]} -eq 0 ]; then
            info "All packages are already installed."
            exit 0
        else
            info "The following packages are missing: ${missing_packages[*]}"
        fi

        # install missing packages
        info "Installing missing packages..."
        brew install "${missing_packages[@]}"
        ;;
    *)
        echo "Unsupported OS: $os"
        exit 1
esac
