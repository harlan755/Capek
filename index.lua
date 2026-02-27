local HttpService = game:GetService("HttpService")

local req = syn and syn.request or http_request or request

req({
    Url = "https://discord.com/api/webhooks/1476004191058264168/ZwalmFfACOQntKSceu4nqnu7lR7JH-BKRVVp1C4sXvU6yLbx6AKp2g-XzI5ELRsxklfz",
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode({
        content = "TEST DELTA MOBILE ✅"
    })
})
