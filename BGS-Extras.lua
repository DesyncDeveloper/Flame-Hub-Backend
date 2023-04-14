local Aspect_Hub_Misc_Functions = loadstring(game:HttpGet('https://raw.githubusercontent.com/DesyncDeveloper/Aspect-Hub/main/Aspect-Hub-Misc.lua'))()

function PetHatched(data)
    local PetModule = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.PetModule)
    if PetModule[data[1]].Rarity ~= "Legendary" then
        return
    end

    local name = ""
    if data[2] == true then
        name = "SHINY "..data[1]
    else
        name = data[1]
    end

    local ImageService = game:GetService("ReplicatedStorage").Assets.Modules.ImageService
    local PetModule = require( game:GetService("ReplicatedStorage").Assets.Modules.ItemDataService.PetModule)
    local PetImages = debug.getupvalues(require(ImageService))[1]

    local PetNameForImage = string.gsub(name, "SHINY%s*", "")
    local petImageAsset = PetImages[PetNameForImage]
    local petImageId = string.gsub(petImageAsset, "rbxassetid://", "")
    local PetImage = Aspect_Hub_Misc_Functions:GrabImageUrl(petImageId)

    local Player = game.Players.LocalPlayer
    local msg = {
        ["username"] = "Flame Hub",
        ["embeds"] = {{
            ["color"] = tonumber(_G.WebhookColor),
            ["title"] = "||"..Player.DisplayName.."|| Hatched A "..name,
            ["description"] = "** 🥚 Eggs Hatched:** "..tostring(Player.leaderstats["Eggs Opened"].Value).."\n** :four_leaf_clover: Chance: N/A**",
            ["thumbnail"] = {
                ["url"] = PetImage
            },
            ["author"] = {},
            ["footer"] = {
                ["text"] = "Flame Hub"
              },
            ['timestamp'] = os.date("%Y-%m-%dT%X.000Z") 
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

local hookF
hookF = hookfunction(EggScript.HatchEgg, function(...)
    local data = {...}
    local Egg = data[2]
    local PetName = data[3]
    local ShinyPet = data[7]


    print(_G.WebhookEnabled)
    if _G.WebhookEnabled == true then
        PetHatched({PetName, ShinyPet, Egg})
    end

    return hookF(...)
end)
