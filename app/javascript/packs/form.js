const checkboxclick = () => {
document.querySelectorAll(".activity-choice").forEach((element) =>{
  element.addEventListener("click", (event) => {
    event.currentTarget.classList.toggle("active");
  });
});
}

export { checkboxclick };

