-- [[ NONGKAO PREMIUM V2 - DELTA SPECIAL ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- [ 1. หน้าต่างเมนู - มีปุ่มพับขวาบน (Minimize) ]
local Window = OrionLib:MakeWindow({
    Name = "น้องเก้าซิกเซเว่น", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NongKaoV2",
    IntroText = "NYX CN"
})

-- [ 2. การเคลื่อนที่ ]
local MoveTab = Window:MakeTab({ Name = "เคลื่อนที่", Icon = "rbxassetid://4483345998" })

MoveTab:AddSlider({
    Name = "วิ่งเร็ว (Max x500)",
    Min = 16, Max = 500, Default = 16, Increment = 1, ValueName = "Speed",
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end    
})

MoveTab:AddSlider({
    Name = "กระโดดสูง (Max 500)",
    Min = 50, Max = 500, Default = 50, Increment = 1, ValueName = "Jump",
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end    
})

local InfJump = false
MoveTab:AddToggle({
    Name = "กระโดดรัวๆ (ไต่ฟ้า)",
    Default = false,
    Callback = function(v) InfJump = v end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
end)

local Noclip = false
MoveTab:AddToggle({
    Name = "เดินทะลุ + กัน NPC",
    Default = false,
    Callback = function(v) Noclip = v end
})

game:GetService("RunService").Stepped:Connect(function()
    if Noclip and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- [ 3. ต่อสู้ & มองทะลุ ]
local CombatTab = Window:MakeTab({ Name = "ต่อสู้/ESP", Icon = "rbxassetid://4483345998" })

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1.5
FOVring.Radius = 35 -- วงเล็กตามสั่ง
FOVring.Color = Color3.fromRGB(255, 0, 0)

CombatTab:AddToggle({
    Name = "เปิดวง FOV (วงเล็ก)",
    Default = false,
    Callback = function(v) FOVring.Visible = v end
})

local Aimbot = false
CombatTab:AddToggle({
    Name = "ล็อคเป้านิ่งสนิท",
    Default = false,
    Callback = function(v) Aimbot = v end
})

-- ปุ่มเปิด ESP (มองทะลุ)
CombatTab:AddButton({
    Name = "เปิดมองทะลุ (ESP)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
    end
})

-- [[ ระบบล็อคเป้าทำงานเบื้องหลัง ]]
game:GetService("RunService").RenderStepped:Connect(function()
    FOVring.Position = game:GetService("UserInputService"):GetMouseLocation()
    if Aimbot then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                local mouse = game:GetService("UserInputService"):GetMouseLocation()
                local mag = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                if mag < FOVring.Radius and mag < dist then
                    target = p
                    dist = mag
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Character.HumanoidRootPart.Position)
        end
    end
end)

OrionLib:Init()

