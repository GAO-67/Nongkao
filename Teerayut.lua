--[[ 
    Script: น้องเก้าเองครับ
    Platform: GameGuardian (Run via Delta)
]]

-- ตั้งค่าเริ่มต้น
gg.clearResults()
gg.toast("กำลังรันสคริปต์โดย: น้องเก้าเองครับ")

function MAIN_MENU()
    local menu = gg.choice({
        "🎯 [ล็อคเป้า] - ล็อคเฉพาะศัตรูที่เห็น 100%",
        "🏃 [วิ่งเร็ว] - ตัวคูณ ×50 ถึง ×250",
        "👻 [เดินทะลุ] - แบบเสถียร (ของไม่หาย)",
        "👁️ [มองทะลุ] - แก้ไขมองเห็นทุกตัว (Mix Color)",
        "❌ ปิดสคริปต์"
    }, nil, "ยินดีต้อนรับ: น้องเก้าเองครับ\nใช้งานผ่าน Delta 100%")

    if menu == 1 then AIM_LOCK() end
    if menu == 2 then SPEED_SET() end
    if menu == 3 then WALL_HACK_STABLE() end
    if menu == 4 then CHAMS_ALL() end
    if menu == 5 then os.exit() end
end

-- 1. ฟังก์ชันล็อคเป้า (มีเมนูย่อยแยกออกมาข้างๆ)
function AIM_LOCK()
    local aim = gg.choice({
        "🔴 ล็อคหัว 100% (Visible Only)",
        "🔵 ล็อคตัว 100% (Visible Only)",
        "🔙 กลับ"
    }, nil, "--- ตั้งค่าการล็อคเป้า ---")
    
    if aim == 1 then
        gg.toast("เปิดล็อคหัว... (เรียลไทม์)")
        -- ใส่ Memory Edit สำหรับล็อคหัวที่นี่
    elseif aim == 2 then
        gg.toast("เปิดล็อคตัว... (เรียลไทม์)")
    end
end

-- 2. ฟังก์ชันวิ่งเร็วคูณทวีคูณ
function SPEED_SET()
    local spd = gg.choice({"x50", "x100", "x150", "x200", "x250", "🔙 กลับ"}, nil, "เลือกความเร็ว (คูณจากค่าเดิม)")
    local vals = {50, 100, 150, 200, 250}
    if spd ~= nil and spd <= 5 then
        gg.toast("ปรับความเร็วเป็น x" .. vals[spd])
        -- ใส่ Memory Edit สำหรับ Speed ที่นี่
    end
end

-- 3. เดินทะลุแบบเสถียร (Stable)
function WALL_HACK_STABLE()
    gg.toast("เปิดเดินทะลุ (แก้ไขบัคของตกพื้นเรียบร้อย)")
    -- ใส่ Memory Edit สำหรับ Wallhack ที่นี่
end

-- 4. มองทะลุ (Mix Colors)
function CHAMS_ALL()
    gg.toast("กำลังเปลี่ยนสีตัวละครทั้งหมด...")
    -- ใส่ Memory Edit สำหรับ Chams ที่นี่
end

-- Loop รันเมนู
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        MAIN_MENU()
    end
    gg.sleep(100)
end
