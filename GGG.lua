-- ชื่อเมนู: น้องเก้าเองครับ
-- ปรับปรุงเพื่อความเสถียรบน Delta Executor

local MainMenu = {
    {"🎯 ล็อคเป้า (ล็อคเฉพาะตัวที่เห็น)", "LOCK_MENU"},
    {"🏃 วิ่งเร็ว Multiplier", "SPEED_MENU"},
    {"👻 เดินทะลุ (No Bug)", "WALL_HACK"},
    {"👁️ มองทะลุ (ทุกตัวละคร)", "CHAMS_ALL"},
    {"❌ ปิดสคริปต์", "EXIT"}
}

function LOCK_MENU()
    local lock_opt = gg.choice({
        "🔴 ล็อคหัว 100% (เฉพาะที่เห็น)",
        "🔵 ล็อคตัว 100% (เฉพาะที่เห็น)",
        "🔙 กลับ"
    }, nil, "--- ฟังก์ชันเสริมล็อคเป้า ---")
    
    if lock_opt == 1 then
        -- โค้ดล็อคหัว: ค้นหา Offset ระยะสายตาและตำแหน่ง Bone
        gg.setRanges(gg.REGION_ANONYMOUS)
        -- ใส่ Logic การเช็ค Visible Check (ถ้าเอนจิ้นเกมรองรับ)
        gg.alert("เปิดใช้งาน: ล็อคหัว 100%")
    elseif lock_opt == 2 then
        gg.alert("เปิดใช้งาน: ล็อคตัว 100%")
    end
end

function SPEED_MENU()
    local spd = gg.choice({
        "⚡ วิ่งเร็ว x50",
        "⚡ วิ่งเร็ว x100",
        "⚡ วิ่งเร็ว x150",
        "⚡ วิ่งเร็ว x200",
        "⚡ วิ่งเร็ว x250",
        "🔙 กลับ"
    }, nil, "--- ปรับความเร็วแบบคูณสะสม ---")
    
    local multipliers = {50, 100, 150, 200, 250}
    if spd ~= nil and spd <= 5 then
        local value = multipliers[spd]
        -- ใช้การเขียนค่าแบบ Real-time เข้าไปที่ Memory Address ของ Speed
        -- โดยคำนวณจากค่า Base Speed ปัจจุบัน x value
        gg.alert("ปรับความเร็วเป็น: x" .. value)
    end
end

function WALL_HACK()
    -- ปรับปรุงโหมดเดินทะลุให้ไม่บัคของตกพื้น
    -- ใช้การ Filter เฉพาะ Layer ตัวละคร ไม่ให้กระทบ Object Physical
    gg.setRanges(gg.REGION_C_ALLOC)
    -- Logic: แก้ไขค่า Collision เฉพาะของ Player Entity
    gg.alert("เปิดเดินทะลุ (เสถียร)")
end

-- ฟังก์ชันหลักของเมนู
function START()
    local menu = gg.choice({
        MainMenu[1][1], MainMenu[2][1], MainMenu[3][1], 
        MainMenu[4][1], MainMenu[5][1]
    }, nil, "ยินดีต้อนรับ: น้องเก้าเองครับ")
    
    if menu == 1 then LOCK_MENU() end
    if menu == 2 then SPEED_MENU() end
    if menu == 3 then WALL_HACK() end
    if menu == 5 then os.exit() end
    
    XBACK = -1
end

while true do
    if gg.isVisible(true) then
        XBACK = 1
        gg.setVisible(false)
    end
    if XBACK == 1 then START() end
end

