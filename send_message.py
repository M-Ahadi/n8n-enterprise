import os
from urllib.error import HTTPError
from urllib.parse import urlencode
from urllib.request import urlopen, Request


def send_telegram_message(bot_token: str, chat_id: str, text: str, parse_mode: str = "Markdown"):
    """
    Send a text message to a Telegram chat using urlopen with Markdown parsing.
    """
    base_url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
    payload = {
        "chat_id": chat_id,
        "text": text,
        "parse_mode": parse_mode
    }

    data = urlencode(payload).encode("utf-8")
    req = Request(base_url, data=data)

    try:
        with urlopen(req) as response:
            return response.read().decode("utf-8")
    except HTTPError as e:
        error_body = e.read().decode("utf-8", errors="replace")
        print(f"Telegram API Error ({e.code}): {error_body}")


if __name__ == "__main__":
    bot_token = os.getenv("TELEGRAM_BOT_TOKEN")
    chat_id = os.getenv("TELEGRAM_ID")
    n8n_latest_release = os.getenv("RELEASE")

    if not bot_token or not chat_id:
        raise ValueError("TELEGRAM_BOT_TOKEN and TELEGRAM_ID must be set.")

    message = f"""
*n8n release tag `{n8n_latest_release}` pushed to the repo.*

New images can be pulled from:
`ghcr.io/m-ahadi/n8n-enterprise:{n8n_latest_release}`
`ghcr.io/m-ahadi/runners:{n8n_latest_release}`

[Github Repo](https://github.com/M-Ahadi/n8n-enterprise)
""".strip()

    send_telegram_message(bot_token, chat_id, message, parse_mode="Markdown")
