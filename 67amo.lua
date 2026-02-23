

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local PPS = game:GetService("ProximityPromptService")
local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local pGui = player:WaitForChild("PlayerGui")

--====================================================
-- 🎨 UTILS & ANIMATIONS
--====================================================
local function animate(obj, properties, duration, style)
    local info = TweenInfo.new(duration or 0.5, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, info, properties)
    tween:Play()
    return tween
end

--====================================================
-- 🛡️ GUI ROOT
--====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AlawiUltimate_" .. math.random(100, 999)
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if gethui then screenGui.Parent = gethui() else screenGui.Parent = pGui end
end)

--====================================================
-- 🎬 CUSTOM WELCOME SCREEN
--====================================================
local function playIntro()
    local intro = Instance.new("Frame", screenGui)
    intro.Size = UDim2.fromScale(1, 1)
    intro.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    intro.ZIndex = 1000
    intro.BorderSizePixel = 0

    local content = Instance.new("Frame", intro)
    content.Size = UDim2.fromOffset(400, 300)
    content.Position = UDim2.fromScale(0.5, 0.5)
    content.AnchorPoint = Vector2.new(0.5, 0.5)
    content.BackgroundTransparency = 1

    local img = Instance.new("ImageLabel", content)
    img.Size = UDim2.fromOffset(120, 120)
    img.Position = UDim2.fromScale(0.5, 0.3)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
    img.BackgroundTransparency = 1
    Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
    local imgStroke = Instance.new("UIStroke", img)
    imgStroke.Color = Color3.fromRGB(0, 255, 200)
    imgStroke.Thickness = 3

    local welcomeText = Instance.new("TextLabel", content)
    welcomeText.Size = UDim2.new(1, 0, 0, 50)
    welcomeText.Position = UDim2.fromScale(0.5, 0.65)
    welcomeText.AnchorPoint = Vector2.new(0.5, 0.5)
    welcomeText.BackgroundTransparency = 1
    welcomeText.Font = Enum.Font.GothamBlack
    welcomeText.Text = "منور سكربت amo"
    welcomeText.TextColor3 = Color3.fromRGB(0, 255, 200)
    welcomeText.TextSize = 28

    animate(intro, {BackgroundTransparency = 1}, 1)
    task.wait(3)
    intro:Destroy()
end
task.spawn(playIntro)

--====================================================
-- 🛠️ DRAGGABLE SYSTEM المتطور (يدعم اللمس)
--====================================================
local function makeDraggable(obj, handle)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

--====================================================
-- 📱 MAIN INTERFACE
--====================================================
local main = Instance.new("Frame", screenGui)
main.Size = UDim2.fromOffset(600, 520)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Active = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(0, 255, 200)
mainStroke.Thickness = 2.5
mainStroke.Transparency = 0.4

--====================================================
-- 🎯 TOP BAR (قابل للسحب)
--====================================================
local topBar = Instance.new("Frame")
topBar.Parent = main
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
topBar.BorderSizePixel = 0

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 20)
topBarCorner.Parent = topBar

