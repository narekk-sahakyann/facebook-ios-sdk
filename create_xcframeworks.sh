# Run to setup the project -> ./generate-projects.sh --force-with-wrong-xcodegen

OUTPUT_FOLDER_NAME="Output"
WORKSPACE_NAME="FacebookSDK.xcworkspace"
SCHEME_NAME="BuildAllKits-Static"
CONFIGURATION="Release"

SDK_BASE_KITS=(
    "FBSDKCoreKit_Basics"
    "FBSDKCoreKit"
    "FBAEMKit"
    "FBSDKLoginKit"
    "FBSDKShareKit"
)

SDK_BASE_ARCHS=(
    "iOS"
    "iOS Simulator"
    "macOS"
)

build_sdk() {
    DESTINATION=$1
    
    xcodebuild build \
    -workspace "${PWD}/${WORKSPACE_NAME}" \
    -scheme "${SCHEME_NAME}" \
    -configuration "${CONFIGURATION}" \
    -destination generic/platform="${DESTINATION}" \
    -derivedDataPath "${OUTPUT_FOLDER_NAME}/Builds"
}

create_framework() {
    SDK=$1
    
    xcodebuild -create-xcframework \
    -framework ./"${OUTPUT_FOLDER_NAME}/Builds/Build/Products/Release-iphoneos/${SDK}".framework \
    -framework ./"${OUTPUT_FOLDER_NAME}/Builds/Build/Products/Release-iphonesimulator/${SDK}".framework \
    -framework ./"${OUTPUT_FOLDER_NAME}/Builds/Build/Products/Release-maccatalyst/${SDK}".framework \
    -output ./"${OUTPUT_FOLDER_NAME}/Frameworks/${SDK}".xcframework
}

clean_directory() {
    DIRECTORY=$1
    
    rm -r "${DIRECTORY}"
}

## Main

# Clean
clean_directory "${PWD}/${OUTPUT_FOLDER_NAME}/"

# Build
for ARCH in "${SDK_BASE_ARCHS[@]}"; do
    build_sdk "${ARCH}"
done

# Create XCFrameworks
for SDK in "${SDK_BASE_KITS[@]}"; do
    create_framework "${SDK}"
done




