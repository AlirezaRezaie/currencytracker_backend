# livedollar project

## برنامه ترمینال نمایش نرخ روزانه دلار تهران به صورت زنده

### به راحتی میتوانید به آخرین نرخ دلار دسترسی داشته باشید

<br/>

کانال هایی که تا کنون پشتیبانی میشوند:

- https://t.me/s/dollar_tehran3bze
- https://t.me/s/nerkhedollarr
- https://t.me/s/dolaretehran20

## TODO List

- [ ] create base flutter app
- [ ] enhance server code and fix the initial connection send price bug
- [ ] create gui ui and server connection

## آموزش استفاده از سرور

```
❯ cd server
❯ python3 server.py
```

### (با استفاده از wscat) بخش تاریخچه قیمت بر اساس تعداد

```
❯ curl localhost:8000/counter/?count=5
"[
    ('دلار فردایی تهران⏳  49,750 معامله شد✅', '16:35', '324'),
    ('دلار فردایی تهران⏳  49,750 معامله شد✅', '16:34', '323'),
    ('دلار نـــقـدی تهران 💵 49,850 فروش🔴', '16:32', '322'),
    ('دلار نـــقـدی تهران 💵 49,850 فروش🔴', '16:32', '321'),
    ('دلار نـــقـدی تهران 💵 49,850 فروش🔴', '16:31', '320')
]"
```

### بخش پخش زنده قیمت تهران

```
❯ wscat -c ws://localhost:8000/live
Connected (press CTRL+C to quit)
< دلار فردایی تهران ⏳ 48,550 فروش🔴19:08328
< دلار فردایی تهران ⏳ 48,600 فروش🔴19:15329
>
```

## آموزش استفاده از رابط گرافیکی

```shell
❯ python3 server.py # ابتدا سرور را ران میکنیم
INFO: Started server process [76127]
INFO: Waiting for application startup.
INFO: Application startup complete.
INFO: Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)

❯ cd frontend && python3 gui.py

```

## آموزش استفاده از اپ ترمینال

```c

❯ python3 main.py
usage: livedollar [-h] [-v] [-live] [-count COUNT] [--channel-id ID] [--retry TIMES] [--use-api]
[--save-results]

The livedollar is a simple and convenient tool that provides users with the live exchange rate of the US
dollar in Iranian Rials (IRR) right from their terminal. It allows users to quickly check the current
conversion rate and stay up-to-date with the latest changes in the exchange market.

options:
-h, --help show this help message and exit
-v, --verbose Enable verbose mode
-live Run in live mode
-count COUNT Run counter with the specified number
--channel-id ID which dollar Telegram channel to use [optional]
--retry TIMES times to retry the connection before exiting program (for slow networks default:5 )
[optional]
--use-api Uses Telegram's official API as the fetch method instead of web scrape [optional]
--save-results Saves results in json format [optional]

happy checking the currency :)

```
