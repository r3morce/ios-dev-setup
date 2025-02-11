# iOS Development Environment Setup

Dieses Repository enthält ein automatisiertes Setup-Script für die Einrichtung einer iOS-Entwicklungsumgebung auf macOS. Es installiert und konfiguriert alle notwendigen Tools und Anwendungen für die iOS-Entwicklung.

## 📝 Hinweis

Xcode muss manuell aus dem App Store installiert werden.

## 🚗 Schnellstart

1. Repository klonen:
```bash
git clone https://github.com/r3morce/ios-dev-setup.git
cd ios-dev-setup
```

2. Script ausführbar machen:
```bash
chmod +x setup.sh
```

3. Script ausführen:
```bash
./setup.sh
```

## ⚙️ Was wird installiert?

### Entwicklungstools
- Homebrew (Paketmanager)
- Xcode Command Line Tools
- Fastlane
- SwiftGen
- SwiftLint

### Terminal & Editor
- Zsh & Oh My Zsh
- WezTerm
- Neovim mit LazyVim

### Anwendungen
- Firefox
- Slack
- Obsidian
- KeePassXC
- Karabiner-Elements
- Raycast

## 🛠️ Anpassungen

Das Script ist modular aufgebaut und kann erweitert werden. Neue Pakete können in den Arrays `packages` und `apps` hinzugefügt werden.

```bash
# Brew Pakete
local packages=(
    "fastlane"
    "swiftgen"
    # Füge neue Pakete hier hinzu
)

# Cask Apps
local apps=(
    "firefox"
    "slack"
    # Füge neue Apps hier hinzu
)
```
