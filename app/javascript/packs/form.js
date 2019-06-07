/*const checkboxclic = () => {
document.querySelectorAll(".activity-choice").forEach((element) =>{
  element.addEventListener("click", (event) => {
    event.currentTarget.classList.toggle("active");
  });
});
}*/

const checkboxclickculture = () => {
  $(document).ready(function(){
    $(".acti-cuture").click(function(){
      if ($(this).hasClass('active')) {
        $(this).removeClass("active");
      } else {
        if($('.acti-cuture.active').length < 2) {
         $(this).addClass("active");
        }
      }

    });
  });
}
const checkboxclicksport = () => {
  $(document).ready(function(){
    $(".acti-sport").click(function(){
      if ($(this).hasClass('active')) {
        $(this).removeClass("active");
      } else {
        if($('.acti-sport.active').length < 2) {
         $(this).addClass("active");
        }
      }

    });
  });
}
const checkboxclickvisit = () => {
  $(document).ready(function(){
    $(".acti-visit").click(function(){
      if ($(this).hasClass('active')) {
        $(this).removeClass("active");
      } else {
        if($('.acti-visit.active').length < 2) {
         $(this).addClass("active");
        }
      }

    });
  });
}
const checkboxclickbeach = () => {
  $(document).ready(function(){
    $(".acti-beach").click(function(){
      if ($(this).hasClass('active')) {
        $(this).removeClass("active");
      } else {
        if($('.acti-beach.active').length < 2) {
         $(this).addClass("active");
        }
      }

    });
  });
}

const checktwoculture = () => {
$('.check-culture').on('change', function() {
   if($('.check-culture:checked').length > 2) {
       this.checked = false;
   }
});
}
const checktwosport = () => {
$('.check-sport').on('change', function() {
   if($('.check-sport:checked').length > 2) {
       this.checked = false;
   }
});
}
const checktwovisit = () => {
$('.check-visit').on('change', function() {
   if($('.check-visit:checked').length > 2) {
       this.checked = false;
   }
});
}
const checktwobeach = () => {
$('.check-beach').on('change', function() {
   if($('.check-beach:checked').length > 2) {
       this.checked = false;
   }
});
}


export { checkboxclickculture, checkboxclickbeach, checkboxclickvisit, checkboxclicksport, checktwoculture, checktwosport, checktwovisit, checktwobeach };

