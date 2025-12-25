local Notification = {}

local Services = setmetatable({}, {
    __index = function(Self, ServiceName)
        local CloneReference = cloneref and type(cloneref) == "function" and cloneref or function(Value) return Value end
        local Success, Service = pcall(function() return CloneReference(game:GetService(ServiceName)) end)
        if Success and Service then
            rawset(Self, ServiceName, Service)
            return Service
        end
    end
})

local function GetService(ServiceName)
    return Services[ServiceName]
end

local Players = GetService("Players")
local TweenService = GetService("TweenService")
local TextService = GetService("TextService")
local CoreGui = GetService("CoreGui")

local function RandomString()
    local Length = math.random(10,20)
    local Array = {}
    for I = 1, Length do
        Array[I] = string.char(math.random(32, 126))
    end
    return table.concat(Array)
end

local function Tween(Obj, Time, Props, Style, Direction)
    local TweenInfo = TweenInfo.new(Time or 0.3, Style or Enum.EasingStyle.Quad, Direction or Enum.EasingDirection.Out)
    return TweenService:Create(Obj, TweenInfo, Props)
end

local function CreateCorner(Parent, Radius)
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, Radius or 6)
    Corner.Parent = Parent
    return Corner
end

local ActiveNotifications = {}
local NotificationQueue = {}
local NotificationHeight = 120
local NotificationSpacing = 10
local MaxNotifications = 4

local function CalculateNotificationTextHeight(Text, TextSize, Font, MaxWidth)
    local TextBounds = TextService:GetTextSize(
        Text,
        TextSize,
        Font,
        Vector2.new(MaxWidth, math.huge)
    )
    return math.max(TextBounds.Y + 10, TextSize + 10)
end

local function CreateNotificationCloseButton(Parent)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = RandomString()
    CloseButton.Parent = Parent
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -30, 0, 10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "x"
    CloseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    CloseButton.TextScaled = true
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.ZIndex = 15003

    CreateCorner(CloseButton, 5)

    return CloseButton
end

