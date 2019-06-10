const checkboxclickmistery = () => {
  $(document).ready(function(){
    $(".mistery-choice").click(function(){
      if ($(this).parent().hasClass('active')) {
        $(this).parent().removeClass("active");
      } else {
        if($('.parent-class-mistery.active').length < 1) {
         $(this).parent().addClass("active");
        }
      }

    });
  });
}
const checkonemistery = () => {
$('.check-mistery').on('change', function() {
   if($('.check-mistery:checked').length > 1) {
       this.checked = false;
   }
});
}
export { checkboxclickmistery, checkonemistery };

