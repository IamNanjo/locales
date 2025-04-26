#!/usr/bin/env bash

# Add Finnish compose definitions
sudo mkdir -p /usr/share/X11/locale/en_FI.UTF-8
sudo cp ./en_FI.UTF-8/Compose /usr/share/X11/locale/en_FI.UTF-8/Compose

if grep -qiE '^(ID|ID_LIKE)=(arch|.*arch.*)' /etc/os-release; then
	localefile="en_FI"
	localeoutfile="/usr/share/i18n/locales/$localefile"
	! [ -f "$localeoutfile" ] && sudo cp $localefile $localeoutfile

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
CONFIG_XCOMPOSEFILE="export XCOMPOSEFILE=/usr/share/X11/locale/fi_FI.UTF-8/Compose"

for CONFIG_FILE in ${CONFIG_FILES[@]}; do
	if ! [ -w $CONFIG_FILE ]; then
		echo "$CONFIG_FILE is not a writable file"
		unset -v CONFIG_FILE
		exit 1
	fi

	LANG_ALREADY_SET=$(grep -qiE "export LANG=['\"]?en_FI.UTF-8['\"]?" $CONFIG_FILE && echo true || echo false)
	LC_ALL_ALREADY_SET=$(grep -qiE "export LC_ALL=['\"]?en_FI.UTF-8['\"]?" $CONFIG_FILE && echo true || echo false)
	XCOMPOSEFILE_ALREADY_SET=$(grep -qiE "export XCOMPOSEFILE=" $CONFIG_FILE && echo true || echo false)


	if [ "$LANG_ALREADY_SET" = true ] && [ "$LC_ALL_ALREADY_SET" = true ] && [ "$XCOMPOSEFILE_ALREADY_SET" = true ]; then
		echo "Locale already enabled in $CONFIG_FILE"
		continue
	else
		echo "Enabling locale in $CONFIG_FILE"
	fi

	[ "$XCOMPOSEFILE_ALREADY_SET" = false ] && echo "$CONFIG_XCOMPOSEFILE" | tee -a "$CONFIG_FILE"
	[ "$LANG_ALREADY_SET" = false ] && echo "$CONFIG_LANG" | tee -a "$CONFIG_FILE"
	[ "$LC_ALL_ALREADY_SET" = false ] && echo "$CONFIG_LC_ALL" | tee -a "$CONFIG_FILE"
	echo
done
