// app/javascript/plugins/init_mapbox.js
import mapboxgl from 'mapbox-gl';
// import polyline from '@mapbox/polyline';


function calculateRoute(map, from, to) {
  const mapElement = document.getElementById('map');

  var lngFrom = from[0]
  var latFrom = from[1]

  var lngTo = to[0]
  var latTo = to[1]

  // $.get('https://api.mapbox.com/directions/v5/mapbox/driving/' + lngFrom + ',' + latFrom + ';' + lngTo + ',' + latTo + '?access_token=' + mapElement.dataset.mapboxApiKey,
  //   function( data ) {
  //   var coords = polyline.decode(data.routes[0].geometry);
  //   var line = L.polyline(coords).addTo(map);
  // });
};


const mapElement = document.getElementById('map');

const buildMap = () => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v10'
  })
};

const addMarkersToMap = (map, markers) => {
  console.log('toto');
  console.log(markers);
  markers.forEach((marker) => {
    const popup = new mapboxgl.Popup().setHTML(marker.infoWindow);
    new mapboxgl.Marker()
      .setLngLat([ marker.lng, marker.lat ])
      .setPopup(popup)
      .addTo(map);
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 5 });
};

const initMapbox = () => {
  if (mapElement) {
    const map = buildMap();
    const markers = JSON.parse(mapElement.dataset.markers);
    addMarkersToMap(map, markers);
    fitMapToMarkers(map, markers);

    // console.log(markers);
    let coordinates = [];
    markers.forEach ((marker) => {
      let coordinate = [];
      console.log(marker.lat);
      coordinate.push(marker.lng);
      coordinate.push(marker.lat);
      coordinates.push(coordinate);
    });
    // console.log(coordinates);
    // {lat: 41.900796, lng: 12.4834874},
    // {lat: 41.9112542, lng: 12.4785194843013}
    // =>
    // [
    //   [12.4834874,41.900796], [12.4785194843013,41.9112542]
    // ]
    map.on('load', function () {

      map.addLayer({
        "id": "route",
        "type": "line",
        "source": {
          "type": "geojson",
          "data": {
            "type": "Feature",
            "properties": {},
            "geometry": {
              "type": "LineString",
              "coordinates": coordinates
            }
          }
        },
        "layout": {
          "line-join": "round",
          "line-cap": "round"
        },
        "paint": {
          "line-color": "#888",
          "line-width": 8
        }
      });
    });

    //calculateRoute(map, [48.8587741,2.2069771], [43.2803051,5.2404128])
  }
};
export { initMapbox };
