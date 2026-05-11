#!/bin/bash

RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

# القوائم بتاعتك زي ما هي بالظبط
DEBLOAT_APPS=("HMT" "PaymentFramework" "DigitalWellbeing" "FactoryCameraFB" "WlanTest" "AirGlance" "AirReadingGlass" "AndroidGlassesCore" "SOAgent77" "ARCore" "ARDrawing" "ARZone" "BGMProvider" "SingleTakeService" "BixbyWakeup" "BlockchainBasicKit" "Cameralyzer" "DictDiotekForSec" "EasymodeContactsWidget81" "Fast" "FunModeSDK" "GearManagerStub" "KidsHome_Installer" "LinkSharing_v11" "LiveDrawing" "MAPSAgent" "MdecService" "MinusOnePage" "MoccaMobile" "Netflix_stub" "Notes40" "ParentalCare" "PhotoTable" "SmartReminder" "SmartSwitchStub" "UnifiedWFC" "UniversalMDMClient" "VideoEditorLite_Dream_N" "VisionIntelligence3.7" "VoiceAccess" "VTCameraSetting" "WebManual" "WifiGuider" "AutomationTest_FB" "FactoryTestProvider")
CARRIER_APPS=("KTAuth" "KTCustomerService" "KTUsimManager" "LGUMiniCustomerCenter" "LGUplusTsmProxy" "SKTMemberShip_new" "SktUsimService")
# ... (باقي القوائم SAMSUNG_APPS وغيرها تظل كما هي في ملفك)

# تعديل دالة الحذف لتكون ذكية وتجد المسارات المتداخلة
KICK() {
    local ROOT_DIR="$1"
    shift
    local APPS=("$@")
    
    # قائمة المسارات اللي سامسونج بتخبي فيها التطبيقات
    local PATHS=(
        "$ROOT_DIR/app" "$ROOT_DIR/priv-app"
        "$ROOT_DIR/system/app" "$ROOT_DIR/system/priv-app"
        "$ROOT_DIR/system/system/app" "$ROOT_DIR/system/system/priv-app"
    )

    for APP in "${APPS[@]}"; do
        for P in "${PATHS[@]}"; do
            if [ -d "$P" ]; then
                # حذف أي مجلد يبدأ باسم التطبيق
                rm -rf "$P/$APP"* 2>/dev/null
            fi
        done
    done
}

# التنفيذ
EXTRACTED_FIRM_DIR="$1"
if [ -z "$EXTRACTED_FIRM_DIR" ]; then exit 1; fi

echo -e "${YELLOW}Cleaning up apps...${NC}"
BEFORE=$(find "$EXTRACTED_FIRM_DIR" -name "*.apk" | wc -l)

KICK "$EXTRACTED_FIRM_DIR" "${DEBLOAT_APPS[@]}"
KICK "$EXTRACTED_FIRM_DIR" "${CARRIER_APPS[@]}"
# أضف هنا باقي الـ KICK لكل القوائم اللي عندك

# التنظيف الإضافي اللي كان في ملفك
rm -rf "$EXTRACTED_FIRM_DIR/system/system/hidden"
rm -rf "$EXTRACTED_FIRM_DIR/system/system/preload"

AFTER=$(find "$EXTRACTED_FIRM_DIR" -name "*.apk" | wc -l)
echo -e "Removed $((BEFORE - AFTER)) apps."
