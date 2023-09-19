import threading


local = threading.local()
local.default_channels = {
    "USD": [
        {
            "channel_name": "nerkhedollarr",
            "regex": r"(فردایی|نقدی|نـــقـدی|نـــقـدۍ|پایان معاملات).*?(\d{1,3}(?:,\d{3})*).(\w*)",
            "nonstop": True,
        },
        {
            "channel_name": "dollar_tehran3bze",
            "regex": r"(فردایی|نقدی|نـــقـدی|نـــقـدۍ|پایان معاملات).*?(\d{1,3}(?:,\d{3})*).(\w*)",
            "nonstop": True,
        },
        {"channel_name": "sarafha_rate", "regex": "", "nonstop": True},
    ],
    "EUR": [
        {"channel_name": "sarafha_rate", "regex": "", "nonstop": True},
    ],
    # "JPY": "",
    # "GDP": "",
    "DHS": [{"channel_name": "DHS_Dirham", "regex": "", "nonstop": True}],
}
