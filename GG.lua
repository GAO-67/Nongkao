-- [[ NONGKAO V10 - LOCK TARGET & MULTIPLY SPEED (น้องเก้าเองครับ) ]]
-- DELTA 100% | VISIBLE LOCK | NO BUG WALLHACK

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local MinimizeBtn = Instance.new("TextButton")

-- [ UI Setup ]
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "NongKao_V10"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Position = UDim2.new(0.5, -95, 0.5, -150)
MainFrame.Size = UDim2.new(0, 190, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, -35, 0, 35)
Title.Text = " น้องเก้าเองครับ "
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
Title.Font = Enum.Font.GothamBold

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Maximized = true
MinimizeBtn.MouseButton1Click:Connect(function()
    Maximized = not Maximized
    Content.Visible = Maximized
    MainFrame.Size = Maximized and UDim2.new(0, 190, 0, 350) or UDim2.new(0, 190, 0, 35)
end)

Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, -35)
Content.Position = UDim2.new(0, 0, 0, 35)
Content.CanvasSize = UDim2.new(0, 0, 15, 0)
Content.ScrollBarThickness = 2
Content.BackgroundTransparency = 1

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 6)

-- [ Function Helper ]
local function CreateToggle(name, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        callback(state)
    end)
    return btn
end

-- [[ 1. ระบบล็อคเป้า (Visible Check 100%) ]]
local AimbotActive = false
local AimTargetPart = "Head"
local LockFrame = Instance.new("Frame")
LockFrame.Parent = Content
LockFrame.Size = UDim2.new(1, -10, 0, 0)
LockFrame.Visible = false
LockFrame.BackgroundTransparency = 1
local LList = Instance.new("UIListLayout")
LList.Parent = LockFrame
LList.Padding = UDim.new(0, 4)

local function CreateLockBtn(name, part)
    local lb = Instance.new("TextButton")
    lb.Parent = LockFrame
    lb.Size = UDim2.new(1, 0, 0, 30)
    lb.Text = name
    lb.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    lb.TextColor3 = Color3.fromRGB(255, 255, 255)
    lb.MouseButton1Click:Connect(function()
        AimTargetPart = part
        for _, v in pairs(LockFrame:GetChildren()) do
            if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(180, 0, 0) end
        end
        lb.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end)
    if part == "Head" then lb.BackgroundColor3 = Color3.fromRGB(0, 180, 0) end
end

CreateToggle("ล็อคเป้า", function(v)
    AimbotActive = v
    LockFrame.Visible = v
    LockFrame.Size = v and UDim2.new(1, -10, 0, 70) or UDim2.new(1, -10, 0, 0)
end)
CreateLockBtn("ล็อคหัว 100%", "Head")
CreateLockBtn("ล็อคตัว 100%", "HumanoidRootPart")

game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotActive then
        local target = nil
        local dist = math.huge
        local cam = workspace.CurrentCamera
        
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild(AimTargetPart) then
                local pos, onScreen = cam:WorldToViewportPoint(p.Character[AimTargetPart].Position)
                if onScreen then
                    -- Visible Check (เช็คว่าพ้นกำแพงไหม)
                    local ray = Ray.new(cam.CFrame.Position, (p.Character[AimTargetPart].Position - cam.CFrame.Position).Unit * 1000)
                    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character, p.Character})
                    
                    if not hit then
                        local mag = (p.Character[AimTargetPart].Position - cam.CFrame.Position).Magnitude
                        if mag < dist then target = p.Character dist = mag end
                    end
                end
            end
        end
        if target then
            cam.CFrame = CFrame.new(cam.CFrame.Position, target[AimTargetPart].Position)
        end
    end
end)

-- [[ 2. มองทะลุ ]]
local RedESP = false
CreateToggle("มองทะลุ", function(v) 
    RedESP = v 
    if not v then
        for _, x in pairs(workspace:GetDescendants()) do if x.Name == "NK_ESP" then x:Destroy() end end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if RedESP then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                if not p.Character:FindFirstChild("NK_ESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "NK_ESP"
                    hl.Parent = p.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end
    end
end)

-- [[ 3. วิ่งเร็ว (คูณจากความเร็วปัจจุบันของแมพ) ]]
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Parent = Content
SpeedFrame.Size = UDim2.new(1, -10, 0, 0)
SpeedFrame.Visible = false
SpeedFrame.BackgroundTransparency = 1
local SList = Instance.new("UIListLayout")
SList.Parent = SpeedFrame
SList.Padding = UDim.new(0, 5)

local SpeedMult = 1
local function CreateSpeedBtn(val)
    local sb = Instance.new("TextButton")
    sb.Parent = SpeedFrame
    sb.Size = UDim2.new(1, 0, 0, 30)
    sb.Text = "วิ่ง x"..val
    sb.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    sb.TextColor3 = Color3.fromRGB(255, 255, 255)
    sb.MouseButton1Click:Connect(function()
        SpeedMult = val
        for _, b in pairs(SpeedFrame:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(180, 0, 0) end
        end
        sb.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end)
end

CreateToggle("วิ่งเร็ว", function(v)
    SpeedFrame.Visible = v
    SpeedFrame.Size = v and UDim2.new(1, -10, 0, 180) or UDim2.new(1, -10, 0, 0)
    SpeedMult = v and SpeedMult or 1
end)
CreateSpeedBtn(50) CreateSpeedBtn(100) CreateSpeedBtn(150) CreateSpeedBtn(200) CreateSpeedBtn(250)

game:GetService("RunService").Stepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local currentBaseSpeed = 16 -- หรือดึงค่าจริงจากแมพมาคูณ
        char.Humanoid.WalkSpeed = currentBaseSpeed * SpeedMult
    end
end)

-- [[ 4. เดินทะลุ (Fixed No-Bug) ]]
local Wallhack = false
CreateToggle("เดินทะลุ", function(v) Wallhack = v end)
game:GetService("RunService").Stepped:Connect(function()
    if Wallhack and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            -- ทะลุแค่ตัวเรา ไม่ทะลุของในมือ (Tools) เพื่อกันของจมพื้น
            if part:IsA("BasePart") and not part:IsDescendantOf(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") or Instance.new("Folder")) then
                if part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- [[ 5. กระโดดรัว ]]
local InfJump = false
CreateToggle("กระโดดรัว", function(v) InfJump = v end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