-- عنوان
local title = Instance.new("TextLabel")
title.Parent = topBar
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.fromOffset(20, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "🔥 سكربت amo 🔥"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left

-- زر إغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = topBar
closeBtn.Size = UDim2.fromOffset(40, 40)
closeBtn.Position = UDim2.new(1, -50, 0.5, -20)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundTransparency = 0.2
closeBtn.Text = "✕"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 24
closeBtn.BorderSizePixel = 0

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- جعل الواجهة قابلة للتحريك عن طريق الشريط العلوي
makeDraggable(main, topBar)

--====================================================
-- 📊 متتبع الموقع
--====================================================
local locationFrame = Instance.new("Frame")
locationFrame.Parent = main
locationFrame.Size = UDim2.new(1, -40, 0, 80)
locationFrame.Position = UDim2.fromOffset(20, 70)
locationFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
locationFrame.BorderSizePixel = 0

local locCorner = Instance.new("UICorner")
locCorner.CornerRadius = UDim.new(0, 15)
locCorner.Parent = locationFrame

local locStroke = Instance.new("UIStroke")
locStroke.Parent = locationFrame
locStroke.Color = Color3.fromRGB(0, 255, 200)
locStroke.Thickness = 1.5
locStroke.Transparency = 0.5

-- صورة اللاعب
local smallAvatar = Instance.new("ImageLabel")
smallAvatar.Parent = locationFrame
smallAvatar.Size = UDim2.fromOffset(50, 50)
smallAvatar.Position = UDim2.fromOffset(15, 15)
smallAvatar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
smallAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"
smallAvatar.BorderSizePixel = 0

local smallAvatarCorner = Instance.new("UICorner")
smallAvatarCorner.CornerRadius = UDim.new(1, 0)
smallAvatarCorner.Parent = smallAvatar

local smallAvatarStroke = Instance.new("UIStroke")
smallAvatarStroke.Color = Color3.fromRGB(0, 255, 200)
smallAvatarStroke.Thickness = 2
smallAvatarStroke.Parent = smallAvatar

-- نص الموقع
local locLabel = Instance.new("TextLabel")
locLabel.Parent = locationFrame
locLabel.Size = UDim2.new(1, -80, 1, 0)
locLabel.Position = UDim2.fromOffset(75, 0)
locLabel.BackgroundTransparency = 1
locLabel.Font = Enum.Font.GothamBold
locLabel.Text = "X: 0.00\nY: 0.00\nZ: 0.00"
locLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
locLabel.TextSize = 14
locLabel.TextXAlignment = Enum.TextXAlignment.Left

RunService.RenderStepped:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local p = hrp.Position
        locLabel.Text = string.format("X: %.2f\nY: %.2f\nZ: %.2f", p.X, p.Y, p.Z)
    end
end)

--====================================================
-- 📦 المحتوى (الأسكرولينج)
--====================================================
local container = Instance.new("ScrollingFrame")
container.Parent = main
container.Size = UDim2.new(1, -40, 1, -180)
container.Position = UDim2.fromOffset(20, 160)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 4
container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
container.CanvasSize = UDim2.new(0, 0, 2, 0)

local layout = Instance.new("UIGridLayout")
layout.Parent = container
layout.CellSize = UDim2.fromOffset(170, 50)
layout.CellPadding = UDim2.fromOffset(10, 10)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.StartCorner = Enum.StartCorner.TopLeft

--====================================================
-- 🎨 VARIABLES
--====================================================
local isGodmode = false
local ghostClone, connection, noclipConn, deathConn = nil, nil, nil, nil
local lastPromptUpdate = 0
local geniusSpeed = 70 
local instantTakeEnabled = false
local points = {
    Vector3.new(152.5, 3.16, -135.32), Vector3.new(242.45, 3.21, -139.48),
    Vector3.new(341.16, 3.21, -139.46), Vector3.new(466.67, 3.21, -139.51),
    Vector3.new(651.8, 3.21, -139.5), Vector3.new(912.58, 3.21, -139.47),
    Vector3.new(1302.22, 3.21, -139.48), Vector3.new(1989.5, 3.21, -136.06),
    Vector3.new(2605, 10, -135.49), Vector3.new(3135.5, 10, -135.65),
    Vector3.new(3490.5, 10, -135.65), Vector3.new(3853.5, 10, -135.65)
}
local index, conn = 0, nil

--====================================================
-- 🎯 SPEED CONTROL (مثل ETFB بالضبط)
--====================================================
local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedInput"
speedBox.Parent = main
speedBox.Size = UDim2.new(0, 250, 0, 40)
speedBox.Position = UDim2.new(0.5, -125, 0.92, 0)
speedBox.AnchorPoint = Vector2.new(0.5, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedBox.BackgroundTransparency = 0.5
speedBox.Text = tostring(geniusSpeed)
speedBox.PlaceholderText = "SPEED 1-1000"
speedBox.Font = Enum.Font.GothamBold
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 16

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedBox

local speedStroke = Instance.new("UIStroke")
speedStroke.Thickness = 1.2
speedStroke.Color = Color3.fromRGB(255, 255, 255)
speedStroke.Transparency = 0.8
speedStroke.Parent = speedBox

speedBox.FocusLost:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then
        val = math.clamp(val, 1, 1000)
        speedBox.Text = tostring(val)
        geniusSpeed = val
    else
        speedBox.Text = tostring(geniusSpeed)
    end
end)

