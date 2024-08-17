#!/bin/bash

# Examples
# ./xcrun+.sh list
# ./xcrun+.sh uninstall "cloud.vitrin.ios"
# ./xcrun+.sh uninstall "com.facebook.WebDriverAgentRunner.xctrunner"

FIRST_ARG=$1
SECOND_ARG=$2

xcrun simctl list | grep Booted | while read line
do
  if [ ! "$line" = "" ]
  then
    uuid=$(echo "$line" | grep -o "[a-fA-F0-9]\{8\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{4\}-[a-fA-F0-9]\{12\}")
    if [ "$FIRST_ARG" = "uninstall" ]
    then
      if [ ! "$SECOND_ARG" = "" ]
      then
        xcrun simctl "$FIRST_ARG" "$uuid" "$SECOND_ARG"
        echo App with BundleID: "$SECOND_ARG" has been uninstalled from device: "$uuid"
      else
        echo BundleID is null! [ex: xcrun+.sh uninstall "bundle_id"]
        break
      fi
    elif [ "$FIRST_ARG" = "version" ]
    then
      if [ ! "$SECOND_ARG" = "" ]
      then
        version_string=$(plutil -p "$SECOND_ARG"/Info.plist | grep -A 0 CFBundleShortVersionString | awk -F ' => ' '{print $2}' | tr -d '"')
        echo "$version_string"
        break
      else
        echo Path is null! [ex: xcrun+.sh version "path"]
        break
      fi
    else
      echo Command is not valid! available commands: ["uninstall":"To uninstall app", "version":"To get app version from .app file"]
      break
    fi
  fi
done
