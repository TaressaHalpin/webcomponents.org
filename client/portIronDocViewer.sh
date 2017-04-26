#!/usr/bin/sh

# Set of files which are to be forked into the client/src directory.
files=(
  "iron-doc-behavior.html"
  "iron-doc-element.html"
  "iron-doc-function.html"
  "iron-doc-mixin.html"
  "iron-doc-namespace.html"
  "iron-doc-property-2.html"
  "iron-doc-summary-styles.html"
  "iron-doc-summary.html"
  "iron-doc-viewer-2-styles.html"
)

# This strips the files of some dependencies and makes some rote changes.
for i in "${files[@]}"
do
  cat 'bower_components/iron-doc-viewer/'$i \
  | sed '1s;^;<!--\nDo NOT modify this file.\nGenerated by portIronDocViewer.sh during install `npm install`.\n-->\n\n;' \
  | sed '/import.*paper-/d' \
  | sed 's/\.\.\/marked-element\/marked-element.html/mark-down.html/' \
  | sed 's/marked-element/mark-down/' \
  | sed 's/\.\.\(\/polymer\/polymer\.html\)/..\/bower_components\1/' \
  | sed '/import.*prism-/d' \
  | sed '/prism-highlighter/d' \
  | sed 's/\s*prism-theme-default\s*//' \
  > 'src/'$i
done

# Add additional styles to style sheets.
additonalStyles="$(<src/iron-doc-viewer-additional-styles.css)"
awk --assign=additonalStyles="$additonalStyles" '/<\/style>/{print additonalStyles;print;next}1' src/iron-doc-viewer-2-styles.html > .tmp_file
mv .tmp_file src/iron-doc-viewer-2-styles.html

additonalStyles="$(<src/iron-doc-summary-additional-styles.css)"
awk --assign=additonalStyles="$additonalStyles" '/<\/style>/{print additonalStyles;print;next}1' src/iron-doc-summary-styles.html > .tmp_file
mv .tmp_file src/iron-doc-summary-styles.html