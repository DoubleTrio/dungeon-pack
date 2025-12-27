import os
import subprocess
from dataclasses import dataclass
from typing import Optional
from mutagen.oggvorbis import OggVorbis

@dataclass
class OggTrack:
    url: str
    title: str
    artist: str
    album: str
    loop_start: Optional[int] = None
    loop_length: Optional[int] = None
    spoiler: Optional[str] = None
    relative: Optional[str] = None


def write_tags(file_path, track: OggTrack):
    audio = OggVorbis(file_path)
    audio["TITLE"] = track.title
    audio["ARTIST"] = track.artist
    audio["ALBUM"] = track.album

    # Optional loop-related tags
    if track.loop_start is not None:
        audio["LOOPSTART"] = str(track.loop_start)
    if track.loop_length is not None:
        audio["LOOPLENGTH"] = str(track.loop_length)

    # Optional flags or custom tags
    if track.spoiler:
        audio["SPOILER"] = track.spoiler
    if track.relative:
        audio["RELATIVE"] = track.relative

    audio.save()


def download_youtube_audio(track: OggTrack, output_dir="./output"):
    try:
        cmd_download = [
            "yt-dlp",
            "-f", "bestaudio",
            "-o", os.path.join(output_dir, "%(title)s.%(ext)s"),
            track.url
        ]
        subprocess.run(cmd_download, check=True)

        files = [f for f in os.listdir(output_dir) if f.endswith((".m4a", ".webm"))]
        latest_file = max(
            [os.path.join(output_dir, f) for f in files],
            key=os.path.getctime,
        )

        # base, _ = os.path.splitext(latest_file)
        output_file = os.path.join(output_dir, f"{track.title}.ogg")

        cmd_convert = [
            "ffmpeg", "-y",
            "-i", latest_file,
            "-codec:a", "libvorbis",
            "-qscale:a", "5",
            output_file
        ]
        subprocess.run(cmd_convert, stdout=subprocess.DEVNULL, stderr=subprocess.STDOUT)
        os.remove(latest_file)

        write_tags(output_file, track)
        print(f"Saved: {output_file}")
    except Exception as e:
        print(f"Error processing {track.url}: {e}")


def batch_download(tracks, output_dir="./output"):
    os.makedirs(output_dir, exist_ok=True)
    for track in tracks:
        download_youtube_audio(track, output_dir)


if __name__ == "__main__":
    TRACKS = [
        OggTrack(
            url="https://www.youtube.com/watch?v=nnO_FFiZJCc",
            title="Rock Slide Canyon",
            artist="Danirbu",
            album="Original Soundtrack",
            loop_start=5469672,
            loop_length=5476165,
        ),
        OggTrack(
            url="https://www.youtube.com/watch?v=3ZUDRLMY4_8",
            title="Dusty Trails",
            artist="Danirbu",
            album="Original Soundtrack",
            loop_start=5197794,
            loop_length=5200320,
        ),
        OggTrack(
            url="https://www.youtube.com/watch?v=_PVzJOcYZKk",
            title="Ruins of Life",
            artist="Danirbu",
            album="Original Soundtrack",
            loop_start=5469672,
            loop_length=5476165,
        ),
    ]

    batch_download(TRACKS)