--====================================================
-- 🚀 MOVEMENT FUNCTION (زي اللي طلبته بالضبط)
--====================================================
local function moveTo(pos)
    if conn then conn:Disconnect() end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    conn = RunService.RenderStepped:Connect(function(dt)
        local d = pos - hrp.Position
        if d.Magnitude < 1 then 
            hrp.CFrame = CFrame.new(pos) 
            conn:Disconnect() 
            return 
        end
        hrp.CFrame = CFrame.new(hrp.Position + d.Unit * math.min(d.Magnitude, 2500 * dt))
    end)
end

--====================================================
-- ⚡ GODMODE FUNCTIONS
--====================================================
local function cleanup()
    isGodmode = false
    if connection then connection:Disconnect() connection = nil end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if deathConn then deathConn:Disconnect() deathConn = nil end
    local char = player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root and ghostClone then root.CFrame = ghostClone.HumanoidRootPart.CFrame end
        if char:FindFirstChild("Humanoid") then 
            char.Humanoid.PlatformStand = false 
            camera.CameraSubject = char.Humanoid 
        end
    end
    if ghostClone then ghostClone:Destroy() ghostClone = nil end
end

local function enableGodmode()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    cleanup()
    isGodmode = true
    char.Archivable = true
    ghostClone = char:Clone()
    ghostClone.Name = "GhostDecoy"
    ghostClone.Parent = workspace
    char.Archivable = false
    for _, v in pairs(ghostClone:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Transparency = (v.Name:lower():find("root") or v.Name:lower():find("collision")) and 0.5 or 0
            v.CanCollide = true
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 0 end
    end
    if char:FindFirstChild("Animate") then char.Animate:Clone().Parent = ghostClone end
    char.Humanoid.PlatformStand = true
    camera.CameraSubject = ghostClone.Humanoid
    noclipConn = RunService.Stepped:Connect(function()
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
    connection = RunService.Heartbeat:Connect(function()
        if ghostClone and char and char:FindFirstChild("HumanoidRootPart") then
            local moveDir = char.Humanoid.MoveDirection
            ghostClone.Humanoid:Move(moveDir, false)
            ghostClone.Humanoid.Jump = char.Humanoid.Jump
            if moveDir.Magnitude > 0 then
                local targetRot = CFrame.lookAt(ghostClone.HumanoidRootPart.Position, ghostClone.HumanoidRootPart.Position + moveDir)
                ghostClone.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame:Lerp(targetRot, 0.25)
            end
            if tick() - lastPromptUpdate > 0.5 then
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") then
                        p.MaxActivationDistance = 25
                        p.RequiresLineOfSight = false
                    end
                end
                lastPromptUpdate = tick()
            end
            char.HumanoidRootPart.CFrame = ghostClone.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
            char.HumanoidRootPart.Velocity = Vector3.zero
        else cleanup() end
    end)
    deathConn = char.Humanoid.Died:Connect(cleanup)
end

player.CharacterAdded:Connect(function()
    if isGodmode then task.wait(0.5) enableGodmode() end
end)

PPS.PromptButtonHoldBegan:Connect(function(p)
    if instantTakeEnabled then
        fireproximityprompt(p)
    end
end)

--====================================================
-- 🎨 BUTTON CREATOR (مثل ETFB)
--====================================================
local function createBtn(txt, isToggle, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.fromOffset(170, 50)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.93
    btn.Font = Enum.Font.GothamBold
    btn.Text = txt
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Parent = btn
    btnStroke.Thickness = 1.2
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Transparency = 0.8
    
    local toggled = false
    
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            toggled = not toggled
            btn.Text = toggled and (txt .. " [ON]") or txt
            
            local targetColor = toggled and Color3.fromRGB(160, 0, 0) or Color3.fromRGB(255, 255, 255)
            local targetTrans = toggled and 0.3 or 0.93
            local strokeColor = toggled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 255, 255)

            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor, BackgroundTransparency = targetTrans}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.3), {Color = strokeColor}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(160,0,0)}):Play()
            task.delay(0.1, function()
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundTransparency = 0.93, BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
            end)
        end
        callback(isToggle and toggled or nil)
    end)
    
    return btn
end

--====================================================
-- 🚀 CREATE ALL BUTTONS (جميع الأزرار في مكان واحد)
--====================================================

