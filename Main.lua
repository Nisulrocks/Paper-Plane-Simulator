-- boot da libary 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

-- Training farm section 

local Section = Tab:CreateSection("Training Farm")

local TrainingEnabled = false
local SelectedZone = "Zone1" -- Default zone, changed from "Zone 1" to match remote format
local SelectedEquipment = 1 -- Default equipment

-- Equipment data
local ZoneEquipment = {
    ["Zone1"] = {
        {ID = 1, Name = "Equipment 1"},
        {ID = 2, Name = "Equipment 2"},
        {ID = 3, Name = "Equipment 3"},
        {ID = 4, Name = "VIP Equipment", RequiresVIP = true}
    }
    -- Add more zones as needed when implemented
}

local TrainingToggle = Tab:CreateToggle({
    Name = "Auto Training",
    CurrentValue = false,
    Flag = "AutoTraining",
    Callback = function(Value)
        TrainingEnabled = Value
        if TrainingEnabled then
            -- Check if selected equipment requires VIP
            if ZoneEquipment[SelectedZone][SelectedEquipment].RequiresVIP then
                Rayfield:Notify({
                    Title = "VIP Required",
                    Content = "This equipment requires VIP. Make sure you have VIP before using it.",
                    Duration = 5,
                })
            end
            
            Rayfield:Notify({
                Title = "Auto Training",
                Content = "Auto Training has been enabled for " .. SelectedZone .. " using " .. ZoneEquipment[SelectedZone][SelectedEquipment].Name,
                Duration = 3,
            })
            StartTraining()
        else
            Rayfield:Notify({
                Title = "Auto Training",
                Content = "Auto Training has been disabled",
                Duration = 3,
            })
            -- Training will stop on next loop iteration
        end
    end,
})

local ZoneDropdown = Tab:CreateDropdown({
    Name = "Select Zone",
    Options = {"Zone1"}, -- For now, only Zone1 is implemented
    CurrentOption = SelectedZone,
    Flag = "TrainingZone",
    Callback = function(Option)
        SelectedZone = Option
        Rayfield:Notify({
            Title = "Zone Selected",
            Content = "Selected training zone: " .. Option,
            Duration = 3,
        })
    end,
})

-- Create equipment options for the dropdown
local equipmentOptions = {}
for i, equipment in ipairs(ZoneEquipment[SelectedZone]) do
    equipmentOptions[i] = equipment.Name
end

local EquipmentDropdown = Tab:CreateDropdown({
    Name = "Select Equipment",
    Options = equipmentOptions,
    CurrentOption = equipmentOptions[1],
    Flag = "TrainingEquipment",
    Callback = function(Option)
        -- Find the equipment ID based on the selected name
        for i, equipment in ipairs(ZoneEquipment[SelectedZone]) do
            if equipment.Name == Option then
                SelectedEquipment = i
                
                -- Check if equipment requires VIP
                if equipment.RequiresVIP then
                    Rayfield:Notify({
                        Title = "VIP Required",
                        Content = "This equipment requires VIP. Make sure you have VIP before using it.",
                        Duration = 5,
                    })
                end
                
                break
            end
        end
        
        Rayfield:Notify({
            Title = "Equipment Selected",
            Content = "Selected equipment: " .. Option,
            Duration = 3,
        })
    end,
})

-- Training loop function
local function StartTraining()
    spawn(function()
        while TrainingEnabled do
            -- Fire the remote event to gain strength
            local args = {
                "Train",
                {
                    SelectedEquipment,
                    SelectedZone
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RewardAction"):FireServer(unpack(args))
            
            -- Wait before firing again (adjust this value as needed)
            wait(1)
        end
    end)
end

-- Wins Farm section 

local Section = Tab:CreateSection("Wins Farm")

-- Eggs Farm section 

local Section = Tab:CreateSection("Eggs Farm")