import json
import zipfile

import requests

from version import Version

cookies = {
    '_ga': 'GA1.2.1849503966.1518103294',
    '_gid': 'GA1.2.953840595.1518103294',
}

headers = {
    'Host': 'www.blackmagicdesign.com',
    'Accept': 'application/json, text/plain, */*',
    'Origin': 'https://www.blackmagicdesign.com',
    'User-Agent': "Mozilla/5.0 (X11; Linux) \
        AppleWebKit/537.36 (KHTML, like Gecko) \
        Chrome/77.0.3865.75 \
        Safari/537.36",
    'Content-Type': 'application/json;charset=UTF-8',
    'Accept-Encoding': 'gzip, deflate, br',
    'Accept-Language': 'en-US,en;q=0.9',
    'Authority': 'www.blackmagicdesign.com',
    'Cookie': '_ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294',
}


def get_latest_version_information(app_tag: str, refer_id: str = '77ef91f67a9e411bbbe299e595b4cfcc', stable=True):
    response: requests.Response = requests.get(
        f"https://www.blackmagicdesign.com/api/support/latest-stable-version/{app_tag}/linux"
        if stable else
        f"https://www.blackmagicdesign.com/api/support/latest-version/{app_tag}/linux",
        cookies=cookies,
        headers={
            **headers,
            'Referer': 'https://www.blackmagicdesign.com/support/download/' + refer_id + '/Linux',
        },
    )

    parsed_response = json.loads(response.content.decode('utf-8'))

    return (Version(
        major=parsed_response["linux"]["major"],
        minor=parsed_response["linux"]["minor"],
        patch=parsed_response["linux"]["releaseNum"],
        build=parsed_response["linux"]["build"],
        beta=parsed_response["linux"]["beta"] if "beta" in parsed_response["linux"] else -1
    ), parsed_response["linux"]["releaseId"], parsed_response["linux"]["downloadId"])


def download_using_id(download_id: str, refer_id: str = "77ef91f67a9e411bbbe299e595b4cfcc"):
    download_url_data = {
        "firstname": "Flatpak",
        "lastname": "Builder",
        "email": "someone@flathub.org",
        "phone": "202-555-0194",
        "country": "us",
        "state": "New York",
        "city": "FPK",
        "product": "DaVinci Resolve"
    }

    download_url_response = requests.post(
        'https://www.blackmagicdesign.com/api/register/us/download/' + download_id,
        cookies=cookies,
        headers={
            **headers,
            "Referer": "https://www.blackmagicdesign.com/support/download/" + refer_id + "/Linux",
        },
        data=json.dumps(download_url_data),
    )

    download_url = download_url_response.content.decode('utf-8')

    download_response = requests.get(download_url, stream=True)
    total_size_in_bytes = int(download_response.headers.get('Content-Length', 0))
    progress = 0
    with open("./resolve.zip", "wb") as f:
        for chunk in download_response.iter_content(chunk_size=32 * 1024):
            f.write(chunk)
            progress += len(chunk)
            print(" " + str(round(progress / total_size_in_bytes * 100, 4)) + "%")

    print("Extracting resolve installation...")
    with zipfile.ZipFile("./resolve.zip", 'r') as zip_file:
        zip_file.extractall('.')
