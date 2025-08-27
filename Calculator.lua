Calculator = {}

CloneRef = cloneref or function(instance)
    return instance
end

CoreGui = CloneRef(game:GetService("CoreGui"))
UserInputService = CloneRef(game:GetService("UserInputService"))
RunService = CloneRef(game:GetService("RunService"))

function randomString()
    local Length = math.random(10,20)
    local Array = {}
    for i = 1, Length do
        Array[i] = string.char(math.random(32, 126))
    end
    return table.concat(Array)
end

CalculatorUI = nil

function Calculator.Toggle(State)
    if State and not CalculatorUI then
        Calculator.Create()
    elseif not State and CalculatorUI then
        CalculatorUI:Destroy()
        CalculatorUI = nil
    elseif State and CalculatorUI then
        CalculatorUI.Enabled = true
    elseif not State and CalculatorUI then
        CalculatorUI.Enabled = false
    end
end

function Calculator.Create()
    CalculatorUI = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local ButtonsFrame = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local UIGridLayout = Instance.new("UIGridLayout")
    local _1 = Instance.new("TextButton")
    local UICorner_3 = Instance.new("UICorner")
    local UIPadding = Instance.new("UIPadding")
    local _2 = Instance.new("TextButton")
    local UICorner_4 = Instance.new("UICorner")
    local _3 = Instance.new("TextButton")
    local UICorner_5 = Instance.new("UICorner")
    local TextButton = Instance.new("TextButton")
    local UICorner_6 = Instance.new("UICorner")
    local _4 = Instance.new("TextButton")
    local UICorner_7 = Instance.new("UICorner")
    local _5 = Instance.new("TextButton")
    local UICorner_8 = Instance.new("UICorner")
    local _6 = Instance.new("TextButton")
    local UICorner_9 = Instance.new("UICorner")
    local TextButton_2 = Instance.new("TextButton")
    local UICorner_10 = Instance.new("UICorner")
    local _7 = Instance.new("TextButton")
    local UICorner_11 = Instance.new("UICorner")
    local _8 = Instance.new("TextButton")
    local UICorner_12 = Instance.new("UICorner")
    local _9 = Instance.new("TextButton")
    local UICorner_13 = Instance.new("UICorner")
    local TextButton_3 = Instance.new("TextButton")
    local UICorner_14 = Instance.new("UICorner")
    local _0 = Instance.new("TextButton")
    local UICorner_15 = Instance.new("UICorner")
    local TextButton_4 = Instance.new("TextButton")
    local UICorner_16 = Instance.new("UICorner")
    local TextButton_5 = Instance.new("TextButton")
    local UICorner_17 = Instance.new("UICorner")
    local TextButton_6 = Instance.new("TextButton")
    local UICorner_18 = Instance.new("UICorner")
    local C = Instance.new("TextButton")
    local UICorner_19 = Instance.new("UICorner")
    local TextButton_7 = Instance.new("TextButton")
    local UICorner_20 = Instance.new("UICorner")
    local TextButton_8 = Instance.new("TextButton")
    local UICorner_21 = Instance.new("UICorner")
    local TextButton_9 = Instance.new("TextButton")
    local UICorner_22 = Instance.new("UICorner")
    local UIPadding_2 = Instance.new("UIPadding")
    local NumFrame = Instance.new("Frame")
    local UIPadding_3 = Instance.new("UIPadding")
    local UICorner_23 = Instance.new("UICorner")
    local Text = Instance.new("TextLabel")

    CalculatorUI.Name = randomString()
    CalculatorUI.Parent = CoreGui
    CalculatorUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainFrame.Name = randomString()
    MainFrame.Parent = CalculatorUI
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.49999994, 0)
    MainFrame.Size = UDim2.new(0, 250, 0, 400)

    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 10)

    ButtonsFrame.Name = randomString()
    ButtonsFrame.Parent = MainFrame
    ButtonsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ButtonsFrame.Position = UDim2.new(0, 0, 0.248210549, 0)
    ButtonsFrame.Size = UDim2.new(0, 230, 0, 285)

    UICorner_2.Parent = ButtonsFrame
    UICorner_2.CornerRadius = UDim.new(0, 6)

    UIGridLayout.Parent = ButtonsFrame
    UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIGridLayout.CellSize = UDim2.new(0, 50, 0, 50)

    _1.Name = "1"
    _1.Parent = ButtonsFrame
    _1.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _1.LayoutOrder = 1
    _1.Size = UDim2.new(0, 200, 0, 50)
    _1.AutoButtonColor = false
    _1.Font = Enum.Font.GothamBold
    _1.Text = "1"
    _1.TextColor3 = Color3.fromRGB(255, 255, 255)
    _1.TextScaled = true
    _1.TextSize = 14.000
    _1.TextWrapped = true

    UICorner_3.Parent = _1
    UICorner_3.CornerRadius = UDim.new(0, 6)

    UIPadding.Parent = ButtonsFrame
    UIPadding.PaddingBottom = UDim.new(0, 5)
    UIPadding.PaddingLeft = UDim.new(0, 7)
    UIPadding.PaddingRight = UDim.new(0, 7)
    UIPadding.PaddingTop = UDim.new(0, 5)

    _2.Name = "2"
    _2.Parent = ButtonsFrame
    _2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _2.LayoutOrder = 2
    _2.Size = UDim2.new(0, 200, 0, 50)
    _2.AutoButtonColor = false
    _2.Font = Enum.Font.GothamBold
    _2.Text = "2"
    _2.TextColor3 = Color3.fromRGB(255, 255, 255)
    _2.TextScaled = true
    _2.TextSize = 14.000
    _2.TextWrapped = true

    UICorner_4.Parent = _2
    UICorner_4.CornerRadius = UDim.new(0, 6)

    _3.Name = "3"
    _3.Parent = ButtonsFrame
    _3.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _3.LayoutOrder = 3
    _3.Size = UDim2.new(0, 200, 0, 50)
    _3.AutoButtonColor = false
    _3.Font = Enum.Font.GothamBold
    _3.Text = "3"
    _3.TextColor3 = Color3.fromRGB(255, 255, 255)
    _3.TextScaled = true
    _3.TextSize = 14.000
    _3.TextWrapped = true

    UICorner_5.Parent = _3
    UICorner_5.CornerRadius = UDim.new(0, 6)

    TextButton.Name = "+"
    TextButton.Parent = ButtonsFrame
    TextButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TextButton.LayoutOrder = 4
    TextButton.Size = UDim2.new(0, 200, 0, 50)
    TextButton.AutoButtonColor = false
    TextButton.Font = Enum.Font.GothamBold
    TextButton.Text = "+"
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.TextScaled = true
    TextButton.TextSize = 14.000
    TextButton.TextWrapped = true

    UICorner_6.Parent = TextButton
    UICorner_6.CornerRadius = UDim.new(0, 6)

    _4.Name = "4"
    _4.Parent = ButtonsFrame
    _4.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _4.LayoutOrder = 5
    _4.Size = UDim2.new(0, 200, 0, 50)
    _4.AutoButtonColor = false
    _4.Font = Enum.Font.GothamBold
    _4.Text = "4"
    _4.TextColor3 = Color3.fromRGB(255, 255, 255)
    _4.TextScaled = true
    _4.TextSize = 14.000
    _4.TextWrapped = true

    UICorner_7.Parent = _4
    UICorner_7.CornerRadius = UDim.new(0, 6)

    _5.Name = "5"
    _5.Parent = ButtonsFrame
    _5.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _5.LayoutOrder = 6
    _5.Size = UDim2.new(0, 200, 0, 50)
    _5.AutoButtonColor = false
    _5.Font = Enum.Font.GothamBold
    _5.Text = "5"
    _5.TextColor3 = Color3.fromRGB(255, 255, 255)
    _5.TextScaled = true
    _5.TextSize = 14.000
    _5.TextWrapped = true

    UICorner_8.Parent = _5
    UICorner_8.CornerRadius = UDim.new(0, 6)

    _6.Name = "6"
    _6.Parent = ButtonsFrame
    _6.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _6.LayoutOrder = 7
    _6.Size = UDim2.new(0, 200, 0, 50)
    _6.AutoButtonColor = false
    _6.Font = Enum.Font.GothamBold
    _6.Text = "6"
    _6.TextColor3 = Color3.fromRGB(255, 255, 255)
    _6.TextScaled = true
    _6.TextSize = 14.000
    _6.TextWrapped = true

    UICorner_9.Parent = _6
    UICorner_9.CornerRadius = UDim.new(0, 6)

    TextButton_2.Name = "-"
    TextButton_2.Parent = ButtonsFrame
    TextButton_2.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TextButton_2.LayoutOrder = 8
    TextButton_2.Size = UDim2.new(0, 200, 0, 50)
    TextButton_2.AutoButtonColor = false
    TextButton_2.Font = Enum.Font.GothamBold
    TextButton_2.Text = "-"
    TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_2.TextScaled = true
    TextButton_2.TextSize = 14.000
    TextButton_2.TextWrapped = true

    UICorner_10.Parent = TextButton_2
    UICorner_10.CornerRadius = UDim.new(0, 6)

    _7.Name = "7"
    _7.Parent = ButtonsFrame
    _7.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _7.LayoutOrder = 9
    _7.Size = UDim2.new(0, 200, 0, 50)
    _7.AutoButtonColor = false
    _7.Font = Enum.Font.GothamBold
    _7.Text = "7"
    _7.TextColor3 = Color3.fromRGB(255, 255, 255)
    _7.TextScaled = true
    _7.TextSize = 14.000
    _7.TextWrapped = true

    UICorner_11.Parent = _7
    UICorner_11.CornerRadius = UDim.new(0, 6)

    _8.Name = "8"
    _8.Parent = ButtonsFrame
    _8.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _8.LayoutOrder = 10
    _8.Size = UDim2.new(0, 200, 0, 50)
    _8.AutoButtonColor = false
    _8.Font = Enum.Font.GothamBold
    _8.Text = "8"
    _8.TextColor3 = Color3.fromRGB(255, 255, 255)
    _8.TextScaled = true
    _8.TextSize = 14.000
    _8.TextWrapped = true

    UICorner_12.Parent = _8
    UICorner_12.CornerRadius = UDim.new(0, 6)

    _9.Name = "9"
    _9.Parent = ButtonsFrame
    _9.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _9.LayoutOrder = 11
    _9.Size = UDim2.new(0, 200, 0, 50)
    _9.AutoButtonColor = false
    _9.Font = Enum.Font.GothamBold
    _9.Text = "9"
    _9.TextColor3 = Color3.fromRGB(255, 255, 255)
    _9.TextScaled = true
    _9.TextSize = 14.000
    _9.TextWrapped = true

    UICorner_13.Parent = _9
    UICorner_13.CornerRadius = UDim.new(0, 6)

    TextButton_3.Name = "/"
    TextButton_3.Parent = ButtonsFrame
    TextButton_3.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TextButton_3.LayoutOrder = 12
    TextButton_3.Size = UDim2.new(0, 200, 0, 50)
    TextButton_3.AutoButtonColor = false
    TextButton_3.Font = Enum.Font.GothamBold
    TextButton_3.Text = "/"
    TextButton_3.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_3.TextScaled = true
    TextButton_3.TextSize = 14.000
    TextButton_3.TextWrapped = true

    UICorner_14.Parent = TextButton_3
    UICorner_14.CornerRadius = UDim.new(0, 6)

    _0.Name = "0"
    _0.Parent = ButtonsFrame
    _0.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    _0.LayoutOrder = 14
    _0.Size = UDim2.new(0, 200, 0, 50)
    _0.AutoButtonColor = false
    _0.Font = Enum.Font.GothamBold
    _0.Text = "0"
    _0.TextColor3 = Color3.fromRGB(255, 255, 255)
    _0.TextScaled = true
    _0.TextSize = 14.000
    _0.TextWrapped = true

    UICorner_15.Parent = _0
    UICorner_15.CornerRadius = UDim.new(0, 6)

    TextButton_4.Name = "."
    TextButton_4.Parent = ButtonsFrame
    TextButton_4.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextButton_4.LayoutOrder = 13
    TextButton_4.Size = UDim2.new(0, 200, 0, 50)
    TextButton_4.AutoButtonColor = false
    TextButton_4.Font = Enum.Font.GothamBold
    TextButton_4.Text = "."
    TextButton_4.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_4.TextScaled = true
    TextButton_4.TextSize = 14.000
    TextButton_4.TextWrapped = true

    UICorner_16.Parent = TextButton_4
    UICorner_16.CornerRadius = UDim.new(0, 6)

    TextButton_5.Name = "^"
    TextButton_5.Parent = ButtonsFrame
    TextButton_5.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TextButton_5.LayoutOrder = 15
    TextButton_5.Size = UDim2.new(0, 200, 0, 50)
    TextButton_5.AutoButtonColor = false
    TextButton_5.Font = Enum.Font.GothamBold
    TextButton_5.Text = "^"
    TextButton_5.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_5.TextScaled = true
    TextButton_5.TextSize = 14.000
    TextButton_5.TextWrapped = true

    UICorner_17.Parent = TextButton_5
    UICorner_17.CornerRadius = UDim.new(0, 6)

    TextButton_6.Name = "*"
    TextButton_6.Parent = ButtonsFrame
    TextButton_6.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TextButton_6.LayoutOrder = 16
    TextButton_6.Size = UDim2.new(0, 200, 0, 50)
    TextButton_6.AutoButtonColor = false
    TextButton_6.Font = Enum.Font.GothamBold
    TextButton_6.Text = "*"
    TextButton_6.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_6.TextScaled = true
    TextButton_6.TextSize = 14.000
    TextButton_6.TextWrapped = true

    UICorner_18.Parent = TextButton_6
    UICorner_18.CornerRadius = UDim.new(0, 6)

    C.Name = "C"
    C.Parent = ButtonsFrame
    C.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    C.LayoutOrder = 17
    C.Size = UDim2.new(0, 200, 0, 50)
    C.AutoButtonColor = false
    C.Font = Enum.Font.GothamBold
    C.Text = "C"
    C.TextColor3 = Color3.fromRGB(255, 255, 255)
    C.TextScaled = true
    C.TextSize = 14.000
    C.TextWrapped = true

    UICorner_19.Parent = C
    UICorner_19.CornerRadius = UDim.new(0, 6)

    TextButton_7.Name = "("
    TextButton_7.Parent = ButtonsFrame
    TextButton_7.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextButton_7.LayoutOrder = 18
    TextButton_7.Size = UDim2.new(0, 200, 0, 50)
    TextButton_7.AutoButtonColor = false
    TextButton_7.Font = Enum.Font.GothamBold
    TextButton_7.Text = "("
    TextButton_7.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_7.TextScaled = true
    TextButton_7.TextSize = 14.000
    TextButton_7.TextWrapped = true

    UICorner_20.Parent = TextButton_7
    UICorner_20.CornerRadius = UDim.new(0, 6)

    TextButton_8.Name = ")"
    TextButton_8.Parent = ButtonsFrame
    TextButton_8.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextButton_8.LayoutOrder = 18
    TextButton_8.Size = UDim2.new(0, 200, 0, 50)
    TextButton_8.AutoButtonColor = false
    TextButton_8.Font = Enum.Font.GothamBold
    TextButton_8.Text = ")"
    TextButton_8.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_8.TextScaled = true
    TextButton_8.TextSize = 14.000
    TextButton_8.TextWrapped = true

    UICorner_21.Parent = TextButton_8
    UICorner_21.CornerRadius = UDim.new(0, 6)

    TextButton_9.Name = "="
    TextButton_9.Parent = ButtonsFrame
    TextButton_9.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    TextButton_9.LayoutOrder = 19
    TextButton_9.Size = UDim2.new(0, 200, 0, 50)
    TextButton_9.AutoButtonColor = false
    TextButton_9.Font = Enum.Font.GothamBold
    TextButton_9.Text = "="
    TextButton_9.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton_9.TextScaled = true
    TextButton_9.TextSize = 14.000
    TextButton_9.TextWrapped = true

    UICorner_22.Parent = TextButton_9
    UICorner_22.CornerRadius = UDim.new(0, 6)

    UIPadding_2.Parent = MainFrame
    UIPadding_2.PaddingBottom = UDim.new(0, 10)
    UIPadding_2.PaddingLeft = UDim.new(0, 10)
    UIPadding_2.PaddingRight = UDim.new(0, 10)
    UIPadding_2.PaddingTop = UDim.new(0, 10)

    NumFrame.Name = randomString()
    NumFrame.Parent = MainFrame
    NumFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    NumFrame.Size = UDim2.new(0, 230, 0, 85)

    UIPadding_3.Parent = NumFrame
    UIPadding_3.PaddingBottom = UDim.new(0, 5)
    UIPadding_3.PaddingLeft = UDim.new(0, 7)
    UIPadding_3.PaddingRight = UDim.new(0, 7)
    UIPadding_3.PaddingTop = UDim.new(0, 5)

    UICorner_23.Parent = NumFrame
    UICorner_23.CornerRadius = UDim.new(0, 6)

    Text.Name = randomString()
    Text.Parent = NumFrame
    Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Text.BackgroundTransparency = 1.000
    Text.Size = UDim2.new(0, 215, 0, 80)
    Text.Font = Enum.Font.Gotham
    Text.Text = "0"
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextScaled = true
    Text.TextSize = 50.000
    Text.TextWrapped = true
    Text.TextXAlignment = Enum.TextXAlignment.Right

    local numLabel = MainFrame[NumFrame.Name][Text.Name]

    for _, v in pairs(MainFrame[ButtonsFrame.Name]:GetChildren()) do
        if v:IsA("TextButton") then
            if v.Name == "=" then
                v.MouseButton1Click:Connect(function()
                    local ran, val = pcall(loadstring("local res = (".. numLabel.Text .."); return res"))
                    if ran then
                        numLabel.Text = val
                    else
                        numLabel.Text = "Error"
                    end
                end)
            elseif v.Name == "C" then
                v.MouseButton1Click:Connect(function()
                    numLabel.Text = "0"
                end)
            else
                v.MouseButton1Click:Connect(function()
                    if numLabel.Text == "0" or numLabel.Text == "Error" then
                        numLabel.Text = ""
                    end
                    
                    numLabel.Text = numLabel.Text.. v.Name
                end)
            end
        end
    end

    local gui = MainFrame

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

return Calculator
