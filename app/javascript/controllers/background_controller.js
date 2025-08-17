import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { imageUrl: String }

  connect() {
    this.timer = setInterval(() => {
      this.fetchNextImage();
    }, 1000 * 60 * 8);
    this.fetchNextImage();
  }

  diconnect() {
    clearInterval(this.timer);
  }

  fetchNextImage() {
    fetch("/player/background.json", {
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        if (data) {
          this.imageUrlValue = data.image_url;
        } else {
          console.error("No background data received");
        }
      })
      .catch(error => console.error("Error fetching next background:", error));
  }

  imageUrlValueChanged() {
    const image = new Image();
    image.onload = () => {
      document.body.style.backgroundImage = `url('${this.imageUrlValue}')`;
    };
    image.src = this.imageUrlValue;
  }
}
