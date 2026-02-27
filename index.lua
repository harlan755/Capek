--// WEBHOOK RESMI - CRAFT A WORLD [BETA]
--// LOCAL SCRIPT (StarterPlayerScripts atau StarterGui)

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StatsService = game:GetService("Stats")

local player = Players.LocalPlayer
if not player then
	Players.PlayerAdded:Wait()
	player = Players.LocalPlayer
end

-- ==============================
-- GANTI DENGAN WEBHOOK KAMU
-- ==============================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz"

-- ==============================
-- CEGAH DOUBLE RUN
-- ==============================
if player:FindFirstChild("WebhookScriptLoaded") then
	return
end

local flag = Instance.new("BoolValue")
flag.Name = "WebhookScriptLoaded"
flag.Parent = player

-- ==============================
-- AMBIL DATA GEMS
-- ==============================
local function getPlayerGems()
	local gemsValue = nil

	-- Cek leaderstats
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		gemsValue = leaderstats:FindFirstChild("Gems") 
			or leaderstats:FindFirstChild("Gem")
	end

	-- Cek folder data lain
	if not gemsValue then
		local dataFolder = player:FindFirstChild("PlayerData") 
			or player:FindFirstChild("Data")
		if dataFolder then
			gemsValue = dataFolder:FindFirstChild("Gems") 
				or dataFolder:FindFirstChild("Gem")
		end
	end

	if gemsValue and (gemsValue:IsA("IntValue") or gemsValue:IsA("NumberValue")) then
		return gemsValue.Value
	end

	return "Data tidak ditemukan"
end

-- ==============================
-- AMBIL SEMUA DATA PLAYER
-- ==============================
local function getPlayerData()
	local data = {}

	data.playerName = player.Name
	data.displayName = player.DisplayName
	data.userId = player.UserId
	data.placeId = game.PlaceId
	data.jobId = game.JobId ~= "" and game.JobId or "Tidak ada Job ID"

	-- ==============================
	-- AMBIL PING (AMAN)
	-- ==============================
	local pingValue = nil
	pcall(function()
		pingValue = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)

	data.ping = pingValue and math.floor(pingValue) or "Tidak dapat diukur"

	-- Status pemain (tidak pakai player.Online)
	data.playerStatus = "Aktif di dalam game"

	data.gems = getPlayerGems()

	-- WIB (UTC+7)
	data.executeTime = os.date("%d/%m/%Y %H:%M:%S", os.time() + 25200)

	return data
end

-- ==============================
-- KIRIM KE WEBHOOK
-- ==============================
local function sendToWebhook()

	if WEBHOOK_URL == "" or WEBHOOK_URL == "ISI_WEBHOOK_KAMU_DISINI" then
		warn("Webhook URL belum diisi!")
		return
	end

	local playerData = getPlayerData()

	local content = string.format([[
📊 **Data Pemain Diperbarui**
👤 Player Name : %s
🪪 Display Name : %s
📶 Ping : %sms
💎 Gems : %s
🆔 User ID : %s
🌐 Status : %s
🕒 Waktu (WIB) : %s
🌍 Place ID : %s
🧭 Job ID : %s
]],
		playerData.playerName,
		playerData.displayName,
		playerData.ping,
		playerData.gems,
		playerData.userId,
		playerData.playerStatus,
		playerData.executeTime,
		playerData.placeId,
		playerData.jobId
	)

	local payload = {
		content = content,
		username = "Craft a World [Beta] - Data System"
	}

	local success, err = pcall(function()
		HttpService:PostAsync(
			WEBHOOK_URL,
			HttpService:JSONEncode(payload),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		print("Webhook berhasil dikirim:", playerData.executeTime)
	else
		warn("Gagal kirim webhook:", err)
	end
end

-- ==============================
-- EKSEKUSI AWAL
-- ==============================
sendToWebhook()

-- ==============================
-- LOOP UPDATE TIAP 20 DETIK
-- ==============================
while true do
	task.wait(20)
	sendToWebhook()
end
