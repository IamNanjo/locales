# Locales

Custom locale(s) I use with Linux.

## Installation

This example installs and enables the en_FI locale.

```bash
sudo localedef -f UTF-8 -i en_FI en_FI.UTF-8
```

Enable the locale by exporting LANGUAGE and LC_ALL environment variables.

```bash
export LANGUAGE="en_FI.UTF-8"
export LC_ALL="en_FI.UTF-8"
```
