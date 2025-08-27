local InventoryViewer = {}
InventoryViewer.Enabled = false
InventoryViewer.PlayerStates = {}
InventoryViewer.ActiveScroller = nil

local CloneRef = cloneref or function(Instance)
    return Instance
end

local function RandomString()
    local Length = math.random(10,20)
    local Array = {}
    for I = 1, Length do
        Array[I] = string.char(math.random(32, 126))
    end
    return table.concat(Array)
end

local TweenService = CloneRef(game:GetService("TweenService"))
local RunService = CloneRef(game:GetService("RunService"))
local UserInputService = CloneRef(game:GetService("UserInputService"))
local Players = CloneRef(game:GetService("Players"))

local Player = Players.LocalPlayer
if not Player then return InventoryViewer end

local CONFIG = {
    Distance = 16,
    ScrollSpeed = 20,
    AnimTime = 0.3,
    Platforms = {
        PC = {"rbxassetid://10688463768", Color3.fromRGB(80, 140, 220)},
        Mobile = {"rbxassetid://10688464303", Color3.fromRGB(80, 220, 120)},
        Console = {"rbxassetid://10688463319", Color3.fromRGB(220, 80, 80)},
        Unknown = {"", Color3.fromRGB(150, 150, 150)}
    }
}

local Connections = {}

local function GetPlayerPlatform(PlayerObj)
    local Platform = "Unknown"
    if PlayerObj.GameplayPaused then 
        Platform = "Mobile" 
    end
    if UserInputService:GetPlatform() == Enum.Platform.Windows and PlayerObj == Player then 
        Platform = "PC" 
    end
    return Platform
end

local function AnimateElement(State, Direction)
    if State.Tweens then
        for _, Tween in ipairs(State.Tweens) do 
            Tween:Cancel() 
        end
    end
    State.Tweens = {}

    local TransparencyGoal, SizeGoal
    if Direction == "in" then
        TransparencyGoal = 0.2
        SizeGoal = UDim2.fromScale(1, 1)
    else
        TransparencyGoal = 1
        SizeGoal = UDim2.fromScale(0.8, 0.8)
    end
    
    local TransparencyTween = TweenService:Create(State.Main, TweenInfo.new(CONFIG.AnimTime, Enum.EasingStyle.Quint), {BackgroundTransparency = TransparencyGoal})
    local SizeTween = TweenService:Create(State.Root, TweenInfo.new(CONFIG.AnimTime, Enum.EasingStyle.Quint), {Size = SizeGoal})

    table.insert(State.Tweens, TransparencyTween)
    table.insert(State.Tweens, SizeTween)
    
    TransparencyTween:Play()
    SizeTween:Play()
    
    return SizeTween
end

