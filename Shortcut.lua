local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local UILib = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui

function UILib:CreateButton(props)
    local Button = Instance.new("TextButton")
    Button.Size = props.Size or UDim2.new(0, 100, 0, 100)
    Button.Position = props.Position or UDim2.new(0.5, 0, 0.5, 0)
    Button.AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5)
    Button.Text = props.Text or "Button"
    Button.BackgroundColor3 = Color3.fromRGB(26, 26, 36)
    Button.Visible = props.Visible or true
    Button.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = Button

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(42, 42, 58)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = Button

    function Button:SetStrokeColor(color)
        UIStroke.Color = color
    end

    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Button.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    Button.TouchTap:Connect(function()
        if props.OnClick then
            props.OnClick()
        end
    end)

    return Button
end

return UILib
