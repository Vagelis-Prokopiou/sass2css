# sass2css
After having struggled for many years with the Node.js (node_modules) hell, if decided to create this alternative for my frontend theming workflow.
Currently, it includes sass to css compilation (with [Dart Sass](https://github.com/sass/dart-sass)) and browser syncing on file change (replacing [Browsersync](https://www.browsersync.io)).

## Usage
* Install the [Dart Sass](https://github.com/sass/dart-sass) standalone executable.
* Download the script in your theme folder.
* Make it executable: `chmod +x ./sass2css.sh`
* Update the configuration variables according to your setup.
* Run it with: `./sass2css.sh`
