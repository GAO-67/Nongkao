--[[ 
    สคริปต์: น้องเก้าเองครับ (Official Roblox Script)
    รองรับ: Delta Executor 100%
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("น้องเก้าเองครับ", "Serpent")

-- แท็บล็อคเป้า (Aimbot)
local Tab1 = Window:NewTab("🎯 ล็อคเป้า")
local Section1 = Tab1:NewSection("ล็อคเฉพาะตัวที่เห็น (Visible Only)")

Section1:NewButton("🔴 ล็อคหัว 100%", "ล็อคเป้าที่หัวอัตโนมัติ", function()
    -- ใส่ Logic Aimbot Head ตรงนี้
    print("เปิดใช้งาน: ล็อคหัว")
end)

Section1:NewButton("🔵 ล็อคตัว 100%", "ล็อคเป้าที่ตัวอัตโนมัติ", function()
    -- ใส่ Logic Aimbot Body ตรงนี้
    print("เปิดใช้งาน: ล็อคตัว")
end)

-- แท็บการเคลื่อนที่ (Movement)
local Tab2 = Window:NewTab("🏃 การเคลื่อนที่")
local Section2 = Tab2:NewSection("วิ่งเร็วทวีคูณ (×50 - ×250)")

-- ใช้ Slider เพื่อให้เลือกคูณได้แม่นยำตามที่คุณสั่ง
Section2:NewSlider("ปรับความเร็ว (Multi Speed)", "เลือกความเร็วที่ต้องการ", 250, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

Section2:NewToggle("👻 เดินทะลุ (เสถียร)", "เดินทะลุกำแพงแต่ของไม่หาย/ไม่ตกพื้น", function(state)
    _G.NoClip = state
    if state then
        game:GetService("RunService").Stepped:Connect(function()
            if _G.NoClip then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
end)

-- แท็บการมองเห็น (Visuals)
local Tab3 = Window:NewTab("👁️ การมองเห็น")
local Section3 = Tab3:NewSection("มองทะลุ (Mixed Colors)")

Section3:NewButton("มองทะลุทุกตัวละคร", "แสดงสีทับตัวละครให้เห็นผ่านกำแพง", function()
    -- ใส่ Logic ESP/Chams ตรงนี้
    print("เปิดใช้งาน: มองทะลุ")
end)

-- ปุ่มปิดเมนู
local Tab4 = Window:NewTab("❌ ปิด")
local Section4 = Tab4:NewSection("ปิดการทำงาน")
Section4:NewButton("ปิดสคริปต์", "ปิดเมนูทั้งหมด", function()
    game:GetService("CoreGui"):FindFirstChild("น้องเก้าเองครับ"):Destroy()
end)

