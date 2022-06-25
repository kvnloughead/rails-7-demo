// Menu manipulation

// Add toggle listeners to hamburger and account toggle
document.addEventListener('turbo:load', function () {
  const hamburger = document.querySelector('#hamburger');
  const navbarMenu = document.querySelector('#navbar-menu');

  hamburger.addEventListener('click', function (evt) {
    evt.preventDefault();
    navbarMenu.classList.toggle('collapse');
  });

  const account = document.querySelector('#account');
  account.addEventListener('click', function (event) {
    event.preventDefault();
    const menu = document.querySelector('#dropdown-menu');
    menu.classList.toggle('active');
  });
});
