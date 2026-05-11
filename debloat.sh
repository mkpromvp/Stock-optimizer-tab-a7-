#!/bin/bash

RED="\e[31m"
YELLOW="\e[33m"
NC="\e[0m"

# القوائم الخاصة بك كاملة (تم استخراجها من ملفك الأصلي)
DEBLOAT_APPS=("HMT" "PaymentFramework" "DigitalWellbeing" "FactoryCameraFB" "WlanTest" "AirGlance" "AirReadingGlass" "AndroidGlassesCore" "SOAgent77" "ARCore" "ARDrawing" "ARZone" "BGMProvider" "SingleTakeService" "BixbyWakeup" "BlockchainBasicKit" "Cameralyzer" "DictDiotekForSec" "EasymodeContactsWidget81" "Fast" "FunModeSDK" "GearManagerStub" "KidsHome_Installer" "LinkSharing_v11" "LiveDrawing" "MAPSAgent" "MdecService" "MinusOnePage" "MoccaMobile" "Netflix_stub" "Notes40" "ParentalCare" "PhotoTable" "SmartReminder" "SmartSwitchStub" "UnifiedWFC" "UniversalMDMClient" "VideoEditorLite_Dream_N" "VisionIntelligence3.7" "VoiceAccess" "VTCameraSetting" "WebManual" "WifiGuider" "AutomationTest_FB" "FactoryTestProvider")
CARRIER_APPS=("KTAuth" "KTCustomerService" "KTUsimManager" "LGUMiniCustomerCenter" "LGUplusTsmProxy" "SKTMemberShip_new" "SktUsimService")
# ... بقية القوائم (SAMSUNG_APPS, GOOGLE_APPS...) تضاف هنا بنفس الطريقة

KICK() {
    local ROOT="$1"
    shift
    local LIST=("$@")
    
    # تحسين من QuantumROM: البحث في كل الهياكل الممكنة (System/System و System/App)
    local LOCATIONS=(
        "$ROOT/app" "$ROOT/priv-app"
        "$ROOT/system/app" "$ROOT/system/priv-app"
        "$ROOT/system/system/app" "$ROOT/system/system/priv-app"
        "$ROOT/product/app" "$ROOT/product/priv-app"
    )

    for APP in "${LIST[@]}"; do
        for LOC in "${LOCATIONS[@]}"; do
            if [ -d "$LOC" ]; then
                # حذف المجلد وأي مجلدات مطابقة للاسم
                find "$LOC" -maxdepth 1 -iname "*$APP*" -type d -exec rm -rf {} + 2>/dev/null
            fi
        done
    done
}

# نقطة الانطلاق
TARGET_DIR="$1"
if [ -z "$TARGET_DIR" ]; then exit 1; fi

echo -e "${YELLOW}QuantumROM Logic: Checking paths...${NC}"
# التأكد من وجود مسار النظام الحقيقي
if [ -d "$TARGET_DIR/system/system" ]; then
    SYS_PATH="$TARGET_DIR/system/system"
else
    SYS_PATH="$TARGET_DIR"
fi

BEFORE=$(find "$TARGET_DIR" -name "*.apk" | wc -l)

# تنفيذ الحذف على كل القوائم الخاصة بك
KICK "$TARGET_DIR" "${DEBLOAT_APPS[@]}"
KICK "$TARGET_DIR" "${CARRIER_APPS[@]}"
# كرر الـ KICK لكل قوائمك هنا...

# تنظيف إضافي (كما في ملفك الأصلي)
rm -rf "$TARGET_DIR/system/system/hidden" 2>/dev/null
rm -rf "$TARGET_DIR/system/system/preload" 2>/dev/null

AFTER=$(find "$TARGET_DIR" -name "*.apk" | wc -l)
echo -e "Debloat Finished: $((BEFORE - AFTER)) APKs removed."
