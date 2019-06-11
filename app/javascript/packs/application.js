import "bootstrap";
import "slick-carousel";
// import "slick-carousel/slick/slick.css";
// import "slick-carousel/slick/slick-theme.css";
import "../plugins/slider-criteria";
import "../plugins/slider";


// import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';

initMapbox();

import {scrollFunction} from '../components/topbutton';
import {topFunction} from '../components/topbutton';
// scrollFunction();
// topFunction();

// add active class on choosen activities
import { checkboxclickculture, checkboxclickbeach, checkboxclickvisit, checkboxclicksport, checktwoculture, checktwosport, checktwovisit, checktwobeach } from './form';
checkboxclickculture();
checkboxclickbeach();
checkboxclickvisit();
checkboxclicksport();
checktwoculture();
checktwosport();
checktwovisit();
checktwobeach();

import { checkboxclickmistery, checkonemistery } from './mistery';
checkboxclickmistery();
checkonemistery();

import '../plugins/flatpickr';


