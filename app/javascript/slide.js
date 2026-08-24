document.addEventListener("turbo:load", () => {
  const track = document.getElementById("slider-track");
  const btnLeft = document.getElementById("slider-left");
  const btnRight = document.getElementById("slider-right");

  if (!track) return;

  const slide = track.querySelector(".main-visual-img");

  if (!slide) return;

  const slideWidth = slide.clientWidth + 20;

  btnLeft?.addEventListener("click", () => {
    track.scrollBy({
      left: -slideWidth,
      behavior: "smooth"
    });
  });

  btnRight?.addEventListener("click", () => {
    track.scrollBy({
      left: slideWidth,
      behavior: "smooth"
    });
  });
});