local function ReorganizeNotifications()
    local CurrentY = 20
    
    for I, Notification in ipairs(ActiveNotifications) do
        if Notification and Notification.Frame and Notification.Frame.Parent then
            local TargetPosition = UDim2.new(1, -320, 0, CurrentY)
            
            Tween(Notification.Frame, 0.3, {
                Position = TargetPosition
            }, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
            
            CurrentY = CurrentY + Notification.Height + NotificationSpacing
        end
    end
end

local function RemoveNotification(NotificationData)
    if not NotificationData or not NotificationData.Frame then return end
    
    for I, ActiveNotification in ipairs(ActiveNotifications) do
        if ActiveNotification == NotificationData then
            table.remove(ActiveNotifications, I)
            break
        end
    end
    
    local ExitTween = Tween(NotificationData.Frame, 0.3, {
        Position = UDim2.new(1, 50, 0, NotificationData.Frame.Position.Y.Offset),
        BackgroundTransparency = 1
    }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    
    ExitTween:Play()
    ExitTween.Completed:Connect(function()
        if NotificationData.Gui then
            NotificationData.Gui:Destroy()
        end
    end)
    
    ReorganizeNotifications()
end

local function CheckNotificationLimit()
    if #ActiveNotifications >= MaxNotifications then
        local OldestNotification = ActiveNotifications[1]
        RemoveNotification(OldestNotification)
    end
end

function Notification.Notify2(Config)
    CheckNotificationLimit()
    
    local DefaultConfig = {
        Title = "Notification",
        Content = "This is a notification message.",
        Duration = 5,
        Button1 = nil,
        Button2 = nil
    }
    
    for Key, Value in pairs(Config or {}) do
        DefaultConfig[Key] = Value
    end
    
    local Cfg = DefaultConfig
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = RandomString()
    NotificationGui.Parent = CoreGui
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local ContentWidth = 250
    local ContentHeight = CalculateNotificationTextHeight(Cfg.Content, 12, Enum.Font.Gotham, ContentWidth)
    
    local MinHeight = 80
    local ButtonHeight = (Cfg.Button1 or Cfg.Button2) and 35 or 0
    local HeaderHeight = 35
    local Padding = 20
    
    local TotalHeight = math.max(MinHeight, HeaderHeight + ContentHeight + ButtonHeight + Padding)
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = RandomString()
    MainFrame.Parent = NotificationGui
    MainFrame.Size = UDim2.new(0, 300, 0, TotalHeight)
    MainFrame.Position = UDim2.new(1, 50, 0, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 15001
    
    CreateCorner(MainFrame, 10)
    
    local CloseButton = CreateNotificationCloseButton(MainFrame)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = RandomString()
    TitleLabel.Parent = MainFrame
    TitleLabel.Size = UDim2.new(1, -60, 0, 25)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Cfg.Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 15002
    
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Name = RandomString()
    ContentLabel.Parent = MainFrame
    ContentLabel.Size = UDim2.new(1, -20, 0, ContentHeight)
    ContentLabel.Position = UDim2.new(0, 10, 0, HeaderHeight)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Cfg.Content
    ContentLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    ContentLabel.TextSize = 12
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.TextWrapped = true
    ContentLabel.ZIndex = 15002
    
    local NotificationData = {
        Gui = NotificationGui,
        Frame = MainFrame,
        Height = TotalHeight,
        Duration = Cfg.Duration
    }
    
    local function CloseNotification()
        RemoveNotification(NotificationData)
    end
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, 0.2, {BackgroundColor3 = Color3.fromRGB(230, 230, 230), Size = UDim2.new(0, 22, 0, 22)}):Play()
        Tween(CloseButton, 0.2, {ImageColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 20, 0, 20)}):Play()
        Tween(CloseButton, 0.2, {ImageColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CloseNotification()
    end)
    
    if Cfg.Button1 or Cfg.Button2 then
        local ButtonY = TotalHeight - 35
        
        if Cfg.Button1 and Cfg.Button2 then
            local Button1 = Instance.new("TextButton")
            Button1.Name = RandomString()
            Button1.Parent = MainFrame
            Button1.Size = UDim2.new(0, 130, 0, 25)
            Button1.Position = UDim2.new(0, 15, 0, ButtonY)
            Button1.BackgroundColor3 = Cfg.Button1.Accent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 20)
            Button1.BorderSizePixel = 0
            Button1.Text = Cfg.Button1.Text or "Button 1"
            Button1.TextColor3 = Cfg.Button1.Accent and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            Button1.TextSize = 13
            Button1.Font = Enum.Font.Gotham
            Button1.ZIndex = 15002
            
            CreateCorner(Button1, 6)
            
            local Button2 = Instance.new("TextButton")
            Button2.Name = RandomString()
            Button2.Parent = MainFrame
            Button2.Size = UDim2.new(0, 130, 0, 25)
            Button2.Position = UDim2.new(0, 155, 0, ButtonY)
            Button2.BackgroundColor3 = Cfg.Button2.Accent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 20)
            Button2.BorderSizePixel = 0
            Button2.Text = Cfg.Button2.Text or "Button 2"
            Button2.TextColor3 = Cfg.Button2.Accent and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            Button2.TextSize = 13
            Button2.Font = Enum.Font.Gotham
            Button2.ZIndex = 15002
            
            CreateCorner(Button2, 6)
            
            Button1.MouseEnter:Connect(function()
                Tween(Button1, 0.2, {
                    BackgroundColor3 = Cfg.Button1.Accent and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(35, 35, 35),
                    Size = UDim2.new(0, 132, 0, 27)
                }):Play()
            end)
            
            Button1.MouseLeave:Connect(function()
                Tween(Button1, 0.2, {
                    BackgroundColor3 = Cfg.Button1.Accent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 20),
                    Size = UDim2.new(0, 130, 0, 25)
                }):Play()
            end)
            
            Button2.MouseEnter:Connect(function()
                Tween(Button2, 0.2, {
                    BackgroundColor3 = Cfg.Button2.Accent and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(35, 35, 35),
                    Size = UDim2.new(0, 132, 0, 27)
                }):Play()
            end)
            
            Button2.MouseLeave:Connect(function()
                Tween(Button2, 0.2, {
                    BackgroundColor3 = Cfg.Button2.Accent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 20),
                    Size = UDim2.new(0, 130, 0, 25)
                }):Play()
            end)
            
            Button1.MouseButton1Click:Connect(function()
                if Cfg.Button1.Callback then
                    Cfg.Button1.Callback()
                end
                if not Cfg.Button1.KeepOpen then
                    CloseNotification()
                end
            end)
            
            Button2.MouseButton1Click:Connect(function()
                if Cfg.Button2.Callback then
                    Cfg.Button2.Callback()
                end
                if not Cfg.Button2.KeepOpen then
                    CloseNotification()
                end
            end)
            
        elseif Cfg.Button1 then
            local Button1 = Instance.new("TextButton")
            Button1.Name = RandomString()
            Button1.Parent = MainFrame
            Button1.Size = UDim2.new(0, 270, 0, 25)
            Button1.Position = UDim2.new(0, 15, 0, ButtonY)
            Button1.BackgroundColor3 = Cfg.Button1.Accent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 20)
            Button1.BorderSizePixel = 0
            Button1.Text = Cfg.Button1.Text or "OK"
            Button1.TextColor3 = Cfg.Button1.Accent and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            Button1.TextSize = 13
            Button1.Font = Enum.Font.Gotham
            Button1.ZIndex = 15002
            
            CreateCorner(Button1, 6)
            
            Button1.MouseEnter:Connect(function()
                Tween(Button1, 0.2, {
                    BackgroundColor3 = Cfg.Button1.Accent and Color3.fromRGB(230, 230, 230) or Color3.fromRGB(35, 35, 35),
                    Size = UDim2.new(0, 272, 0, 27)
                }):Play()
            end)
            
            Button1.MouseLeave:Connect(function()
                Tween(Button1, 0.2, {
                    BackgroundColor3 = Cfg.Button1.Accent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(20, 20, 20),
                    Size = UDim2.new(0, 270, 0, 25)
                }):Play()
            end)
            
            Button1.MouseButton1Click:Connect(function()
                if Cfg.Button1.Callback then
                    Cfg.Button1.Callback()
                end
                if not Cfg.Button1.KeepOpen then
                    CloseNotification()
                end
            end)
        end
    end
    
    table.insert(ActiveNotifications, NotificationData)
    
    local TargetY = 20
    for I = 1, #ActiveNotifications - 1 do
        TargetY = TargetY + ActiveNotifications[I].Height + NotificationSpacing
    end
    
    local TargetPosition = UDim2.new(1, -320, 0, TargetY)
    Tween(MainFrame, 0.4, {Position = TargetPosition}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    
    if Cfg.Duration > 0 then
        task.spawn(function()
            task.wait(Cfg.Duration)
            if NotificationGui and NotificationGui.Parent then
                CloseNotification()
            end
        end)
    end
    
    return NotificationData
end

function Notification.Notify(Title, Content, Duration)
    CheckNotificationLimit()
    
    local ContentWidth = 250
    local ContentHeight = CalculateNotificationTextHeight(Content or "Message", 12, Enum.Font.Gotham, ContentWidth)
    
    local HeaderHeight = 35
    local Padding = 20
    local TotalHeight = HeaderHeight + ContentHeight + Padding
    
    local NotificationGui = Instance.new("ScreenGui")
    NotificationGui.Name = RandomString()
    NotificationGui.Parent = CoreGui
    NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = RandomString()
    MainFrame.Parent = NotificationGui
    MainFrame.Size = UDim2.new(0, 300, 0, TotalHeight)
    MainFrame.Position = UDim2.new(1, 50, 0, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 15001
    
    CreateCorner(MainFrame, 10)
    
    local CloseButton = CreateNotificationCloseButton(MainFrame)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = RandomString()
    TitleLabel.Parent = MainFrame
    TitleLabel.Size = UDim2.new(1, -60, 0, 25)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title or "Notification"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 15002
    
    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Name = RandomString()
    ContentLabel.Parent = MainFrame
    ContentLabel.Size = UDim2.new(1, -20, 0, ContentHeight)
    ContentLabel.Position = UDim2.new(0, 10, 0, HeaderHeight)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = Content or "Message"
    ContentLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    ContentLabel.TextSize = 12
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
    ContentLabel.TextWrapped = true
    ContentLabel.ZIndex = 15002
    
    local NotificationData = {
        Gui = NotificationGui,
        Frame = MainFrame,
        Height = TotalHeight,
        Duration = Duration or 3
    }
    
    local function CloseNotification()
        RemoveNotification(NotificationData)
    end
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, 0.2, {BackgroundColor3 = Color3.fromRGB(230, 230, 230), Size = UDim2.new(0, 22, 0, 22)}):Play()
        Tween(CloseButton, 0.2, {ImageColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 255, 255), Size = UDim2.new(0, 20, 0, 20)}):Play()
        Tween(CloseButton, 0.2, {ImageColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CloseNotification()
    end)
    
    table.insert(ActiveNotifications, NotificationData)
    
    local TargetY = 20
    for I = 1, #ActiveNotifications - 1 do
        TargetY = TargetY + ActiveNotifications[I].Height + NotificationSpacing
    end
    
    local TargetPosition = UDim2.new(1, -320, 0, TargetY)
    Tween(MainFrame, 0.4, {Position = TargetPosition}, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    
    if NotificationData.Duration > 0 then
        task.spawn(function()
            task.wait(NotificationData.Duration)
            if NotificationGui and NotificationGui.Parent then
                CloseNotification()
            end
        end)
    end
    
    return NotificationData
end

function Notification.SetMaxNotifications(max)
    MaxNotifications = max
end

function Notification.SetNotificationSpacing(spacing)
    NotificationSpacing = spacing
end

function Notification.ClearAllNotifications()
    for _, notification in pairs(ActiveNotifications) do
        if notification and notification.Gui then
            notification.Gui:Destroy()
        end
    end
    ActiveNotifications = {}
end

return Notification
