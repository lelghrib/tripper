const checkboxclic = () => {
document.querySelectorAll(".activity-choice").forEach((element) =>{
  element.addEventListener("click", (event) => {
    event.currentTarget.classList.toggle("active");
  });
});
}

const checkboxclick = () => {
  $(document).ready(function(){
    $(".activity-choice").click(function(){
      if ($(this).hasClass('active')) {
        $(this).removeClass("active");
      } else {
        if($('.activity-choice.active').length < 2) {
         $(this).addClass("active");
        }
      }

    });
  });
}

const checktwo = () => {
$('.check-culture').on('change', function() {
   if($('.check-culture:checked').length > 2) {
       this.checked = false;
   }
});
}


export { checkboxclick, checktwo };

