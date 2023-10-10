# Run to setup the project -> ./generate-projects.sh --force-with-wrong-xcodegen

OUTPUT_FOLDER_NAME="Output"
WORKSPACE_NAME="FacebookSDK.xcworkspace"
SCHEME_NAME="BuildAllKits-Static"
CONFIGURATION="Release"
PROJECT_CONFIGURATION="Configurations/FacebookSDK-Library.xcconfig"

SDK_BASE_KITS=(
    "FBSDKCoreKit_Basics"
    "FBSDKCoreKit"
    "FBAEMKit"
    "FBSDKLoginKit"
    "FBSDKShareKit"
)

SDK_BASE_PLATFORMS=(
    "iOS"
    "iOS Simulator"
    #"macOS"
)

build_sdk() {
    # Prepare the -destination flags
    DESTINATION_FLAGS=()
    for i in "${SDK_BASE_PLATFORMS[@]}"; do
        DESTINATION_FLAGS+=(-destination generic/platform="${i}")
    done
    
    # build the project with the selected flags
    xcodebuild build \
    -workspace ."/${WORKSPACE_NAME}" \
    -scheme "${SCHEME_NAME}" \
    -configuration "${CONFIGURATION}" \
    -xcconfig "${PROJECT_CONFIGURATION}" \
    -derivedDataPath "${OUTPUT_FOLDER_NAME}/Builds" \
    "${DESTINATION_FLAGS[@]}"
}

create_framework() {
    SDK=$1
    
    # Find All the frameworks paths for the selected fb sdk
    IFS=$'\n'
    FRAMEWORK_PATHS=($(find ./"${OUTPUT_FOLDER_NAME}/Builds/Build/Products" -name "${SDK}.framework" -maxdepth 2))
    unset IFS

    # Prepare the -framework flags
    FRAMEWORK_PATH_FLAGS=()
    for i in "${FRAMEWORK_PATHS[@]}"; do
        FRAMEWORK_PATH_FLAGS+=(-framework "${i}")
    done

    # generate the xcframework with the selected frameworks
    xcodebuild -create-xcframework \
    -output ./"${OUTPUT_FOLDER_NAME}/Frameworks/${SDK}".xcframework \
    "${FRAMEWORK_PATH_FLAGS[@]}"
}

## Main

# Clean
rm -r ."/${OUTPUT_FOLDER_NAME}/"

# Build
build_sdk

# Create XCFrameworks
for SDK in "${SDK_BASE_KITS[@]}"; do
    create_framework "${SDK}"
done

# Zip
mkdir ./"${OUTPUT_FOLDER_NAME}/Zips/";
find ./"${OUTPUT_FOLDER_NAME}/Frameworks/" -name "*.xcframework" -maxdepth 1 -execdir zip '../Zips/{}.zip' '{}' \;




