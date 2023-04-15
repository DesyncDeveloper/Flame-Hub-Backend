local Aspect_Hub_Misc_Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/DesyncDeveloper/Aspect-Hub/main/Aspect-Hub-Misc.lua'))()

function PetHatched(data)
    local PetModule = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.PetModule)
    if PetModule[data[1]].Rarity ~= "Legendary" then
        return
    end

    local chance = data[4] or "N/A"

    local name = ""
    if data[2] == true then
        name = "SHINY "..data[1]
    else
        name = data[1]
    end

    if data[2] == true and chance ~= "N/A" then
        chance = chance / 100
    end

    chance = tostring(chance).."%"

    local ImageService = game:GetService("ReplicatedStorage").Assets.Modules.ImageService
    local PetModule = require( game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.PetModule)
    local PetImages = debug.getupvalues(require(ImageService))[1]

    local PetNameForImage = string.gsub(name, "SHINY%s*", "")
    local petImageAsset = PetImages[PetNameForImage]
    local petImageId = string.gsub(petImageAsset, "rbxassetid://", "")
    local PetImage = Aspect_Hub_Misc_Functions:GrabImageUrl(petImageId)

    local OSTime = os.time()
    local Time = os.date('!*t', OSTime)

    local Player = game.Players.LocalPlayer
    local msg = {
        ["username"] = "Flame Hub",
        ["embeds"] = {{
            ["color"] = tonumber(_G.WebhookColor),
            ["title"] = "||"..Player.DisplayName.."|| Hatched A "..name,
            ["description"] = "** 🥚 Eggs Hatched:** "..tostring(Aspect_Hub_Misc_Functions:formatNumber(Player.leaderstats["Eggs Opened"].Value)).."\n** :four_leaf_clover: Chance: **"..tostring(chance),
            ["thumbnail"] = {
                ["url"] = PetImage
            },
            ["author"] = {},
            ["footer"] = {
                ["text"] = "Flame Hub"
              },
            ['timestamp'] = string.format('%d-%d-%dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
        }}
    }

    if _G.PingUser == true then
        msg["content"] = "<@".._G.PingUserID..">"
    end

    request = http_request or request or HttpPost or syn.request
    local PetNotificationW = _G.Webhook
    request({
        Url = tostring(PetNotificationW),
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game.HttpService:JSONEncode(msg)
    })
end

local EggScript = require(game:GetService("ReplicatedStorage").Assets.Modules.EggService) 
local Eggs = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.EggModule)

local function GetChance(name)
    local mythic = false
    if string.find(name, "Mythic") then
        name = string.sub(name, 8, #name)
        mythic = true
    end
    for i,v in pairs(Eggs) do 
        for x,y in pairs(v.Rarities) do
            if y[1] == name and mythic then
                return y[2] / 200
            elseif y[1] == name then
                return y[2]
            end
        end
    end
end

local hookF
hookF = hookfunction(EggScript.HatchEgg, function(...)
    local data = {...}
    local Egg = data[2]
    local PetName = data[3]
    local ShinyPet = data[7]

    if _G.WebhookEnabled == true then
        PetHatched({PetName, ShinyPet, Egg, GetChance(PetName)})
    end

    return hookF(...)
end)
