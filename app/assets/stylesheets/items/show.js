// DOMの読み込みが完了したら実行
document.addEventListener('turbo:load', () => {
  // 商品詳細ページの要素が存在する場合のみ実行
  if (!document.querySelector('.item-show')) {
    return;
  }

  // --- 画像ギャラリー機能 ---
  const mainImage = document.getElementById('main-image');
  const thumbnails = document.querySelectorAll('.thumbnail-image');

  // 最初のサムネイルをアクティブ状態にする
  if (thumbnails.length > 0) {
    thumbnails[0].classList.add('active');
  }

  thumbnails.forEach(thumbnail => {
    thumbnail.addEventListener('click', () => {
      // メイン画像のsrcを、クリックされたサムネイルのsrcに設定
      mainImage.src = thumbnail.src;

      // すべてのサムネイルから 'active' クラスを削除
      thumbnails.forEach(t => t.classList.remove('active'));

      // クリックされたサムネイルに 'active' クラスを追加
      thumbnail.classList.add('active');
    });
  });


  // --- バリエーション選択機能 ---
  const colorButtons = document.querySelectorAll('.color-btn');
  const sizeButtons = document.querySelectorAll('.size-btn');
  const purchaseButton = document.getElementById('purchase-btn');

  // バリエーションの在庫情報をHTMLから取得・パース
  // この<script>タグは、show.html.erbに追記する必要があります
  const variantsDataElement = document.getElementById('item-variants-data');
  const variants = variantsDataElement ? JSON.parse(variantsDataElement.textContent) : [];

  // 選択状態を更新し、購入ボタンの状態を制御する関数
  const updateVariantSelection = () => {
    const selectedColor = document.querySelector('.color-btn.selected');
    const selectedSize = document.querySelector('.size-btn.selected');

    // --- サイズボタンの有効/無効を切り替え ---
    if (selectedColor) {
      const selectedColorId = selectedColor.dataset.colorId;
      sizeButtons.forEach(sizeBtn => {
        const sizeId = sizeBtn.dataset.sizeId;
        // 選択中の色に対応するサイズの在庫があるかチェック
        const isAvailable = variants.some(v => v.color_id == selectedColorId && v.size_id == sizeId && v.stock > 0);
        sizeBtn.disabled = !isAvailable;
        if (!isAvailable) {
          sizeBtn.classList.remove('selected'); // 在庫がなければ選択解除
        }
      });
    }

    // --- 購入ボタンの有効/無効を切り替え ---
    if (selectedColor && selectedSize) {
      const selectedColorId = selectedColor.dataset.colorId;
      const selectedSizeId = selectedSize.dataset.sizeId;

      // 選択された組み合わせの在庫があるかチェック
      const hasStock = variants.some(v => v.color_id == selectedColorId && v.size_id == selectedSizeId && v.stock > 0);

      if (hasStock) {
        purchaseButton.classList.remove('disabled');
        purchaseButton.href = `/items/${variants[0].item_id}/orders/new?variant_id=${variants.find(v => v.color_id == selectedColorId && v.size_id == selectedSizeId).id}`; // 仮の購入パス
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
      // クリックされたボタン以外は 'selected' を外す
      colorButtons.forEach(btn => {
        if (btn !== button) btn.classList.remove('selected');
      });
      // クリックされたボタンの 'selected' をトグル
      button.classList.toggle('selected');
      updateVariantSelection();
    });
  });

  // サイズボタンのクリックイベント
  sizeButtons.forEach(button => {
    button.addEventListener('click', () => {
      sizeButtons.forEach(btn => {
        if (btn !== button) btn.classList.remove('selected');
      });
      button.classList.toggle('selected');
      updateVariantSelection();
    });
  });
});