-- [[ NONGKAO PREMIUM V3 - SILENT AIM EDITION (DELTA 100%) ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game.CoreGui
MainFrame.Name = "NongKaoV3"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -125)
MainFrame.Size = UDim2.new(0, 180, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Text = " น้องเก้าซิกเซเว่น V3"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Title.TextXAlignment = Enum.TextXAlignment.Left

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local Maximized = true
MinimizeBtn.MouseButton1Click:Connect(function()
    Maximized = not Maximized
    Content.Visible = Maximized
    MainFrame.Size = Maximized and UDim2.new(0, 180, 0, 280) or UDim2.new(0, 180, 0, 30)
end)

Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.CanvasSize = UDim2.new(0, 0, 4, 0)
Content.ScrollBarThickness = 3

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 5)

-- [ ฟังก์ชันสร้างปุ่ม ]
local function MakeButton(name, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = color
    btn.MouseButton1Click:Connect(callback)
end

-- [[ 1. วิ่งเร็วแยกปุ่ม (Speed Presets) ]]
MakeButton("วิ่งเร็ว x10", Color3.fromRGB(230,230,230), function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100 end)
MakeButton("วิ่งเร็ว x30", Color3.fromRGB(230,230,230), function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 300 end)
MakeButton("วิ่งเร็ว x50", Color3.fromRGB(230,230,230), function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 500 end)
MakeButton("วิ่งเร็ว x100", Color3.fromRGB(230,230,230), function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 1000 end)
MakeButton("วิ่งเร็ว x200", Color3.fromRGB(230,230,230), function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 2000 end)

-- [[ 2. กระสุนวิเศษ (Silent Aim 100%) ]]
local SilentAim = false
MakeButton("กระสุนวิเศษ (เปิด/ปิด)", Color3.fromRGB(255,200,200), function()
    SilentAim = not SilentAim
    game.StarterGui:SetCore("SendNotification", {Title = "ระบบ", Text = "กระสุนวิเศษ: "..tostring(SilentAim)})
end)

local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if SilentAim and method == "FindPartOnRayWithIgnoreList" then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mag < 200 and mag < dist then
                        target = p
                        dist = mag
                    end
                end
            end
        end
        if target then
            args[1] = Ray.new(workspace.CurrentCamera.CFrame.Position, (target.Character.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- [[ 3. มองทะลุจุดแดง (Red Dot ESP) ]]
local ESPLoop = nil
MakeButton("มองทะลุสัตว์/คน (จุดแดง)", Color3.fromRGB(200,255,200), function()
    if ESPLoop then ESPLoop:Disconnect() ESPLoop = nil return end
    ESPLoop = game:GetService("RunService").RenderStepped:Connect(function()
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= game.Players.LocalPlayer.Character then
                if not v:FindFirstChild("RedDot") then
                    local dot = Instance.new("Highlight")
                    dot.Name = "RedDot"
                    dot.Parent = v
                    dot.FillColor = Color3.fromRGB(255, 0, 0)
                    dot.OutlineTransparency = 1
                    dot.FillTransparency = 0.5
                    dot.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end
    end)
end)

-- [[ 4. กระโดดรัวๆ (ไต่ฟ้า) ]]
local InfJump = false
MakeButton("กระโดดรัวๆ (ไต่ฟ้า)", Color3.fromRGB(200,200,255), function() InfJump = not InfJump end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
end)

-- [[ 5. เดินทะลุ ]]
local Noclip = false
MakeButton("เดินทะลุ (เปิด/ปิด)", Color3.fromRGB(230,230,230), function() Noclip = not Noclip end)
game:GetService("RunService").Stepped:Connect(function()
    if Noclip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

