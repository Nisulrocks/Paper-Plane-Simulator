-- boot da libary 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
-- variables 
local RunService = game:GetService("RunService")
local autoFarmConnection  -- Separate variable for Auto Farm
local winsConnection      -- Separate variable for Wins Farm
local eggConnection       -- Separate variable for Eggs Farm
local selectedEgg = nil

-- Main 

local Window = Rayfield:CreateWindow({
   Name = "Plane Simulator",
   Icon = 0, 
   LoadingTitle = "Plane Simulator",
   LoadingSubtitle = "by NisulRocks",
   Theme = "Default", 

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, 

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "Plane Simulator", 
      FileName = "Plane Simulator"
   },

   Discord = {
      Enabled = false, 
      Invite = "noinvitelink", 
      RememberJoins = true 
   },

   KeySystem = false, 
   KeySettings = {
      Title = "Plane Simulator",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", 
      FileName = "Key", 
      SaveKey = true, 
      GrabKeyFromSite = false, 
      Key = {"Hello"} 
   }
})

-- farm tab
local Tab = Window:CreateTab(" Auto Farm ")

-- Training farm section 

local Section = Tab:CreateSection("Training Farm")

-- create a variable to store the Zone
local Zone = "Zone1"
local Trainer = 1

local Dropdown = Tab:CreateDropdown({
    Name = "Select Zone",
    Options = {"Zone1","Zone2","Zone3"},
    CurrentOption = {"Zone1"},
    MultipleOptions = false,
    Flag = "Dropdown1", 
    Callback = function(Options)
    -- The function that takes place when the selected option is changed
    -- The variable (Options) is a table of strings for the current selected options
    Zone = Options[1]
    end,
 })

 local Dropdown = Tab:CreateDropdown({
    Name = "Select Trainer",
    Options = {"1","2","3","4"},
    CurrentOption = {"1"},
    MultipleOptions = false,
    Flag = "Dropdown2", 
    Callback = function(Options)
    -- The function that takes place when the selected option is changed
    -- The variable (Options) is a table of strings for the current selected options
    Trainer = tonumber(Options[1])
    end,
 })
 
 local Toggle = Tab:CreateToggle({
     Name = "Auto Farm",
     CurrentValue = false,
     Flag = "Toggle1",
     Callback = function(Value)
         if Value then
             autoFarmConnection = RunService.Heartbeat:Connect(function()
                 local args = {
                     "Train",
                     {
                         Trainer,
                         Zone
                     }
                 }
                 game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RewardAction"):FireServer(unpack(args))
             end)
         else
             if autoFarmConnection then
                 autoFarmConnection:Disconnect()
                 autoFarmConnection = nil
             end
         end
     end,
 })
 
 -- Wins Farm section
 local Section = Tab:CreateSection("Wins Farm")
 
 local Toggle = Tab:CreateToggle({
     Name = "Auto Wins Farm",
     CurrentValue = false,
     Flag = "Toggle2",
     Callback = function(Value)
         if Value then
             winsConnection = RunService.Heartbeat:Connect(function()
                 local args = {
                     "Win",
                     {
                         Zone,
                         {
                             "Green",
                             "Orange",
                             "LightBlue"
                         }
                     }
                 }
                 game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RewardAction"):FireServer(unpack(args))
             end)
         else
             if winsConnection then
                 winsConnection:Disconnect()
                 winsConnection = nil
             end
         end
     end,
 })


-- Eggs Farm section 

-- Function to get all egg names
local function getAllEggNames()
    local eggNames = {}
    local zones = workspace:FindFirstChild("Zones")
    
    if zones then
        for _, zone in pairs(zones:GetChildren()) do
            if zone:IsA("Model") then
                local eggsFolder = zone:FindFirstChild("Eggs")
                if eggsFolder then
                    for _, egg in pairs(eggsFolder:GetChildren()) do
                        table.insert(eggNames, egg.Name)
                    end
                end
            end
        end
    end
    
    return eggNames
end

-- Eggs Farm section
local Section = Tab:CreateSection("Eggs Farm")

-- Get all available egg names
local availableEggs = getAllEggNames()

-- Create dropdown for egg selection
local Dropdown = Tab:CreateDropdown({
    Name = "Select Egg to Farm",
    Options = availableEggs,
    CurrentOption = availableEggs[1] or "None",
    Flag = "EggDropdown",
    Callback = function(Option)
        -- Debug what we're getting from the dropdown
        print("Dropdown returned:", Option)
        print("Type:", type(Option))
        
        -- Make sure we get the string value
        if type(Option) == "table" then
            selectedEgg = Option.Name or Option.name or Option[1] or tostring(Option)
            print("Extracted from table:", selectedEgg)
        else
            selectedEgg = tostring(Option) -- Convert to string just in case
        end
        
        print("Final selectedEgg:", selectedEgg, "Type:", type(selectedEgg))
    end,
})

-- Set initial selected egg
if availableEggs[1] then
    selectedEgg = tostring(availableEggs[1]) -- Make sure it's a string
end

-- Auto Egg Farm Toggle
local Toggle = Tab:CreateToggle({
    Name = "Auto Egg Farm",
    CurrentValue = false,
    Flag = "EggFarmToggle",
    Callback = function(Value)
        if Value then
            if selectedEgg then
                eggConnection = RunService.Heartbeat:Connect(function()
                    -- Debug the exact values
                    print("selectedEgg variable:", selectedEgg)
                    print("selectedEgg type:", type(selectedEgg))
                    print("selectedEgg length:", string.len(selectedEgg))
                    print("selectedEgg bytes:", string.byte(selectedEgg, 1, -1))
                    
                    local args = {
                        selectedEgg,
                        1
                    }
                    
                    -- Print exactly what we're sending
                    print("Sending args:", args[1], args[2])
                    
                    local success, result = pcall(function()
                        return game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("GetRandomPet"):InvokeServer(unpack(args))
                    end)
                    
                    if not success then
                        print("Error occurred:", result)
                    end
                end)
                print("Started farming:", selectedEgg)
            else
                print("No egg selected!")
            end
        else
            if eggConnection then
                eggConnection:Disconnect()
                eggConnection = nil
                print("Stopped egg farming")
            end
        end
    end,
})

-- Refresh button to update egg list
local Button = Tab:CreateButton({
    Name = "Refresh Egg List",
    Callback = function()
        availableEggs = getAllEggNames()
        print("Available eggs:", table.concat(availableEggs, ", "))
    end,
})
