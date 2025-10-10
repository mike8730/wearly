document.addEventListener('turbo:load', function() {
  const hamburgerMenu = document.getElementById('hamburger-menu');
  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebar-overlay');

  if (!hamburgerMenu || !sidebar || !overlay) {
    return;
  }

  function toggleSidebar() {
    sidebar.classList.toggle('is-open');
    overlay.classList.toggle('is-open');
  }

  hamburgerMenu.addEventListener('click', toggleSidebar);
  overlay.addEventListener('click', toggleSidebar);
});