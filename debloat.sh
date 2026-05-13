#!/bin/bash
set -uo pipefail

# ─────────────────────────────────────────
#  Colors
# ─────────────────────────────────────────
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
NC="\e[0m"

# ─────────────────────────────────────────
#  Apps to remove (Samsung / carrier bloat)
# ─────────────────────────────────────────
DEBLOAT_LIST=(
    "HMT"
    "PaymentFramework"
    "DigitalWellbeing"
    "FactoryCameraFB"
    "WlanTest"
    "AirGlance"
    "AirReadingGlass"
    "AndroidGlassesCore"
    "SOAgent77"
    "ARCore"
    "ARDrawing"
    "ARZone"
    "BGMProvider"
    "SingleTakeService"
    "BixbyWakeup"
    "BlockchainBasicKit"
    "Cameralyzer"
    "DictDiotekForSec"
    "EasymodeContactsWidget81"
    "Fast"
    "FunModeSDK"
    "GearManagerStub"
    "KidsHome_Installer"
    "LinkSharing_v11"
    "LiveDrawing"
    "MAPSAgent"
    "MdecService"
    "MinusOnePage"
    "MoccaMobile"
    "Netflix_stub"
    "Notes40"
    "ParentalCare"
    "PhotoTable"
    "SmartReminder"
    "SmartSwitchStub"
    "UnifiedWFC"
    "UniversalMDMClient"
    "VideoEditorLite_Dream_N"
    "VisionIntelligence3.7"
    "VoiceAccess"
    "VTCameraSetting"
    "WebManual"
    "WifiGuider"
    "AutomationTest_FB"
    "FactoryTestProvider"
    "KTAuth"
    "KTCustomerService"
    "KTUsimManager"
    "TWorld"
    "SKT"
    "SamsungCalendar"
    "SamsungTTS"
    "SamsungBilling"
    "OneDrive_Samsung"
    "SamsungPass"
    "AREmoji"
    "Bixby"
    "Duo"
    "FBAppManager"
    "FBInstaller"
    "FBServices"
    "FotaAgent"
    # ⚠️  Removed "Photos" and "Maps" from original list —
    #     too generic, risks deleting unrelated folders.
    #     Add back explicitly if needed.
)

# ─────────────────────────────────────────
#  Removal counter
# ─────────────────────────────────────────
REMOVED=0
NOTFOUND=0

# ─────────────────────────────────────────
#  KICK: find and remove app folders
# ─────────────────────────────────────────
KICK() {
    local TARGET_DIR="$1"
    shift
    local APPS=("$@")

    local SEARCH_PATHS=(
        "$TARGET_DIR/system/app"
        "$TARGET_DIR/system/priv-app"
        "$TARGET_DIR/system/system/app"
        "$TARGET_DIR/system/system/priv-app"
        "$TARGET_DIR/product/app"
        "$TARGET_DIR/product/priv-app"
        "$TARGET_DIR/vendor/app"
        "$TARGET_DIR/vendor/priv-app"
        "$TARGET_DIR/oem/app"
    )

    for app in "${APPS[@]}"; do
        local found=0

        for path in "${SEARCH_PATHS[@]}"; do
            [ -d "$path" ] || continue

            # FIX: quote properly, avoid glob injection
            while IFS= read -r -d '' match; do
                echo -e "  ${RED}[-]${NC} Removing: $match"
                rm -rf "$match"
                found=1
                (( REMOVED++ )) || true
            done < <(find "$path" -maxdepth 1 -iname "*${app}*" -print0 2>/dev/null)
        done

        if [ "$found" -eq 0 ]; then
            echo -e "  ${CYAN}[?]${NC} Not found: $app"
            (( NOTFOUND++ )) || true
        fi
    done
}

# ─────────────────────────────────────────
#  MAIN
# ─────────────────────────────────────────
MAIN() {
    local DIR="$1"

    # ── Validate input ──
    if [ -z "$DIR" ]; then
        echo -e "${RED}Usage: $0 <extracted_rom_directory>${NC}"
        exit 1
    fi

    # FIX: strip accidental trailing slash
    DIR="${DIR%/}"

    if [ ! -d "$DIR" ]; then
        echo -e "${RED}Error: Directory not found → $DIR${NC}"
        exit 1
    fi

    echo -e "${YELLOW}════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Stock Optimizer — Tab A7 Debloat${NC}"
    echo -e "${YELLOW}  Target: $DIR${NC}"
    echo -e "${YELLOW}════════════════════════════════════════${NC}"
    echo ""

    KICK "$DIR" "${DEBLOAT_LIST[@]}"

    # ── Extra cleanup for stubborn folders ──
    echo ""
    echo -e "${YELLOW}[*] Extra cleanup...${NC}"

    for extra in \
        "$DIR/system/system/preload" \
        "$DIR/system/system/hidden" \
        "$DIR/system/preload" \
        "$DIR/system/hidden"
    do
        if [ -d "$extra" ]; then
            echo -e "  ${RED}[-]${NC} Removing: $extra"
            rm -rf "$extra"
        fi
    done

    # ── Summary ──
    echo ""
    echo -e "${YELLOW}════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Done!  Removed: $REMOVED folder(s)${NC}"
    echo -e "${CYAN}  Not found: $NOTFOUND app(s)${NC}"
    echo -e "${YELLOW}════════════════════════════════════════${NC}"
}

MAIN "$1"