local function CreatePlayerElements(PlayerObj)
    local State = { 
        CurrentState = "hidden", 
        Tweens = {} 
    }
    
    State.Gui = Instance.new("BillboardGui")
    State.Gui.Name = RandomString()
    State.Gui.AlwaysOnTop = true
    State.Gui.Size = UDim2.fromOffset(200, 80)
    State.Gui.StudsOffset = Vector3.new(0, 2.2, 0)

    State.Root = Instance.new("Frame")
    State.Root.Name = RandomString()
    State.Root.Parent = State.Gui
    State.Root.BackgroundTransparency = 1
    State.Root.ClipsDescendants = true
    State.Root.AnchorPoint = Vector2.new(0.5, 0.5)
    State.Root.Position = UDim2.fromScale(0.5, 0.5)
    State.Root.Size = UDim2.fromScale(0.8, 0.8)

    State.Main = Instance.new("Frame")
    State.Main.Name = RandomString()
    State.Main.Parent = State.Root
    State.Main.Size = UDim2.fromScale(1, 1)
    State.Main.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
    State.Main.Active = true
    State.Main.BackgroundTransparency = 1
    
    local Corner = Instance.new("UICorner")
    Corner.Name = RandomString()
    Corner.Parent = State.Main
    Corner.CornerRadius = UDim.new(0, 6)
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Name = RandomString()
    Stroke.Parent = State.Main
    Stroke.Color = Color3.fromRGB(10, 11, 13)

    local PlatformIcon = Instance.new("ImageLabel")
    PlatformIcon.Name = RandomString()
    PlatformIcon.Parent = State.Main
    PlatformIcon.Size = UDim2.fromOffset(14, 14)
    PlatformIcon.Position = UDim2.new(0, 4, 0, 4)
    PlatformIcon.BackgroundTransparency = 1
    State.PlatformIcon = PlatformIcon

    local HealthBar = Instance.new("Frame")
    HealthBar.Name = RandomString()
    HealthBar.Parent = State.Main
    HealthBar.Size = UDim2.new(0.8, 0, 0, 8)
    HealthBar.Position = UDim2.new(0.5, 0, 0, 4)
    HealthBar.AnchorPoint = Vector2.new(0.5, 0)
    HealthBar.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    
    local HealthCorner = Instance.new("UICorner")
    HealthCorner.Name = RandomString()
    HealthCorner.Parent = HealthBar
    HealthCorner.CornerRadius = UDim.new(1, 0)
    
    local HealthFill = Instance.new("Frame")
    HealthFill.Name = RandomString()
    HealthFill.Parent = HealthBar
    HealthFill.Size = UDim2.fromScale(1, 1)
    HealthFill.BackgroundColor3 = Color3.fromRGB(80, 220, 120)
    State.HealthFill = HealthFill
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.Name = RandomString()
    FillCorner.Parent = HealthFill
    FillCorner.CornerRadius = UDim.new(1, 0)
    
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = RandomString()
    ScrollFrame.Parent = State.Main
    ScrollFrame.Size = UDim2.new(1, -10, 1, -18)
    ScrollFrame.Position = UDim2.new(0.5, 0, 1, -4)
    ScrollFrame.AnchorPoint = Vector2.new(0.5, 1)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    State.ScrollFrame = ScrollFrame
    
    ScrollFrame.MouseEnter:Connect(function() 
        InventoryViewer.ActiveScroller = ScrollFrame 
    end)
    ScrollFrame.MouseLeave:Connect(function() 
        InventoryViewer.ActiveScroller = nil 
    end)

    local GridLayout = Instance.new("UIGridLayout")
    GridLayout.Name = RandomString()
    GridLayout.Parent = ScrollFrame
    GridLayout.CellSize = UDim2.fromOffset(28, 28)
    GridLayout.CellPadding = UDim2.fromOffset(4, 4)
    GridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local Tooltip = Instance.new("TextLabel")
    Tooltip.Name = RandomString()
    Tooltip.Parent = ScrollFrame
    Tooltip.Size = UDim2.new(1, 0, 0, 20)
    Tooltip.Position = UDim2.new(0, 0, 1, 22)
    Tooltip.BackgroundColor3 = Color3.fromRGB(10, 11, 13)
    Tooltip.Font = Enum.Font.SourceSans
    Tooltip.TextColor3 = Color3.new(1, 1, 1)
    Tooltip.TextSize = 14
    Tooltip.Visible = false
    State.Tooltip = Tooltip
    
    local TooltipCorner = Instance.new("UICorner")
    TooltipCorner.Name = RandomString()
    TooltipCorner.Parent = Tooltip
    TooltipCorner.CornerRadius = UDim.new(0, 4)
    
    InventoryViewer.PlayerStates[PlayerObj] = State
    return State
end

