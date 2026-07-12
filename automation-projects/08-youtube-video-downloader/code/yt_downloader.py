from pytube import Playlist, YouTube

URL = input("Enter a YouTube video or playlist URL: ").strip()

if "playlist" in URL:
    for video in Playlist(URL).video_urls:
        yt = YouTube(video)
        stream = yt.streams.get_highest_resolution()
        stream.download(output_path="./videos")
        print(f"Downloaded {yt.title}")
else:
    yt = YouTube(URL)
    stream = yt.streams.get_highest_resolution()
    stream.download(output_path="./videos")
    print(f"Downloaded {yt.title}")
