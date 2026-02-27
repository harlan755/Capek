--// WEBHOOK DELTA EXECUTOR - CRAFT A WORLD [BETA]
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- GANTI DENGAN WEBHOOK KAMU
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

-- Ambil Data Player
local playerName = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local accountAge = player.AccountAge
local jobId = game.JobId
local placeId = game.PlaceId

-- Ping (perkiraan)
local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())

-- Status Player
local playerStatus = "Online"

-- Waktu Eksekusi
local executeTime = os.date("%d/%m/%Y %H:%M:%S")

-- Format Pesan Sesuai Permintaan (tanpa pack & block)
local content = string.format([[
- <a:stat:1449444004801286268> `Status : Executing Script`
- <:Bot:1283696244165836812> `Player Name : %s`
- <a:checkm:1181101683082797076> `Display Name : %s`
- <:stable_ping:1408556059496546384> `Player Ping : %sms`
- <:gems:1465657925770154086> `Account Age : %s Days`
- <:treegt:1174568853091659827> `User ID : %s`
- <:black_mystery_block:1304140534255718442> `Job ID : %s`
- <:packcrate:1156971687062032394> `Place ID : %s`
- <:Bot:1283696244165836812> `Execute Time : %s`
]], 
playerName,
displayName,
ping,
accountAge,
userId,
jobId,
placeId,
executeTime
)

-- Kirim ke Webhook
local data = {
    ["content"] = content
}

local headers = {
    ["Content-Type"] = "application/json"
}

local request = http_request or request or HttpPost or syn.request
if request then
    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = headers,
        Body = HttpService:JSONEncode(data)
    })
end
