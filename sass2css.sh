#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# Todo: Add js complilation.

command -v inotifywait >/dev/null 2>&1 || sudo apt install -y inotify-tools
command -v xdotool >/dev/null 2>&1 || sudo apt install -y xdotool
command -v sass >/dev/null 2>&1 || { echo -e "\ndart-sass is required but it is not installed.\nInstall the latest Linux version from $(curl -s "https://api.github.com/repos/sass/dart-sass/releases/latest" | grep download_url | grep linux-x64 | awk '{print $2}')\n" && exit 1; }


# Configuration variables.
sass_source_dir="./src/scss"
sass_source_file="./src/scss/style.scss"
css_target_file="./css/style.css"
css_style="compressed"              # Can be: expanded or compressed.
type_of_browser_reload="ctrl+F5"    # Can be: ctrl+F5 or ctrl+r
window_to_restore_to="style.scss"   # You have to figure this out fro your kind of setup
browsers="Brave"                    # Can add multiple. E.g.: browsers="Chrome Firefox Brave"

# Make an initial build.
sass --update --style="${css_style}" "${sass_source_file}" "${css_target_file}"

while inotifywait --recursive -e modify "${sass_source_dir}"; do
  #  Compile sass.
  sass --update --style "${css_style}" "${sass_source_file}" "${css_target_file}"

  #Reload the browser.
  for browser in ${browsers}; do
    xdotool search --onlyvisible --class "${browser}" windowfocus key "${type_of_browser_reload}"
  done

  #  Restore focus to the current window.
  xdotool windowactivate $(xdotool search --name "${window_to_restore_to}")
done
