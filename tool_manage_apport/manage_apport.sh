#!/usr/bin/env bash
#
# manage_apport.sh
#
# This script helps manage or remove the Apport crash-reporting system when
# it's causing high CPU usage on Ubuntu.

# Exit if any command fails
set -e

# Check if the user is root (necessary for package removal, editing config, etc.)
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this script as root (e.g., sudo ./manage_apport.sh)."
  exit 1
fi

echo "======================================"
echo " Apport (Crash Reporter) Management"
echo "======================================"
echo
echo "Apport is Ubuntu's built-in crash reporting tool. Sometimes it can get"
echo "stuck at 100% CPU usage due to a corrupted crash file or internal error."
echo
echo "Select an action to take:"
echo "1) Kill the apport-gtk process (temporary fix)."
echo "2) Disable Apport to prevent it from running on startup."
echo "3) Remove Apport (and apport-gtk) entirely from the system."
echo "4) Clean old crash reports in /var/crash (which may fix stuck processes)."
echo "5) Exit without doing anything."
echo

read -rp "Enter your choice [1-5]: " CHOICE

case "$CHOICE" in

  1)
    echo
    echo "You chose to kill the apport-gtk process."
    echo "Explanation: This stops the current stuck process but does not prevent"
    echo "it from restarting later if another crash occurs."
    echo
    echo "Killing apport-gtk..."
    killall apport-gtk || true
    echo "Done."
    ;;

  2)
    echo
    echo "You chose to disable Apport."
    echo "Explanation: This prevents Apport from being triggered automatically."
    echo "The service won't run at boot, which stops further crash-report handling."
    echo
    echo "Disabling Apport by setting enabled=0 in /etc/default/apport..."
    sed -i 's/^enabled=.*/enabled=0/' /etc/default/apport || echo "enabled=0" >> /etc/default/apport
    systemctl disable apport.service || true
    systemctl stop apport.service || true
    echo "Done."
    ;;

  3)
    echo
    echo "You chose to completely remove Apport."
    echo "Explanation: This uninstalls the crash-reporting packages, freeing you"
    echo "from Apport processes entirely. You will no longer get automatic crash"
    echo "reports in Ubuntu."
    echo
    echo "Removing apport and apport-gtk..."
    apt remove -y apport apport-gtk
    echo "Done."
    ;;

  4)
    echo
    echo "You chose to clean out /var/crash."
    echo "Explanation: Large or corrupted crash files in /var/crash can cause Apport"
    echo "to spin at 100% CPU. Deleting them may fix the stuck process."
    echo
    echo "Removing crash files in /var/crash..."
    rm -f /var/crash/*
    echo "Done."
    ;;

  5)
    echo
    echo "No action taken. Exiting."
    ;;

  *)
    echo
    echo "Invalid choice. Exiting without changes."
    ;;
esac

echo
echo "Script complete."
