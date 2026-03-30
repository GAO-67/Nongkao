-- [[ NONGKAO V5.1 - DELTA 100% SUCCESS (น้องเก้าเองครับ) ]]
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Mercury/main/source.lua"))()

local Window = Mercury:Create{
    Name = "น้องเก้าเองครับ",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "NongkaoJ.lua"
}

-- [ ระบบพื้นฐาน ]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")

-- [[ แถบที่ 1: โหมดยิงปืน (FPS) ]]
local CombatTab = Window:Tab{ Name = "โหมดยิงปืน", Icon = "rbxassetid://6034287525" }

-- [ 1. กระสุนวิเศษ - Silent Aim 360 ]
local SilentAimEnabled = false
CombatTab:Toggle{
    Name = "กระสุนวิเศษ (Silent Aim 360 Head)",
    StartingState = false,
    Description = "ยิงตรงไหนก็เข้าหัวศัตรูตัวที่ใกล้ที่สุด 100%",
    Callback = function(state) SilentAimEnabled = state end
}

local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if SilentAimEnabled and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local target = nil
        local dist = math.huge
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local mag = (p.Character.Head.Position - LocalPlayer.Character.Head.Position).Magnitude
                if mag < dist then target = p dist = mag end
            end
        end
        if target then
            if method == "FindPartOnRayWithIgnoreList" then
                args[1] = Ray.new(Camera.CFrame.Position, (target.Character.Head.Position - Camera.CFrame.Position).Unit * 1000)
            end
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- [ 2. มองทะลุจุดแดง/ร่างแดง ]
local ESPEnabled = false
CombatTab:Toggle{
    Name = "มองทะลุ (Red Highlight)",
    StartingState = false,
    Description = "มองทะลุศัตรูทุกคนเป็นร่างสีแดง",
    Callback = function(state)
        ESPEnabled = state
        if not state then
            for _, v in pairs(game.Workspace:GetDescendants()) do
                if v.Name == "NK_ESP" then v:Destroy() end
            end
        end
    end
}

RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("NK_ESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "NK_ESP"
                    hl.Parent = p.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end
    end
end)

-- [[ แถบที่ 2: เคลื่อนที่ & ทั่วไป ]]
local MoveTab = Window:Tab{ Name = "เคลื่อนที่", Icon = "rbxassetid://6034287525" }

-- [ 3. วิ่งเร็วแยกปุ่ม (Force Speed) ]
local CurrentSpeed = 16
MoveTab:Button{ Name = "วิ่งเร็ว x50", Callback = function() CurrentSpeed = 50 end }
MoveTab:Button{ Name = "วิ่งเร็ว x100", Callback = function() CurrentSpeed = 100 end }
MoveTab:Button{ Name = "วิ่งเร็ว x150", Callback = function() CurrentSpeed = 150 end }
MoveTab:Button{ Name = "วิ่งเร็ว x200", Callback = function() CurrentSpeed = 200 end }
MoveTab:Button{ Name = "วิ่งเร็ว x250", Callback = function() CurrentSpeed = 250 end }
MoveTab:Button{ Name = "ความเร็วปกติ (Reset)", Callback = function() CurrentSpeed = 16 end }

RunService.Stepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
    end
end)

-- [ 4. Smart Wallhack (เดินทะลุกำแพง/ยิงออกได้) ]
local WallhackEnabled = false
MoveTab:Toggle{
    Name = "เดินทะลุ (Wallhack)",
    StartingState = false,
    Callback = function(state) WallhackEnabled = state end
}

RunService.Stepped:Connect(function()
    if WallhackEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.
                    
