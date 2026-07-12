import os

import requests
from git import Repo

USER = "octocat"
DESTINATION = "./github_repos"
os.makedirs(DESTINATION, exist_ok=True)

response = requests.get(f"https://api.github.com/users/{USER}/repos?per_page=100", timeout=10)
response.raise_for_status()

for repo in response.json():
    clone_url = repo["clone_url"]
    repo_name = repo["name"]
    target_path = os.path.join(DESTINATION, repo_name)
    if not os.path.exists(target_path):
        Repo.clone_from(clone_url, target_path)
        print(f"Cloned {repo_name}")
    else:
        print(f"Skipped {repo_name} (already exists)")
