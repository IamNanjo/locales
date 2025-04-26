#!/usr/bin/env bash

if grep -qiE '^(ID|ID_LIKE)=(arch|.*arch.*)' /etc/os-release; then
	sudo cp en_FI /usr/share/i18n/locales/

	# Uncomment locale if exists in /etc/locale.gen
	sudo sed -i 's/^# *en_FI.UTF-8 UTF-8$/en_FI.UTF-8 UTF-8/' /etc/locale.gen

	# Add locale if it is not in /etc/locale.gen
	if ! grep -qE '^en_FI.UTF-8 UTF-8$' /etc/locale.gen; then
		echo "en_FI.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
	fi

	sudo locale-gen
	echo
else
	sudo localedef -f UTF-8 -i en_FI en_FI.UTF-8
fi

CONFIG_FILES=("$HOME/.bashrc" "$HOME/.zshrc")
CONFIG_LANG="export LANG=en_FI.UTF-8"
CONFIG_LC_ALL="export LC_ALL=en_FI.UTF-8"

for CONFIG_FILE in ${CONFIG_FILES[@]}; do
	if ! [ -w $CONFIG_FILE ]; then
		echo "$CONFIG_FILE is not a writable file"
		unset -v CONFIG_FILE
		exit 1
	fi

	LANG_ALREADY_SET=$(grep -qiE "export LANG=['\"]?en_FI.UTF-8['\"]?" $CONFIG_FILE && echo true || echo false)
	LC_ALL_ALREADY_SET=$(grep -qiE "export LC_ALL=['\"]?en_FI.UTF-8['\"]?" $CONFIG_FILE && echo true || echo false)

	if [ "$LANG_ALREADY_SET" = true ] && [ "$LC_ALL_ALREADY_SET" = true ]; then
		echo "Locale already enabled in $CONFIG_FILE"
		continue
	else
		echo "Enabling locale in $CONFIG_FILE"
	fi

	[ "$LANG_ALREADY_SET" = false ] && echo LANG_ALREADY_SET
	[ "$LC_ALL_ALREADY_SET" = false ] && echo LC_ALL_ALREADY_SET
	echo
done
