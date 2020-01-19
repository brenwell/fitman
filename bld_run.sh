#!/bin/bash
# builds and runs the project app
WORKSPACE_PATH='./fitman.xcodeproj/project.xcworkspace'
CONFIGURATION='Debug'
SCHEME='fitman'

getBuildSetting() { 
    echo $(xcodebuild -showBuildSettings -workspace "$WORKSPACE_PATH" -scheme "$SCHEME" -configuration "$CONFIGURATION" | grep " $1" | awk '{print $3}' )
}

BUILT_PRODUCTS_DIR=$(getBuildSetting "BUILT_PRODUCTS_DIR")
FULL_PRODUCT_NAME=$(getBuildSetting "FULL_PRODUCT_NAME")
open -a "$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME" &