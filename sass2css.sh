#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

# Todo: Add js complilation.

command -v inotifywait >/dev/null 2>&1 || sudo apt install -y inotify-tools
command -v xdotool >/dev/null 2>&1 || sudo apt install -y xdotool
command -v sassc >/dev/null 2>&1 || { echo -e "\nsassc is required but it is not installed.\nInstall from https://github.com/sass/sassc/blob/master/docs/building/unix-instructions.md\n" && exit 1; }

# Variables.
sass_source_dir="./style/scss"
sass_source_file="./style/scss/main.scss"
css_target_file="./style/css/main.css"
css_style="compressed"              # Can be: nested or expanded or compact or compressed.
sourcemap_type="auto"               # Can be: auto or inline.
type_of_browser_reload="ctrl+F5"    # Can be: ctrl+F5 or ctrl+r
window_to_restore_to="drupal.*scss" # You have to figure this out fro your kind of setup
browsers="Firefox"                  # Can add multiple. E.g.: browsers="Chrome Firefox Brave"

# Make an initial build.
sassc --sourcemap="${sourcemap_type}" --style "${css_style}" "${sass_source_file}" "${css_target_file}"

while inotifywait --recursive -e modify "${sass_source_dir}"; do
  #  Compile sass.
  sassc --sourcemap="${sourcemap_type}" --style "${css_style}" "${sass_source_file}" "${css_target_file}"

  #Reload the browser.
  for browser in ${browsers}; do
    xdotool search --onlyvisible --class "${browser}" windowfocus key "${type_of_browser_reload}"
  done

  #  Restore focus to the current window.
  xdotool windowactivate $(xdotool search --name "${window_to_restore_to}")
done
