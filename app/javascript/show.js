document.addEventListener('turbo:load', () => {
  // 商品詳細ページでのみ実行
  if (!document.querySelector('.item-show')) return;

  // --- 画像ギャラリー機能 ---
  const mainImage = document.getElementById('main-image');
  const thumbnails = document.querySelectorAll('.thumbnail-image');

  if (thumbnails.length > 0) {
    thumbnails[0].classList.add('active');
  }

  thumbnails.forEach(thumbnail => {
    thumbnail.addEventListener('click', () => {
      mainImage.src = thumbnail.src;
      thumbnails.forEach(t => t.classList.remove('active'));
      thumbnail.classList.add('active');
    });
  });

  // --- バリエーション選択機能 ---
  const colorButtons = document.querySelectorAll('.color-btn');
  const sizeButtons = document.querySelectorAll('.size-btn');
  const purchaseButton = document.getElementById('purchase-btn');

  const variantsDataElement = document.getElementById('item-variants-data');
  window.variants = variantsDataElement ? JSON.parse(variantsDataElement.innerHTML) : [];

  const updateVariantSelection = () => {
    const selectedColor = document.querySelector('.color-btn.selected');
    const selectedSize = document.querySelector('.size-btn.selected');

    // サイズボタンの有効/無効と売り切れ表示を切り替え
    if (selectedColor) {
      const selectedColorId = selectedColor.dataset.colorId;
      sizeButtons.forEach(sizeBtn => {
        const sizeId = sizeBtn.dataset.sizeId;
        const isAvailable = window.variants.some(v =>
          v.color_id == selectedColorId && v.size_id == sizeId && v.stock > 0
        );

        sizeBtn.disabled = !isAvailable;
        if (!isAvailable) {
          sizeBtn.classList.remove('selected');
        }

        // 売り切れラベルの表示切り替え
        const soldOutLabel = document.querySelector(`.sold-out-label[data-size-id="${sizeId}"]`);
        if (soldOutLabel) {
          soldOutLabel.style.display = isAvailable ? "none" : "inline";
        }
      });
    } else {
      sizeButtons.forEach(sizeBtn => {
        sizeBtn.disabled = false;
        sizeBtn.classList.remove('selected');

        const soldOutLabel = document.querySelector(`.sold-out-label[data-size-id="${sizeBtn.dataset.sizeId}"]`);
        if (soldOutLabel) {
          soldOutLabel.style.display = "none";
        }
      });
    }

    // 購入ボタンの有効/無効を切り替え
    if (selectedColor && selectedSize) {
      const selectedColorId = selectedColor.dataset.colorId;
      const selectedSizeId = selectedSize.dataset.sizeId;
      const selectedVariant = window.variants.find(v =>
        v.color_id == selectedColorId && v.size_id == selectedSizeId
      );

      if (selectedVariant && selectedVariant.stock > 0) {
        purchaseButton.classList.remove('disabled');
        purchaseButton.href = `/items/${selectedVariant.item_id}/orders/new?variant_id=${selectedVariant.id}`;
      } else {
        purchaseButton.classList.add('disabled');
        purchaseButton.href = "#";
      }
    } else {
      purchaseButton.classList.add('disabled');
      purchaseButton.href = "#";
    }
  };

  // カラーボタンのクリックイベント
  colorButtons.forEach(button => {
    button.addEventListener('click', () => {
      colorButtons.forEach(btn => btn.classList.remove('selected'));
      button.classList.add('selected');
      updateVariantSelection();
    });
  });

  // サイズボタンのクリックイベント
  sizeButtons.forEach(button => {
    button.addEventListener('click', () => {
      if (button.disabled) return; // 無効なボタンは無視
      sizeButtons.forEach(btn => btn.classList.remove('selected'));
      button.classList.add('selected');
      updateVariantSelection();
    });
  });

  // 初期状態の更新
  updateVariantSelection();
});