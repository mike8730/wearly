document.addEventListener('turbo:load', () => {
  const addBtn = document.getElementById('add-variant');
  const container = document.getElementById('item-variants');
  const templateEl = document.getElementById('item-variant-template');
  
  if (!addBtn || !container || !templateEl) return;

  const template = templateEl.innerHTML;

  addBtn.addEventListener('click', () => {
    const time = new Date().getTime();
    const newHtml = template.replace(/NEW_RECORD/g, time);
    container.insertAdjacentHTML('beforeend', newHtml);
  });

  container.addEventListener('click', (e) => {
    if (e.target && e.target.matches('.remove-variant')) {
      const variantDiv = e.target.closest('.variant-fields');
      if (!variantDiv) return;

      // hidden_field の _destroy を 1 にする
      const destroyField = variantDiv.querySelector('input[name*="_destroy"]');
      if (destroyField) destroyField.value = "1";

      // DOM から消すのではなく非表示にする
      variantDiv.style.display = "none";
    }
  });

});
