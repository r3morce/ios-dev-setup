#!/bin/bash

# Farben für Ausgaben
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging Funktionen
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Prüfen ob ein Befehl existiert
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Homebrew Installation
install_homebrew() {
    if ! command_exists brew; then
        log_info "Installiere Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -ne 0 ]; then
            log_error "Homebrew Installation fehlgeschlagen"
            exit 1
        fi
        
        # Füge Homebrew zum PATH hinzu (für Apple Silicon Macs)
        if [[ $(uname -m) == 'arm64' ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_info "Homebrew ist bereits installiert"
    fi
}

# Oh My Zsh Installation
install_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installiere Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        if [ $? -ne 0 ]; then
            log_error "Oh My Zsh Installation fehlgeschlagen"
            return 1
        fi
    else
        log_info "Oh My Zsh ist bereits installiert"
    fi
}

# Installation der Brew Pakete
install_brew_packages() {
    local packages=(
        "fastlane"
        "swiftgen"
        "swiftlint"
        "neovim"
        "wezterm"
    )
    
    log_info "Installiere Brew Pakete..."
    for package in "${packages[@]}"; do
        if ! brew list "$package" &>/dev/null; then
            log_info "Installiere $package..."
            brew install "$package"
            if [ $? -ne 0 ]; then
                log_warning "Installation von $package fehlgeschlagen"
            fi
        else
            log_info "$package ist bereits installiert"
        fi
    done
}

# Installation der Cask Apps
install_cask_apps() {
    local apps=(
        "firefox"
        "slack"
        "obsidian"
        "keepassxc"
        "karabiner-elements"
        "raycast"
    )
    
    log_info "Installiere Cask Apps..."
    for app in "${apps[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            log_info "Installiere $app..."
            brew install --cask "$app"
            if [ $? -ne 0 ]; then
                log_warning "Installation von $app fehlgeschlagen"
            fi
        else
            log_info "$app ist bereits installiert"
        fi
    done
}

# Xcode Installation
install_xcode() {
    if ! command_exists xcode-select; then
        log_info "Installiere Xcode Command Line Tools..."
        xcode-select --install
        if [ $? -ne 0 ]; then
            log_error "Xcode Command Line Tools Installation fehlgeschlagen"
            return 1
        fi
    else
        log_info "Xcode Command Line Tools sind bereits installiert"
    fi
    
    # Prüfe ob Xcode aus dem App Store installiert werden muss
    if ! command_exists xcodebuild; then
        log_warning "Bitte installiere Xcode manuell aus dem App Store"
        log_warning "Führe danach folgende Befehle aus:"
        log_warning "sudo xcodebuild -license accept"
        log_warning "sudo xcodebuild -runFirstLaunch"
        return 1
    fi
}

# LazyVim Installation
install_lazyvim() {
    if [ ! -d "$HOME/.config/nvim" ]; then
        log_info "Installiere LazyVim..."
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        if [ $? -ne 0 ]; then
            log_error "LazyVim Installation fehlgeschlagen"
            return 1
        fi
        # Entferne .git Verzeichnis um eigene Konfiguration zu ermöglichen
        rm -rf ~/.config/nvim/.git
    else
        log_info "Neovim Konfiguration existiert bereits"
    fi
}

# Hauptfunktion
main() {
    log_info "Starte Mac Setup..."
    
    # Prüfe ob Script als root läuft
    if [ "$EUID" -eq 0 ]; then
        log_error "Bitte führe das Script nicht als root aus!"
        exit 1
    }
    
    install_homebrew || exit 1
    install_omz
    install_xcode
    install_brew_packages
    install_cask_apps
    install_lazyvim
    
    log_info "Setup abgeschlossen!"
    log_info "Bitte starte deinen Terminal neu, damit alle Änderungen wirksam werden."
    log_warning "Vergiss nicht, Xcode aus dem App Store zu installieren, falls noch nicht geschehen."
}

# Starte das Script
main
