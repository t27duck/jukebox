import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "container", "canvas"]

  connect() {
    this.setupVisualization()
  }

  disconnect() {
    if (this.audioContext) {
      this.audioContext.close()
    }
  }

  setupVisualization() {
    this.audioContext = new window.AudioContext;
    this.analyser = this.audioContext.createAnalyser();
    this.source = this.audioContext.createMediaElementSource(this.audioTarget);
    this.source.connect(this.analyser);
    this.analyser.connect(this.audioContext.destination);

    // Set up visualization
    this.analyser.fftSize = 128; // Adjust for desired detail
    this.bufferLength = this.analyser.frequencyBinCount;
    this.dataArray = new Uint8Array(this.bufferLength);

    this.drawVisualization();
  }

  drawVisualization() {
    requestAnimationFrame(this.drawVisualization.bind(this));

    this.analyser.getByteFrequencyData(this.dataArray);
    const ctx = this.canvasTarget.getContext("2d");
    const { height, width } = this.containerTarget.getBoundingClientRect();
    this.canvasTarget.height = height;
    this.canvasTarget.width = width;
    ctx.clearRect(0, 0, width, height);

    const barCount = this.bufferLength;
    const barWidth = width / (barCount - 1);

    let barHeight;
    let x = 0;
    const colors = this.generateRainbowColors(barCount);
    for (let i = 0; i < this.bufferLength; i++) {
      barHeight = this.dataArray[i];
      ctx.fillStyle = `rgb(${colors[i][0]}, ${colors[i][1]}, ${colors[i][2]})`;
      ctx.fillRect(x, height - barHeight / 2, barWidth, barHeight / 2);
      x += barWidth + 1;
    }
  }

  generateRainbowColors(numColors) {
    const colors = [];
    const startHue = 220; // Starting hue
    const hueRange = 400; // Range of hues to cover the rainbow

    for (let i = 0; i < numColors; i++) {
      const hue = startHue + (hueRange * i / (numColors - 1));
      let saturation = 80; // Adjust as needed
      let lightness = 50;  // Adjust as needed

      saturation /= 100;
      lightness /= 100;
      const k = (n) => (n + hue / 30) % 12;
      const a = saturation * Math.min(lightness, 1 - lightness);
      const f = (n) => lightness - a * Math.max(-1, Math.min(k(n) - 3, Math.min(9 - k(n), 1)));
      colors.push([255 * f(0), 255 * f(8), 255 * f(4)]);
    }
    return colors;
  }
}
