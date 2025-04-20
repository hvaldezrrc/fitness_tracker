import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Map controller connected")

    if (!document.getElementById("map")) return;

    const map = L.map('map').setView([49.8951, -97.1384], 12);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; OpenStreetMap contributors'
    }).addTo(map);

    // Example dummy marker
    L.marker([49.8951, -97.1384]).addTo(map)
      .bindPopup("Hello from Winnipeg!");
  }
}
