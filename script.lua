-- Dueling Grounds Pro Hub with Floating Draggable Icon
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- إزالة أي واجهة قديمة لمنع التكرار
if CoreGui:FindFirstChild("DuelingGroundsHub") then
    CoreGui.DuelingGroundsHub:Destroy()
end

-- إنشاء الشاشة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DuelingGroundsHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الأيقونة العائمة (قابلة للسحب وتعمل كزر فتح وإغلاق)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Parent = ScreenGui
FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FloatingIcon.Position = UDim2.new(0, 30, 0, 150)
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Text = "⚔️"
FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.TextSize = 22

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0) -- جعلها دائرية تماماً
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 215, 0)
IconStroke.Thickness = 2
IconStroke.Parent = FloatingIcon

-- النافذة الرئيسية للقائمة
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
MainFrame.Size = UDim2.new(0, 320, 0, 330)
MainFrame.Visible = false -- مخفية حتى يتم الضغط على الأيقونة

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 215, 0)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- عنوان القائمة
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 15)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Dueling Grounds Hub"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 18

-- دالة لإنشاء الأزرار بشكل مرتب وسريع
local function createFeatureButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.TextSize = 14

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    return btn
end

-- إنشاء أزرار الميزات الخاصة بالماب
local AutoParryBtn = createFeatureButton("Auto Parry", 65)
local AutoDodgeBtn = createFeatureButton("Auto Dodge", 125)
local SkinBtn = createFeatureButton("Unlock Cosmetics", 185)

-- زر إغلاق القائمة من الداخل
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseBtn.Position = UDim2.new(0.1, 0, 0, 255)
CloseBtn.Size = UDim2.new(0.8, 0, 0, 40)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "Close Menu"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- تفعيل إظهار وإخفاء القائمة بضغطة واحدة على الأيقونة أو زر الإغلاق
local function toggleMenu()
    MainFrame.Visible = not MainFrame.Visible
end

FloatingIcon.MouseButton1Click:Connect(toggleMenu)
CloseBtn.MouseButton1Click:Connect(toggleMenu)

-- نظام تفعيل وإيقاف الميزات (ON / OFF)
local function setupToggle(button, featureName)
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        if state then
            button.Text = featureName .. ": ON"
            button.TextColor3 = Color3.fromRGB(100, 255, 100)
        else
            button.Text = featureName .. ": OFF"
            button.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

setupToggle(AutoParryBtn, "Auto Parry")
setupToggle(AutoDodgeBtn, "Auto Dodge")
setupToggle(SkinBtn, "Unlock Cosmetics")

-- برمجة سحب الأيقونة العائمة (Draggable Feature) لتغيير مكانها بالشاشة بحرية
local dragging, dragInput, dragStart, startPos

FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
        
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
        FloatingIcon.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("Dueling Grounds Pro Hub Loaded Successfully!")
