# Locales

Custom locale(s) I use with Linux.

## Installation

### Automatic installation

The automatic install script works for bash and zsh.
It makes the locale available system wide and enables it for bash and zsh.

```bash
./install.sh
```

### Basic installation

This example installs and enables the en_FI locale.

```bash
sudo localedef -f UTF-8 -i en_FI en_FI.UTF-8
```

### Arch and Arch based distros

```bash
sudo cp en_FI /usr/share/i18n/locales/
echo "en_FI.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
```

## Usage

Enable the locale by exporting LANGUAGE and LC_ALL environment variables.

```bash
export LANG="en_FI.UTF-8"
export LC_ALL="en_FI.UTF-8"
```
