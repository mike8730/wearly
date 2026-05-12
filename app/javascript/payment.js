const initPaymentMethod = () => {
  const cards = document.querySelectorAll(".payment-card");
  if (cards.length === 0) return;

  cards.forEach(card => {
    const radio = card.querySelector("input[type='radio']");

    radio.addEventListener("change", () => {
      cards.forEach(c => c.classList.remove("selected"));
      card.classList.add("selected");
    });

    // 初期状態で checked のカードに selected を付ける
    if (radio.checked) {
      card.classList.add("selected");
    }
  });
};

document.addEventListener("turbo:load", initPaymentMethod);
document.addEventListener("turbo:render", initPaymentMethod);