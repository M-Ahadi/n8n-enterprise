import json
import os
from urllib.parse import urlencode
from urllib.request import urlopen, Request


def get_n8n_release_version():
    with urlopen("https://api.github.com/repos/n8n-io/n8n/releases/latest") as url:
        data = json.loads(url.read().decode())
        latest = data['tag_name']
        latest = latest.split("@")[1]

    return latest


def get_docker_latest_version(namespace="mojtabaahadi", image="n8n", page_size=100):
    base_url = f"https://hub.docker.com/v2/repositories/{namespace}/{image}/tags"
    params = {"page_size": page_size}
    url = base_url + "?" + urlencode(params)

    tags = []

    while url:
        with urlopen(url) as response:
            data = json.load(response)

        tags.extend([tag["name"] for tag in data.get("results", [])])
        url = data.get("next")
    return tags


if __name__ == "__main__":
    docker_tags = get_docker_latest_version()
    n8n_latest_release = get_n8n_release_version()
    if n8n_latest_release not in docker_tags:
        print(n8n_latest_release)


