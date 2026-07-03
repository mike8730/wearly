document.addEventListener("DOMContentLoaded", () => {
  const buttons = document.querySelectorAll(".favorite-btn");
  if (!buttons.length) return;

  buttons.forEach((btn) => {
    btn.addEventListener("click", async (e) => {
      e.preventDefault();

      const itemId = btn.dataset.itemId;
      const isFavorited = btn.dataset.favorited === "true";

      const url = `/items/${itemId}/favorite`;
      const method = isFavorited ? "DELETE" : "POST";

      const tokenTag = document.querySelector('meta[name="csrf-token"]');
      if (!tokenTag) {
        console.error("CSRF token not found");
        return;
      }

      const response = await fetch(url, {
        method: method,
        headers: {
          "X-CSRF-Token": tokenTag.content,
          "Accept": "application/json",
        },
      });

      if (!response.ok) {
        console.error("Favorite request failed");
        return;
      }

      // 状態更新
      btn.dataset.favorited = (!isFavorited).toString();
      btn.classList.toggle("favorited");
      btn.textContent = isFavorited ? "♡" : "♥";

      // アニメーション再適用
      btn.classList.remove("animate");
      void btn.offsetWidth;
      btn.classList.add("animate");
    });
  });
});

