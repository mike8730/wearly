document.addEventListener("turbo:load", () => {
  if (!document.querySelector(".item-show")) return;

  // --- メイン画像切り替え ---
  const mainImage = document.getElementById("main-image");
  const thumbnails = document.querySelectorAll(".thumbnail-image");

  thumbnails.forEach((thumb) => {
    thumb.addEventListener("click", () => {
      mainImage.src = thumb.dataset.image;
      thumbnails.forEach((t) => t.classList.remove("active"));
      thumb.classList.add("active");
    });
  });

  // --- バリエーション選択 ---
  const colorButtons = document.querySelectorAll(".color-btn");
  const sizeButtons = document.querySelectorAll(".size-btn");
  const hiddenVariantField = document.getElementById("selected-variant-id");
  const addToCartButton = document.querySelector(".item-red-btn");

  const variants = JSON.parse(document.getElementById("item-variants-data").textContent);

  function disableAddToCart() {
    addToCartButton.classList.add("disabled");
    addToCartButton.disabled = true;
    hiddenVariantField.value = "";
  }

  function enableAddToCart(variantId) {
    addToCartButton.classList.remove("disabled");
    addToCartButton.disabled = false;
    hiddenVariantField.value = variantId;
  }

  // 初期状態：在庫 0 のサイズを無効化
  sizeButtons.forEach((btn) => {
    const sizeId = btn.dataset.sizeId;

    const hasStock = variants.some(v =>
      v.size_id == sizeId && v.stock > 0
    );

    if (!hasStock) {
      btn.disabled = true;
      btn.classList.add("disabled");
    }
  });

  function updateSelection() {
    const selectedColor = document.querySelector(".color-btn.selected");
    const selectedSize = document.querySelector(".size-btn.selected");

    if (selectedColor && selectedSize) {
      const colorId = selectedColor.dataset.colorId;
      const sizeId = selectedSize.dataset.sizeId;

      const variant = variants.find(v =>
        v.color_id == colorId && v.size_id == sizeId
      );

      if (variant && variant.stock > 0) {
        enableAddToCart(variant.id);
      } else {
        disableAddToCart();
      }
    } else {
      disableAddToCart();
    }
  }

  // --- カラー選択 ---
  colorButtons.forEach((btn) => {
    btn.addEventListener("click", () => {
      colorButtons.forEach((b) => b.classList.remove("selected"));
      btn.classList.add("selected");

      // カラーに対応するサムネイルをメインに反映
      const selectedColorId = btn.dataset.colorId;
      const targetThumb = Array.from(thumbnails).find(
        (t) => t.dataset.colorId === selectedColorId
      );

      if (targetThumb) {
        mainImage.src = targetThumb.dataset.image;
        thumbnails.forEach((t) => t.classList.remove("active"));
        targetThumb.classList.add("active");
      }

      updateSelection();
    });
  });

  // --- サイズ選択（カラー選択状態は維持） ---
  sizeButtons.forEach((btn) => {
    btn.addEventListener("click", () => {
      if (btn.disabled) return;

      sizeButtons.forEach((b) => b.classList.remove("selected"));
      btn.classList.add("selected");

      updateSelection();
    });
  });

  disableAddToCart();
});