import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "title", "artist", "album", "currentTime", "duration", "coverImage"]
  static values = { songUrl: String, title: String, artist: String, album: String, coverImage: String }

  connect() {
    this.audioTarget.addEventListener('timeupdate', () => {
      this.outputAudioTime();
    });

    this.audioTarget.addEventListener('ended', () => {
      this.fetchNextSong();
    });

    this.fetchNextSong();
  }

  fetchNextSong() {
    fetch("/player/next.json", {
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        if (data) {
          this.songUrlValue = data.file;
          this.titleValue = data.title;
          this.artistValue = data.artist;
          this.albumValue = data.album;
          this.coverImageValue = data.cover_image;
        } else {
          console.error("No song data received");
        }
      })
      .catch(error => console.error("Error fetching next song:", error));
  }

  outputAudioTime() {
    const currentTime = this.audioTarget.currentTime;
    const duration = this.audioTarget.duration;

    if (!isNaN(currentTime)) { // Check if currentTime is a valid number
      const minutes = Math.floor(currentTime / 60);
      const seconds = String(Math.floor(currentTime % 60)).padStart(2, '0');
      this.currentTimeTarget.textContent = `${minutes}:${seconds}`;
    } else {
      this.currentTimeTarget.textContent = "0:00";
    }

    if (!isNaN(duration)) { // Check if duration is a valid number
      const totalMinutes = Math.floor(duration / 60);
      const totalSeconds = String(Math.floor(duration % 60)).padStart(2, '0');
      this.durationTarget.textContent = `${totalMinutes}:${totalSeconds}`;
    } else {
      this.durationTarget.textContent = "0:00";
    }
  }

  songUrlValueChanged() {
    if (this.songUrlValue) {
      this.audioTarget.src = this.songUrlValue
      this.audioTarget.play()
    } else {
      this.audioTarget.pause()
      this.audioTarget.src = ""
    }
  }

  titleValueChanged() {
    this.titleTarget.textContent = this.titleValue || "Unknown Title";
  }

  artistValueChanged() {
    this.artistTarget.textContent = this.artistValue || "Unknown Artist";
  }

  albumValueChanged() {
    this.albumTarget.textContent = this.albumValue || "Unknown Album";
  }

  coverImageValueChanged() {
    const image = new Image();
    image.src = this.coverImageValue || "/default_cover_image.png";
    image.onload = () => {
      this.coverImageTarget.style.backgroundImage = `url('${this.coverImageValue || "/default_cover_image.png"}')`;
    };
  }
}
