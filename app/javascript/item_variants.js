document.addEventListener('turbo:load', () => {
  const addBtn = document.getElementById('add-variant');
  const container = document.getElementById('item-variants');
  const template = document.getElementById('item-variant-template').innerHTML;

  // 追加ボタン
  addBtn.addEventListener('click', () => {
    const time = new Date().getTime();
    const newHtml = template.replace(/NEW_RECORD/g, time);
    container.insertAdjacentHTML('beforeend', newHtml);
  });

  // 削除ボタン（イベント委譲で動的要素も対応）
  container.addEventListener('click', (e) => {
    if (e.target && e.target.matches('.remove-variant')) {
      const variantDiv = e.target.closest('.variant-fields');
      if (variantDiv) variantDiv.remove();
    }
  });
});