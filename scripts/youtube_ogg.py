import os
import subprocess




from dataclasses import dataclass
from typing import Optional

@dataclass
class OggTrack:
    url: str
    title: str
    artist: str
    album: str
    loop_start: Optional[int] = None
    loop_length: Optional[int] = None
    spoiler: Optional[bool] = False
    relative: Optional[bool] = False

    
"""""""""""""""""""""""""""""""""""""""""""""""
PLACE AUDIO YOUTUBE URLS IN THE LIST BELOW
"""""""""""""""""""""""""""""""""""""""""""""""
URLS = [
    # "https://www.youtube.com/watch?v=HWULEsWk91I",
    # "https://www.youtube.com/watch?v=YOS3RJINpF4",
    # "https://www.youtube.com/watch?v=zLn4qt26x2g",
    # "https://www.youtube.com/watch?v=YOS3RJINpF4",
    # "https://www.youtube.com/watch?v=TAd6DO0bYR8",
    # "https://www.youtube.com/watch?v=zm_fRp-O6PU",
    ""
]

def download_youtube_audio(url, output_dir="./output"):
    try:
        cmd_download = [
            "yt-dlp",
            "-f", "bestaudio",
            "-o", os.path.join(output_dir, "%(title)s.%(ext)s"),
            url
        ]
        subprocess.run(cmd_download, check=True)

        files = [f for f in os.listdir(output_dir) if f.endswith((".m4a", ".webm"))]
        latest_file = max(
            [os.path.join(output_dir, f) for f in files],
            key=os.path.getctime,
        )

        base, _ = os.path.splitext(latest_file)
        output_file = base + ".ogg"

        cmd_convert = [
            "ffmpeg", "-y",
            "-i", latest_file,
            "-codec:a", "libvorbis",
            "-qscale:a", "5",
            output_file
        ]
        subprocess.run(cmd_convert, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
        os.remove(latest_file)

        print(f"Saved: {output_file}")
    except Exception as e:
        print(f"Error processing {url}: {e}")


def batch_download(urls, output_dir="./output"):
    os.makedirs(output_dir, exist_ok=True)
    for url in urls:
        if url.strip():
            download_youtube_audio(url.strip(), output_dir)


if __name__ == "__main__":
    batch_download(URLS)