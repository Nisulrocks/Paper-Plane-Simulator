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

-- farm tab
local Tab = Window:CreateTab(" Auto Farm ")

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
}  -- Fixed table definition
-- Add more zones as needed when implemented

local TrainingToggle = Tab:CreateToggle({
   Name = "Auto Training",
   CurrentValue = false,
   Flag = "AutoTraining",
   Callback = function(Value)
       TrainingEnabled = Value
       if TrainingEnabled then
           -- Check if selected equipment requires VIP
           if ZoneEquipment and ZoneEquipment[SelectedZone] and 
              ZoneEquipment[SelectedZone][SelectedEquipment] and 
              ZoneEquipment[SelectedZone][SelectedEquipment].RequiresVIP then
               Rayfield:Notify({
                   Title = "VIP Required",
                   Content = "This equipment requires VIP. Make sure you have VIP before using it.",
                   Duration = 5,
               })
           end
           
           local equipmentName = "Unknown Equipment"
           if ZoneEquipment and ZoneEquipment[SelectedZone] and 
              ZoneEquipment[SelectedZone][SelectedEquipment] and 
              ZoneEquipment[SelectedZone][SelectedEquipment].Name then
               equipmentName = ZoneEquipment[SelectedZone][SelectedEquipment].Name
           end
           
           Rayfield:Notify({
               Title = "Auto Training",
               Content = "Auto Training has been enabled for " .. tostring(SelectedZone) .. " using " .. equipmentName,
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
if type(ZoneEquipment[SelectedZone]) == "table" then
    for i, equipment in ipairs(ZoneEquipment[SelectedZone]) do
        equipmentOptions[i] = equipment.Name
    end
else
    equipmentOptions = {"Equipment 1"}  -- Default fallback
end

local EquipmentDropdown = Tab:CreateDropdown({
   Name = "Select Equipment",
   Options = equipmentOptions,
   CurrentOption = equipmentOptions[1],
   Flag = "TrainingEquipment",
   Callback = function(Option)
       -- Find the equipment ID based on the selected name
       if ZoneEquipment[SelectedZone] then
           for i, equipment in ipairs(ZoneEquipment[SelectedZone]) do
               if equipment and equipment.Name == Option then
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
       else
           Rayfield:Notify({
               Title = "Error",
               Content = "Selected zone does not exist. Please select a valid zone.",
               Duration = 5,
           })
       end
   end,
})

-- Training loop function
local function StartTraining()
   spawn(function()
       while TrainingEnabled do
           -- Add safety checks
           if not ZoneEquipment or not ZoneEquipment[SelectedZone] or not ZoneEquipment[SelectedZone][SelectedEquipment] then
               Rayfield:Notify({
                   Title = "Training Error",
                   Content = "Invalid zone or equipment selected. Please check your selections.",
                   Duration = 5,
               })
               -- Pause briefly before checking again
               wait(2)
           else
               -- Fire the remote event to gain strength
               local args = {
                   "Train",
                   {
                       SelectedEquipment,
                       SelectedZone
                   }
               }
               
               local success, error = pcall(function()
                   game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RewardAction"):FireServer(unpack(args))
               end)
               
               if not success then
                   Rayfield:Notify({
                       Title = "Remote Error",
                       Content = "Error firing remote event. Training paused.",
                       Duration = 5,
                   })
                   -- Pause briefly before trying again
                   wait(5)
               else
                   -- Wait before firing again (adjust this value as needed)
                   wait(1)
               end
           end
       end
   end)
end

-- Wins Farm section 

local Section = Tab:CreateSection("Wins Farm")

-- Eggs Farm section 

local Section = Tab:CreateSection("Eggs Farm")