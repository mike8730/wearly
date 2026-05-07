document.addEventListener("turbo:load", () => {
  const cards = document.querySelectorAll(".payment-card");

  cards.forEach(card => {
    const radio = card.querySelector("input[type='radio']");

    radio.addEventListener("change", () => {
      // 全カードの選択状態をリセット
      cards.forEach(c => c.classList.remove("selected"));

      // 選択されたカードに selected を付与
      card.classList.add("selected");
    });
  });
});
