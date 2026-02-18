#!/bin/bash

# Backup the current .bashrc
cp ~/.bashrc ~/.bashrc.backup

# Extract SDKMAN lines and save them temporarily
grep -E "SDKMAN_DIR=|source.*sdkman-init.sh" ~/.bashrc > /tmp/sdkman_temp

# Remove SDKMAN lines from current .bashrc
sed -i.bak "/SDKMAN_DIR=/d;/source.*sdkman-init.sh/d" ~/.bashrc

# Append JDK_HOME and JAVA_HOME exports
echo "" >> ~/.bashrc
echo "# Dynamic exports for JDK_HOME and JAVA_HOME based on sdkman" >> ~/.bashrc
echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bashrc
echo 'sdkman_java_version=$(sdk current java | grep "Using java version" | cut -d" " -f4)' >> ~/.bashrc
echo 'sdkman_java_home=$(sdk home java $sdkman_java_version)' >> ~/.bashrc

echo 'case $(uname) in' >> ~/.bashrc
echo '    "Darwin") SETTINGS_PATH=~/Library/Application\ Support/Code/User/settings.json ;;' >> ~/.bashrc
echo '    "Linux") SETTINGS_PATH=~/.config/Code/User/settings.json ;;' >> ~/.bashrc
echo '    "Windows"|"CYGWIN"*) SETTINGS_PATH=C:/Users/$USERNAME/AppData/Roaming/Code/User/settings.json ;;' >> ~/.bashrc
echo '    *) echo "Unsupported OS"; exit 1 ;;' >> ~/.bashrc
echo 'esac' >> ~/.bashrc
echo '' >> ~/.bashrc
echo '# Backup the current settings.json if it exists' >> ~/.bashrc
echo 'if [[ -f "$SETTINGS_PATH" ]]; then' >> ~/.bashrc
echo '    cp "$SETTINGS_PATH" "$SETTINGS_PATH.backup"' >> ~/.bashrc
echo 'fi' >> ~/.bashrc
echo '' >> ~/.bashrc
echo '# Populate settings.json with java values' >> ~/.bashrc
echo '# Extract the Java version number from sdkman_java_version' >> ~/.bashrc
echo 'JAVA_VERSION_NUMBER=$(echo "$sdkman_java_version" | grep -oE '\''[0-9]+'\'')' >> ~/.bashrc
echo 'cat > "$SETTINGS_PATH" <<EOL' >> ~/.bashrc
echo '{' >> ~/.bashrc
echo '    "java.configuration.runtimes": [' >> ~/.bashrc
echo '        {' >> ~/.bashrc
echo '            "name": "JavaSE-$JAVA_VERSION_NUMBER",' >> ~/.bashrc
#echo '            "name": "$sdkman_java_version",' >> ~/.bashrc
echo '            "path": "$sdkman_java_home",' >> ~/.bashrc
echo '            "sources": "$sdkman_java_home/lib/src.zip",' >> ~/.bashrc
echo '            "javadoc": "$sdkman_java_home/legal",' >> ~/.bashrc
echo '            "default": true' >> ~/.bashrc
echo '        }' >> ~/.bashrc
echo '    ]' >> ~/.bashrc
echo '}' >> ~/.bashrc
echo 'EOL' >> ~/.bashrc


echo 'export JDK_HOME=$sdkman_java_home' >> ~/.bashrc
echo 'export JAVA_HOME=$sdkman_java_home' >> ~/.bashrc

# Append the SDKMAN lines back to the end
cat /tmp/sdkman_temp >> ~/.bashrc

# Clean up the temporary file
rm /tmp/sdkman_temp

echo "Updated .bashrc successfully!"