-- أزرار الانتقال
createBtn("🤖 ذكاء اصطناعي", false, function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bestPoint = points[math.random(1, #points)]
    local minDistance = math.huge
    for _, p in pairs(points) do
        local dist = (p - hrp.Position).Magnitude
        if dist > 50 and dist < minDistance then
            minDistance = dist
            bestPoint = p
        end
    end
    moveTo(bestPoint)
end)

createBtn("🔄 إعادة تعيين", false, function()
    index = 0
end)

createBtn("🛡️ مكان آمن", false, function()
    moveTo(Vector3.new(152.5, 3.16, -135.32))
end)

createBtn("⬆️ النقطة التالية", false, function()
    if index < #points then 
        index = index + 1 
        moveTo(points[index])
    else
        index = 1
        moveTo(points[index])
    end
end)

createBtn("⬇️ النقطة السابقة", false, function()
    if index > 1 then 
        index = index - 1 
        moveTo(points[index])
    else
        index = #points
        moveTo(points[index])
    end
end)

-- أزرار المميزات
createBtn("⚡ God Mode", true, function(state)
    if state then enableGodmode() else cleanup() end
end)

createBtn("🎯 أخذ فوري", true, function(state)
    instantTakeEnabled = state
end)

createBtn("👑 فتح VIP", false, function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("vip") then
            v.CanCollide = false
            v.Transparency = 0.5
        end
    end
end)

createBtn("🔎 زوم لانهائي", false, function()
    player.CameraMaxZoomDistance = 2000
end)

createBtn("🌌 إضاءة كاملة", false, function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
end)

-- زر تغيير السرعة
createBtn("🚀 تغيير السرعة", false, function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = geniusSpeed
        player:SetAttribute("CurrentSpeed", geniusSpeed)
    end
end)

-- زر الحقوق (الموجود)
createBtn("📜 الحقوق", false, function()
    local r = Instance.new("Frame", screenGui)
    r.Size = UDim2.fromOffset(350, 250)
    r.Position = UDim2.fromScale(0.5, 0.5)
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    r.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    r.BorderSizePixel = 0
    r.ZIndex = 10
    Instance.new("UICorner", r).CornerRadius = UDim.new(0, 15)
    Instance.new("UIStroke", r).Color = Color3.fromRGB(0, 255, 200)
    
    local t = Instance.new("TextLabel", r)
    t.Size = UDim2.new(1, -20, 1, -80)
    t.Position = UDim2.fromOffset(10, 10)
    t.BackgroundTransparency = 1
    t.Font = Enum.Font.GothamBold
    t.TextColor3 = Color3.fromRGB(0, 255, 200)
    t.Text = "🔥 حقوق 🔥\n\n\nالسيرفر ديسكورد : سيرفر amo\n\nجميع الحقوق محفوظة © 2026"
    t.TextWrapped = true
    t.TextSize = 13
    t.TextXAlignment = Enum.TextXAlignment.Center
    
    local c = Instance.new("TextButton", r)
    c.Size = UDim2.fromOffset(120, 40)
    c.Position = UDim2.new(0.5, -60, 1, -50)
    c.Text = "إغلاق"
    c.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
    c.Font = Enum.Font.GothamBold
    c.TextColor3 = Color3.fromRGB(0, 0, 0)
    c.TextSize = 16
    c.BorderSizePixel = 0
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 10)
    c.MouseButton1Click:Connect(function() r:Destroy() end)
end)

--====================================================
-- ⚡ TOGGLE BUTTON (قابل للتحريك أيضاً)
--====================================================
local toggle = Instance.new("TextButton", screenGui)
toggle.Size = UDim2.fromOffset(80, 80)
toggle.Position = UDim2.new(0, 30, 0.8, 0)
toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggle.Text = "🔥"
toggle.Font = Enum.Font.GothamBlack
toggle.TextColor3 = Color3.fromRGB(0, 255, 200)
toggle.TextSize = 40
toggle.BorderSizePixel = 0
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", toggle)
tStroke.Color = Color3.fromRGB(0, 255, 200)
tStroke.Thickness = 3

-- جعل زر التبديل قابلاً للتحريك
makeDraggable(toggle, toggle)

toggle.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
    if main.Visible then
        main.Size = UDim2.fromOffset(0, 0)
        animate(main, {Size = UDim2.fromOffset(600, 520)}, 0.6, Enum.EasingStyle.Back)
    end
end)

main.Visible = false