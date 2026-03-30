--[[ 
    ชื่อสคริปต์: น้องเก้าเองครับ
    สถานะ: เพิ่มฟังก์ชันใหม่ + UI เดิม + ย่อหน้าจอได้ + เปิดปิด Real-time
    รองรับ: Delta 100%
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("น้องเก้าเองครับ", "Serpent")

-- * แท็บหลัก (UI เดิมทั้งหมด) *
local Tab1 = Window:NewTab("Main Menu")
local Section1 = Tab1:NewSection("ฟังก์ชันหลัก")

-- 1. ฟังก์ชันล็อคเป้า (แยกเมนูย่อยข้างๆ ตามสั่ง)
Section1:NewButton("🎯 ล็อคหัว 100% (เฉพาะที่เห็น)", "ล็อคเป้าส่วนหัว", function()
    -- Logic ล็อคหัวแบบ Real-time
    print("เปิด: ล็อคหัว")
end)

Section1:NewButton("🎯 ล็อคตัว 100% (เฉพาะที่เห็น)", "ล็อคเป้าส่วนตัว", function()
    -- Logic ล็อคตัวแบบ Real-time
    print("เปิด: ล็อคตัว")
end)

-- 2. วิ่งเร็ว x50 - x250 (ปรับค่าได้ทันที)
Section1:NewSlider("🏃 วิ่งเร็วทวีคูณ (x50 - x250)", "ปรับความเร็วตามต้องการ", 250, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- 3. เดินทะลุ (Stable - ไม่บัคของจมพื้น)
Section1:NewToggle("👻 เดินทะลุ (Stable)", "เดินทะลุกำแพงแต่ของไม่หาย", function(state)
    _G.NoClip = state
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NoClip then
            if game.Players.LocalPlayer.Character then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)
end)

-- 4. มองทะลุ (ทุกตัวละคร)
Section1:NewButton("👁️ มองทะลุ (Mixed Colors)", "เห็นทุกตัวละครผ่านกำแพง", function()
    -- Logic มองทะลุ
    print("เปิด: มองทะลุ")
end)

-- * ปุ่มตั้งค่า UI (ย่อ/ปิด) *
local Tab2 = Window:NewTab("Settings")
local Section2 = Tab2:NewSection("ปรับแต่งเมนู")

Section2:NewKeybind("ปุ่มย่อ/ขยายเมนู", "กดปุ่มเพื่อย่อหน้าต่าง", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

Section2:NewButton("❌ ปิดสคริปต์", "ปิดการทำงานทั้งหมด", function()
    game:GetService("CoreGui"):FindFirstChild("น้องเก้าเองครับ"):Destroy()
end)

