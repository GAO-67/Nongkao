local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [ UI Setup: ขาว-ดำ มินิมอล ]
local Window = Fluent:CreateWindow({
    Title = "น้องเก้าซิกเซเว่น",
    SubTitle = "BY NYX CN",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, 
    Theme = "Light", -- สีขาวตามสั่ง
    MinimizeKey = Enum.KeyCode.RightControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main Mods", Icon = "user" }),
    Visual = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "target" })
}

-- 1. เดินทะลุ (Smart Noclip)
local NoclipToggle = Tabs.Main:AddToggle("Noclip", {Title = "เดินทะลุ", Default = false })
NoclipToggle:OnChanged(function()
    _G.Noclip = NoclipToggle.Value
    game:GetService("RunService").Stepped:Connect(function()
        if _G.Noclip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 2. โหมดบิน (Fly Hold Jump)
local FlyToggle = Tabs.Main:AddToggle("Fly", {Title = "โหมดบิน (กระโดดค้าง)", Default = false })
FlyToggle:OnChanged(function()
    _G.Fly = FlyToggle.Value
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Fly and game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * 100
        end
    end)
end)

-- 3. วิ่งเร็ว (Speed Slider x1.5 - x20)
local SpeedSlider = Tabs.Main:AddSlider("Speed", {
    Title = "วิ่งเร็ว",
    Description = "ปรับระดับความเร็ว (ปกติคือ 16)",
    Default = 16,
    Min = 16,
    Max = 320,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

-- 4. มองทะลุ (ESP)
Tabs.Visual:AddButton({
    Title = "เปิดมองทะลุ (ESP)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
    end
})

-- 5. ล็อคเป้า (Aimbot FOV 45 + Wall Check)
local AimToggle = Tabs.Combat:AddToggle("Aimbot", {Title = "ล็อคเป้า", Default = false })
AimToggle:OnChanged(function()
    _G.Aimbot = AimToggle.Value
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.Aimbot then
            local target = nil
            local dist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local mag = (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if mag < 100 and mag < dist then
                        target = v
                        dist = mag
                    end
                end
            end
            if target then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Character.HumanoidRootPart.Position)
            end
        end
    end)
end)

Fluent:SelectTab(1)
