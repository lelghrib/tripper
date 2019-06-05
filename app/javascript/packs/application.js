import "bootstrap";
import "slick-carousel";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";

import "../plugins/slider-criteria";

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';

initMapbox();

import {scrollFunction} from '../components/topbutton';
import {topFunction} from '../components/topbutton';
// scrollFunction();
// topFunction();

