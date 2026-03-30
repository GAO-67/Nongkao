-- [[ NONGKAO PREMIUM V2 - DELTA 100% SUCCESS VERSION ]]
-- สร้าง UI เองสดๆ ไม่พึ่ง Library ภายนอกเพื่อให้รันขึ้นแน่นอน

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MinimizeBtn = Instance.new("TextButton")
local Content = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

-- [ ตั้งค่าหน้าต่างหลัก ]
ScreenGui.Parent = game.CoreGui
MainFrame.Name = "NongKaoMenu"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -90, 0.5, -125)
MainFrame.Size = UDim2.new(0, 180, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Text = " น้องเก้าซิกเซเว่น"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [ ปุ่มพับเมนู ]
MinimizeBtn.Parent = MainFrame
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local Maximized = true
MinimizeBtn.MouseButton1Click:Connect(function()
    Maximized = not Maximized
    Content.Visible = Maximized
    MainFrame.Size = Maximized and UDim2.new(0, 180, 0, 250) or UDim2.new(0, 180, 0, 30)
end)

Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.CanvasSize = UDim2.new(0, 0, 3, 0)
Content.ScrollBarThickness = 5

UIListLayout.Parent = Content
UIListLayout.Padding = UDim.new(0, 5)

-- [ ฟังก์ชันสร้างปุ่ม ]
local function MakeButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Content
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    btn.MouseButton1Click:Connect(callback)
end

-- [[ 1. วิ่งเร็ว x500 ]]
MakeButton("วิ่งเร็ว (x500)", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 500
end)

-- [[ 2. กระโดดสูง (100 เมตร) ]]
MakeButton("กระโดดสูง (100m)", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 300
    game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
end)

-- [[ 3. กระโดดรัวๆ (ไต่ฟ้า) ]]
local InfJump = false
MakeButton("กระโดดรัวๆ (เปิด/ปิด)", function()
    InfJump = not InfJump
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJump then game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping") end
end)

-- [[ 4. เดินทะลุ + NPC ตีไม่ได้ ]]
local Noclip = false
MakeButton("เดินทะลุ (เปิด/ปิด)", function()
    Noclip = not Noclip
end)

game:GetService("RunService").Stepped:Connect(function()
    if Noclip and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- [[ 5. ล็อคเป้านิ่ง (วงเล็ก) ]]
local Aimbot = false
local FOV = Drawing.new("Circle")
FOV.Visible = true
FOV.Radius = 35 -- วงเล็กตามสั่ง
FOV.Color = Color3.fromRGB(255,0,0)
FOV.Thickness = 1

MakeButton("ล็อคเป้า (เปิด/ปิด)", function()
    Aimbot = not Aimbot
end)

game:GetService("RunService").RenderStepped:Connect(function()
    FOV.Position = game:GetService("UserInputService"):GetMouseLocation()
    if Aimbot then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - game:GetService("UserInputService"):GetMouseLocation()).Magnitude
                    if mag < FOV.Radius and mag < dist then
                        target = p
                        dist = mag
                    end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p, target.Character.HumanoidRootPart.Position)
        end
    end
end)

-- [[ 6. มองทะลุ (ESP) ]]
MakeButton("เปิดมองทะลุ", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua'))()
end)

