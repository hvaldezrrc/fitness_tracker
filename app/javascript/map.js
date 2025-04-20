import L from "leaflet"

function initMap() {
  const mapEl = document.getElementById("map")
  if (!mapEl || mapEl._leaflet_id) return

  const map = L.map(mapEl).setView([49.8951, -97.1384], 12)
  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "&copy; OpenStreetMap contributors"
  }).addTo(map)

  document.querySelectorAll("tr[data-lat][data-lng]").forEach(row => {
    const lat = parseFloat(row.dataset.lat),
          lng = parseFloat(row.dataset.lng),
          name = row.dataset.name,
          url  = row.dataset.url

    L.marker([lat, lng])
     .addTo(map)
     .bindPopup(`<strong>${name}</strong><br><a href="${url}">View details</a>`)
  })
}

document.addEventListener("turbo:load", initMap)
