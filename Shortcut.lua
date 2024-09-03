local DraggableButtonLib = {}

function DraggableButtonLib:CreateButton()
    local ScreenGui = Instance.new("ScreenGui")
    local Button = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")

    ScreenGui.Parent = game.CoreGui

    Button.Size = UDim2.new(0, 30, 0, 30)
    Button.Position = UDim2.new(0.5, -15, 0.5, -15)
    Button.AnchorPoint = Vector2.new(0.5, 0.5)
    Button.Text = "Click"
    Button.Visible = true
    Button.Parent = ScreenGui

    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Button

    UIStroke.Thickness = 3
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Parent = Button

    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Button.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    local buttonMetatable = {
        __index = function(_, key)
            if key == "StrokeColor" then
                return UIStroke.Color
            else
                return Button[key]
            end
        end,

        __newindex = function(_, key, value)
            if key == "Visible" then
                Button.Visible = value
            elseif key == "Size" then
                Button.Size = value
            elseif key == "Position" then
                Button.Position = value
            elseif key == "Text" then
                Button.Text = value
            elseif key == "StrokeColor" then
                UIStroke.Color = Color3.fromRGB(value[1], value[2], value[3])
            else
                rawset(Button, key, value)
            end
        end,
    }

    return setmetatable({}, buttonMetatable)
end

return DraggableButtonLib
