import os
from urllib.parse import urlencode
from urllib.request import urlopen, Request


def send_telegram_message(bot_token: str, chat_id: str, text: str):
    """
    Send a text message to a Telegram chat using urlopen.
    """
    base_url = f"https://api.telegram.org/bot{bot_token}/sendMessage"
    data = urlencode({
        "chat_id": chat_id,
        "text": text
    }).encode("utf-8")

    req = Request(base_url, data=data)
    with urlopen(req) as response:
        return response.read().decode("utf-8")


if __name__ == "__main__":
    bot_token = os.getenv("TELEGRAM_BOT_TOKEN")
    chat_id = os.getenv("TELEGRAM_ID")
    n8n_latest_release = os.getenv("RELEASE")
    message = f"n8n release tag {n8n_latest_release} built successfully"
    send_telegram_message(bot_token, chat_id, message)