document.addEventListener("turbo:load", () => {
  const input = document.getElementById("item-images-input");
  const preview = document.getElementById("image-preview-container");

  if (input && preview) {
    input.addEventListener("change", () => {
      preview.innerHTML = ""; // リセット

      const files = Array.from(input.files);
      console.log("選択された画像数:", input.files.length);

      files.slice(0, 5).forEach(file => {
        const reader = new FileReader();
        reader.onload = e => {
          const img = document.createElement("img");
          img.src = e.target.result;
          img.classList.add("m-1");
          img.style.width = "150px";
          img.style.height = "150px";
          img.style.objectFit = "cover";
          img.style.border = "1px solid #ddd";
          img.style.borderRadius = "8px";
          preview.appendChild(img);
        };
        reader.readAsDataURL(file);
      });

      // 5枚以上選択した場合の警告
      if (files.length > 5) {
        alert("画像は5枚まで選択できます。");
      }
    });
  }
});