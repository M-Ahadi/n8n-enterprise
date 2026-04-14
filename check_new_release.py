import json
from urllib.request import urlopen


def read_tags_file():
    with open("tags.txt", "r", encoding="UTF8") as f:
        tags = f.readlines()
    tags = [tag.strip() for tag in tags]
    print("loaded tags:", tags)
    return tags


def get_n8n_release_version():
    with urlopen("https://api.github.com/repos/n8n-io/n8n/releases/latest") as url:
        data = json.loads(url.read().decode())
        latest = data['target_commitish']
        latest = latest.split("/")[1]
    print("latest tag", latest)
    return latest



if __name__ == "__main__":
    n8n_latest_release = get_n8n_release_version()
    docker_tags = read_tags_file()
    if n8n_latest_release not in docker_tags:
        print(n8n_latest_release)
