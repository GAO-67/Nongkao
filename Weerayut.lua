-- [[ NONGKAO V9 - LOCK TARGET & REAL SPEED (น้องเก้าเองครับ) ]]
-- DELTA 100% | VISIBLE CHECK | MULTIPLY SPEED

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local MinimizeBtn = Instance.new("TextButton")

-- [ UI Setup ]
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "NongKao_V9"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Position = UDim2.new(0.5, -95, 0.5, -150)
MainFrame.Size = UDim2.new(0, 190, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, -35, 0, 35)
Title.Text = " น้องเก้าเองครับ "
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
Title.Font = Enum.Font.GothamBold

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(65, 0, 0)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local Maximized = true
MinimizeBtn.MouseButton1Click:Connect(function()
    Maximized = not Maximized
    Content.Visible = Maximized
    MainFrame.Size = Maximized and UDim2.new(0, 190, 0, 320) or UDim2.new(0, 190, 0, 35)
end)

Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, -35)
Content.Position = UDim2.new(0, 0, 0, 35)
Content.CanvasSize = UDim2.new(0, 0, 12, 0)
Content.ScrollBarThickness = 2
Content.BackgroundTransparency = 1

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 6)

-- [ Function Builder ]
local function CreateToggle(name, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        callback(state)
    end)
    return btn
end

-- [[ 1. ระบบล็อคเป้า (Visible Check Only) ]]
local AimbotEnabled = false
local AimPart = "Head" -- Default
local LockContainer = Instance.new("Frame")
LockContainer.Parent = Content
LockContainer.Size = UDim2.new(1, -10, 0, 0)
LockContainer.Visible = false
LockContainer.BackgroundTransparency = 1
local LList = Instance.new("UIListLayout")
LList.Parent = LockContainer
LList.Padding = UDim.new(0, 4)

local function CreateLockBtn(name, part)
    local lb = Instance.new("TextButton")
    lb.Parent = LockContainer
    lb.Size = UDim2.new(1, 0, 0, 30)
    lb.Text = name
    lb.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    lb.TextColor3 = Color3.fromRGB(255, 255, 255)
    lb.MouseButton1Click:Connect(function()
        AimPart = part
        for _, v in pairs(LockContainer:GetChildren()) do
            if v:IsA("TextButton") then v.BackgroundColor3 = Color3.fromRGB(150, 0, 0) end
        end
        lb.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end)
end

CreateToggle("ล็อคเป้า", function(v)
    AimbotEnabled = v
    LockContainer.Visible = v
    LockContainer.Size = v and UDim2.new(1, -10, 0, 70) or UDim2.new(1, -10, 0, 0)
end)
CreateLockBtn("ล็อคหัว 100%", "Head")
CreateLockBtn("ล็อคตัว 100%", "HumanoidRootPart")

game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild(AimPart) then
                -- Visible Check (เช็คว่าโผล่มาให้เห็นไหม)
                local char = p.Character
                local head = char:FindFirstChild("Head")
                local cam = workspace.CurrentCamera
                local ray = Ray.new(cam.CFrame.Position, (head.Position - cam.CFrame.Position).Unit * 1000)
                local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, {game.Players.LocalPlayer.Character, char})
                
                if not hit then -- ถ้าไม่มีอะไรบัง
                    local mag = (head.Position - cam.CFrame.Position).Magnitude
                    if mag < dist then target = char dist = mag end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target[AimPart].Position)
        end
    end
end)

-- [[ 2. มองทะลุ ]]
local RedESP = false
CreateToggle("มองทะลุ", function(v) 
    RedESP = v 
    if not v then
        for _, x in pairs(game.Workspace:GetDescendants()) do if x.Name == "NK_ESP" then x:Destroy() end end
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

-- [[ 3. วิ่งเร็ว (Multiply Speed x50 - x250) ]]
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = Content
SpeedContainer.Size = UDim2.new(1, -10, 0, 0)
SpeedContainer.Visible = false
SpeedContainer.BackgroundTransparency = 1
local SList = Instance.new("UIListLayout")
SList.Parent = SpeedContainer
SList.Padding = UDim.new(0, 5)

local SpeedMult = 1
local function CreateSpeedBtn(val)
    local sb = Instance.new("TextButton")
    sb.Parent = SpeedContainer
    sb.Size = UDim2.new(1, 0, 0, 30)
    sb.Text = "วิ่ง x"..val
    sb.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    sb.TextColor3 = Color3.fromRGB(255, 255, 255)
    sb.MouseButton1Click:Connect(function()
        SpeedMult = val
        for _, b in pairs(SpeedContainer:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(150, 0, 0) end
        end
        sb.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end)
end

CreateToggle("วิ่งเร็ว", function(v)
    SpeedContainer.Visible = v
    SpeedContainer.Size = v and UDim2.new(1, -10, 0, 180) or UDim2.new(1, -10, 0, 0)
    SpeedMult = v and SpeedMult or 1
end)
CreateSpeedBtn(50) CreateSpeedBtn(100) CreateSpeedBtn(150) CreateSpeedBtn(200) CreateSpeedBtn(250)

game:GetService("RunService").Stepped:Connect(function()
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then
        -- คูณจากความเร็วปัจจุบันของแมพนั้นๆ
        hum.WalkSpeed = 16 * SpeedMult
    end
end)

-- [[ 4. เดินทะลุ (Fixed Wallhack - ไม่บัคของถือ) ]]
local Wallhack = false
CreateToggle("เดินทะลุ", function(v) Wallhack = v end)
game:GetService("RunService").Stepped:Connect(function()
    if Wallhack and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            -- ทะลุเฉพาะตัวละคร ไม่ไปยุ่งกับของที่ถือ (Handle/Tools)
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

