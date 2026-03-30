-- [[ NONGKAO V7.1 - DELTA FIX (น้องเก้าเองครับ) ]]
-- สร้าง UI เองทั้งหมดเพื่อให้รันขึ้น 100% โดยไม่ต้องโหลด Library

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local MinimizeBtn = Instance.new("TextButton")

-- [ Setup Main UI ]
ScreenGui.Parent = game:GetService("CoreGui")
MainFrame.Name = "NongKao_V7_1"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -95, 0.5, -150)
MainFrame.Size = UDim2.new(0, 190, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, -35, 0, 35)
Title.Text = " น้องเก้าเองครับ "
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 35, 0, 35)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
Content.CanvasSize = UDim2.new(0, 0, 10, 0)
Content.ScrollBarThickness = 2
Content.BackgroundTransparency = 1

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 6)

-- [ ฟังก์ชันสร้างปุ่ม Toggle ]
local function CreateToggle(name, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(state)
    end)
    return btn
end

-- [[ ฟังก์ชั่นที่ 1: กระสุนวิเศษ (Silent Aim 360 Head) ]]
local SilentAim = false
CreateToggle("กระสุนวิเศษ", function(v) SilentAim = v end)

local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if SilentAim and (method == "FindPartOnRayWithIgnoreList" or method == "Raycast") then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                local mag = (p.Character.Head.Position - game.Players.LocalPlayer.Character.Head.Position).Magnitude
                if mag < dist then target = p dist = mag end
            end
        end
        if target then
            if method == "FindPartOnRayWithIgnoreList" then
                args[1] = Ray.new(workspace.CurrentCamera.CFrame.Position, (target.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 1000)
            end
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- [[ ฟังก์ชั่นที่ 2: มองทะลุ (Highlight ESP) ]]
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

-- [[ ฟังก์ชั่นที่ 3: วิ่งเร็ว (Speed Select + Color Update) ]]
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Parent = Content
SpeedContainer.Size = UDim2.new(1, -10, 0, 0)
SpeedContainer.Visible = false
SpeedContainer.BackgroundTransparency = 1
local SList = Instance.new("UIListLayout")
SList.Parent = SpeedContainer
SList.Padding = UDim.new(0, 5)

local CurrentSpeed = 16
local function CreateSpeedBtn(val)
    local sb = Instance.new("TextButton")
    sb.Parent = SpeedContainer
    sb.Size = UDim2.new(1, 0, 0, 30)
    sb.Text = "ความเร็ว x"..val
    sb.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    sb.TextColor3 = Color3.fromRGB(255, 255, 255)
    sb.MouseButton1Click:Connect(function()
        CurrentSpeed = val
        for _, b in pairs(SpeedContainer:GetChildren()) do
            if b:IsA("TextButton") then b.BackgroundColor3 = Color3.fromRGB(200, 0, 0) end
        end
        sb.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end)
end

CreateToggle("วิ่งเร็ว", function(v)
    SpeedContainer.Visible = v
    SpeedContainer.Size = v and UDim2.new(1, -10, 0, 180) or UDim2.new(1, -10, 0, 0)
    if not v then CurrentSpeed = 16 end
end)
CreateSpeedBtn(50) CreateSpeedBtn(100) CreateSpeedBtn(150) CreateSpeedBtn(200) CreateSpeedBtn(250)

game:GetService("RunService").Stepped:Connect(function()
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = CurrentSpeed
    end
end)

-- [[ ฟังก์ชั่นที่ 4: เดินทะลุ (Smart Wallhack) ]]
local Wallhack = false
CreateToggle("เดินทะลุ", function(v) Wallhack = v end)
game:GetService("RunService").Stepped:Connect(function()
    if Wallhack and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
        end
    end
end)

-- [[ ฟังก์ชั่นที่ 5: อมตะ (God Mode) ]]
local God = false
CreateToggle("อมตะ", function(v) God = v end)
game:GetService("RunService").RenderStepped:Connect(function()
    if God and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.Health = 999999
    end
end)

-- [[ ฟังก์ชั่นที่ 6: กระโดดรัว (ไต่ฟ้า) ]]
local InfJump = false
CreateToggle("กระโดดรัว", function(v) InfJump = v end)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

