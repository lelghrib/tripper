import "bootstrap";
import "slick-carousel";
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css";

$(function(){
  $('.slider').slick({
  autoplay:true,
  autoplaySpeed:1500,
  arrows:true,
  prevArrow:'<button type="button" class="slick-prev"></button>',
  nextArrow:'<button type="button" class="slick-next"></button>',
  centerMode:true,
  slidesToShow:3,
  slidesToScroll:1
  });
});

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!

import { initMapbox } from '../plugins/init_mapbox';

initMapbox();

import {scrollFunction} from '../components/topbutton';
import {topFunction} from '../components/topbutton';
// scrollFunction();
// topFunction();