local function UpdateUI(PlayerObj, Character)
    if not InventoryViewer.Enabled then return end
    local State = InventoryViewer.PlayerStates[PlayerObj]
    if not (State and State.Gui) then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        local Health = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
        State.HealthFill.Size = UDim2.fromScale(Health, 1)
        State.HealthFill.BackgroundColor3 = Color3.fromHSV(0.33 * Health, 0.7, 0.8)
    end
    
    local PlatformData = CONFIG.Platforms[GetPlayerPlatform(PlayerObj)]
    State.PlatformIcon.Image = PlatformData[1]
    State.PlatformIcon.ImageColor3 = PlatformData[2]

    local CurrentTools = {}
    for _, Tool in pairs(PlayerObj.Backpack:GetChildren()) do
        if Tool:IsA("Tool") then
            table.insert(CurrentTools, Tool.Name)
        end
    end
    
    if not State.LastTools or table.concat(CurrentTools) ~= table.concat(State.LastTools) then
        State.LastTools = CurrentTools
        
        for _, Child in pairs(State.ScrollFrame:GetChildren()) do
            if Child:IsA("ImageButton") then 
                Child:Destroy() 
            end
        end
        
        for _, Tool in pairs(PlayerObj.Backpack:GetChildren()) do
            if Tool:IsA("Tool") then
                local Icon = Instance.new("ImageButton")
                Icon.Name = RandomString()
                Icon.Parent = State.ScrollFrame
                Icon.Size = UDim2.fromScale(1, 1)
                Icon.BackgroundTransparency = 1
                Icon.Image = Tool.TextureId
                
                Icon.MouseEnter:Connect(function() 
                    State.Tooltip.Text = Tool.Name
                    State.Tooltip.Visible = true
                    State.Tooltip.Parent = Icon
                end)
                Icon.MouseLeave:Connect(function() 
                    State.Tooltip.Visible = false
                    State.Tooltip.Parent = State.ScrollFrame
                end)
                Icon.MouseButton1Click:Connect(function() 
                    Tool:Clone().Parent = Player.Backpack 
                end)
            end
        end
    end
end

function InventoryViewer.Toggle(State)
    InventoryViewer.Enabled = State
    
    if State then
        Connections.Heartbeat = RunService.Heartbeat:Connect(function()
            if not InventoryViewer.Enabled then return end
            local LocalCharacter = Player.Character
            if not (LocalCharacter and LocalCharacter.PrimaryPart) then return end
            local LocalPosition = LocalCharacter.PrimaryPart.Position
            
            for _, PlayerObj in pairs(Players:GetPlayers()) do
                if PlayerObj == Player then continue end
                
                local State = InventoryViewer.PlayerStates[PlayerObj] or CreatePlayerElements(PlayerObj)
                local Character = PlayerObj.Character

                if Character and Character.PrimaryPart and Character:FindFirstChild("Head") then
                    local Distance = (LocalPosition - Character.PrimaryPart.Position).Magnitude
                    
                    if Distance <= CONFIG.Distance and State.CurrentState == "hidden" then
                        State.CurrentState = "visible"
                        State.Gui.Adornee = Character.Head
                        State.Gui.Parent = Character.Head
                        AnimateElement(State, "in")
                    elseif Distance > CONFIG.Distance and State.CurrentState == "visible" then
                        State.CurrentState = "hidden"
                        local Tween = AnimateElement(State, "out")
                        Tween.Completed:Wait()
                        if State.CurrentState == "hidden" then 
                            State.Gui.Parent = nil 
                        end
                    end

                    if State.CurrentState == "visible" then 
                        UpdateUI(PlayerObj, Character) 
                    end
                elseif State.CurrentState == "visible" then
                    State.CurrentState = "hidden"
                    State.Gui.Parent = nil
                end
            end
        end)

        Connections.InputChanged = UserInputService.InputChanged:Connect(function(Input)
            if not InventoryViewer.Enabled or not InventoryViewer.ActiveScroller then return end
            if Input.UserInputType == Enum.UserInputType.Gamepad1 and Input.KeyCode == Enum.KeyCode.Gamepad1_Thumbstick2 then
                local Scroller = InventoryViewer.ActiveScroller
                Scroller.CanvasPosition = Scroller.CanvasPosition - Vector2.new(0, Input.Position.Y * CONFIG.ScrollSpeed)
            end
        end)

        Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(PlayerObj)
            if InventoryViewer.PlayerStates[PlayerObj] then
                InventoryViewer.PlayerStates[PlayerObj].Gui:Destroy()
                InventoryViewer.PlayerStates[PlayerObj] = nil
            end
        end)
    else
        for _, Connection in pairs(Connections) do
            if Connection then
                Connection:Disconnect()
            end
        end
        Connections = {}
        
        for PlayerObj, State in pairs(InventoryViewer.PlayerStates) do
            if State.Gui then
                State.Gui:Destroy()
            end
        end
        InventoryViewer.PlayerStates = {}
        InventoryViewer.ActiveScroller = nil
    end
end

return InventoryViewer
