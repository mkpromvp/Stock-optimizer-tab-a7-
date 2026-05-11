#!/bin/bash

# Colors
RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

# Apps Categories
DEBLOAT_LIST=(
"HMT" "PaymentFramework" "DigitalWellbeing" "FactoryCameraFB"
"WlanTest" "AirGlance" "AirReadingGlass" "AndroidGlassesCore"
"SOAgent77" "ARCore" "ARDrawing" "ARZone" "BGMProvider"
"SingleTakeService" "BixbyWakeup" "BlockchainBasicKit"
"Cameralyzer" "DictDiotekForSec" "EasymodeContactsWidget81"
"Fast" "FunModeSDK" "GearManagerStub" "KidsHome_Installer"
"LinkSharing_v11" "LiveDrawing" "MAPSAgent" "MdecService"
"MinusOnePage" "MoccaMobile" "Netflix_stub" "Notes40"
"ParentalCare" "PhotoTable" "SmartReminder" "SmartSwitchStub"
"UnifiedWFC" "UniversalMDMClient" "VideoEditorLite_Dream_N"
"VisionIntelligence3.7" "VoiceAccess" "VTCameraSetting"
"WebManual" "WifiGuider" "AutomationTest_FB" "FactoryTestProvider"
"KTAuth" "KTCustomerService" "KTUsimManager" "TWorld" "SKT"
"SamsungCalendar" "SamsungTTS" "SamsungBilling" "OneDrive_Samsung"
"SamsungPass" "AREmoji" "Bixby" "Duo" "Photos" "Maps"
"FBAppManager" "FBInstaller" "FBServices" "FotaAgent"
)

KICK() {
    local TARGET_DIR="$1"
    shift
    local APPS=("$@")

    # Search in all possible paths within the extracted system
    local SEARCH_PATHS=(
        "$TARGET_DIR/system/app"
        "$TARGET_DIR/system/priv-app"
        "$TARGET_DIR/system/system/app"
        "$TARGET_DIR/system/system/priv-app"
        "$TARGET_DIR/product/app"
        "$TARGET_DIR/product/priv-app"
    )

    for app in "${APPS[@]}"; do
        for path in "${SEARCH_PATHS[@]}"; do
            if [ -d "$path" ]; then
                # Use find to catch folders containing the app name
                find "$path" -maxdepth 1 -iname "*${app}*" -exec rm -rf {} + 2>/dev/null
            fi
        done
    done
}

MAIN() {
    local DIR="$1"
    if [ -z "$DIR" ] || [ ! -d "$DIR" ]; then
        echo -e "${RED}Error: Target directory not found!${NC}"
        exit 1
    fi

    echo -e "${YELLOW}Starting deep debloat...${NC}"
    KICK "$DIR" "${DEBLOAT_LIST[@]}"
    
    # Extra cleanup for stubborn folders
    rm -rf "$DIR/system/system/preload" 2>/dev/null
    rm -rf "$DIR/system/system/hidden" 2>/dev/null
    
    echo -e "${YELLOW}Debloat finished.${NC}"
}

MAIN "$1"
