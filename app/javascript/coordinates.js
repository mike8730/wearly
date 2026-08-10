document.addEventListener("DOMContentLoaded", () => {
  const addButton = document.getElementById("add-item");
  const container = document.getElementById("coordinate-items");
  const template = document.getElementById("item-template").innerHTML;

  let index = 1;

  if (addButton) {
    addButton.addEventListener("click", () => {
      const newFields = template.replace(/NEW_INDEX/g, index);
      container.insertAdjacentHTML("beforeend", newFields);
      index++;
    });
  }

  if (container) {
    container.addEventListener("click", (e) => {
      if (e.target.classList.contains("remove-item")) {
        const wrapper = e.target.closest(".coordinate-item-fields");
        wrapper.querySelector('input[type="hidden"]').value = "true";
        wrapper.style.display = "none";
      }
    });
  }
});
