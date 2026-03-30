-- [[ NONGKAO PREMIUM HUB V2 - BY NYX CN ]]
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = Library:MakeWindow({
    Name = "น้องเก้าซิกเซเว่น", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "NongKaoConfig",
    IntroText = "NYX CN - LOADING..."
})

-- [[ TAB 1: Movement (การเคลื่อนที่) ]]
local MoveTab = Window:MakeTab({ Name = "การเคลื่อนที่", Icon = "rbxassetid://4483345998" })

-- วิ่งเร็ว (ปรับได้ถึง x500)
MoveTab:AddSlider({
    Name = "วิ่งเร็ว (Speed)",
    Min = 16, Max = 500, Default = 16, Color = Color3.fromRGB(255,0,0),
    Increment = 1, ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

-- กระโดดสูง (ปรับได้ถึง 100 เมตร)
MoveTab:AddSlider({
    Name = "กระโดดสูง (Jump)",
    Min = 50, Max = 500, Default = 50, Color = Color3.fromRGB(255,255,255),
    Increment = 1, ValueName = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

-- กระโดดรัวๆ ไม่จำกัด (Infinite Jump)
local InfiniteJumpEnabled = false
MoveTab:AddToggle({
    Name = "กระโดดรัวๆ ลอยฟ้า",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

-- เดินทะลุ + NPC ตีไม่ได้
local NoclipLoop
MoveTab:AddToggle({
    Name = "เดินทะลุ + NPC เมิน",
    Default = false,
    Callback = function(Value)
        _G.Noclip = Value
        if Value then
            NoclipLoop = game:GetService("RunService").Stepped:Connect(function()
                if _G.Noclip and game.Players.LocalPlayer.Character then
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            end)
        else
            if NoclipLoop then NoclipLoop:Disconnect() end
        end
    end
})

-- [[ TAB 2: Combat & Visuals (ต่อสู้และมองทะลุ) ]]
local CombatTab = Window:MakeTab({ Name = "ต่อสู้/มองทะลุ", Icon = "rbxassetid://4483345998" })

-- ล็อคเป้านิ่ง
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1.5
FOVring.Radius = 30 -- ปรับให้เล็กลงตามสั่ง
FOVring.Color = Color3.fromRGB(255, 0, 0)
FOVring.Filled = false

CombatTab:AddToggle({
    Name = "เปิดวงล็อคเป้า (เล็ก)",
    Default = false,
    Callback = function(Value)
        FOVring.Visible = Value
    end
})

CombatTab:AddToggle({
    Name = "ระบบล็อคเป้านิ่ง",
    Default = false,
    Callback = function(Value)
        _G.Aimbot = Value
    end
})

game:GetService("RunService").RenderStepped:Connect(function()
    FOVring.Position = game:GetService("UserInputService"):GetMouseLocation()
    if _G.Aimbot then
        local target = nil
        local dist = math.huge
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                local mag = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if mag < FOVring.Radius and mag < dist then
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

-- มองทะลุ (แบบเปิด-ปิดได้จริง)
local ESP_Created = false
CombatTab:AddToggle({
    Name = "มองทะลุ (ESP)",
    Default = false,
    Callback = function(Value)
        if Value then
            -- ใส่โค้ดสร้าง ESP ตรงนี้
            _G.ESP_Enabled = true
            loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
        else
            _G.ESP_Enabled = false
            -- สั่งลบ ESP (ถ้า Library รองรับ) หรือรีโหลดหน้าจอ
        end
    end
})

Library:Init()

