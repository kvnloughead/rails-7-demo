// Menu manipulation

// Adds a toggle listener
function addToggleListener(togglerID, menuID, toggleClass) {
  const toggler = document.querySelector(`#${togglerID}`);
  toggler.addEventListener('click', function (evt) {
    evt.preventDefault();
    const menu = document.querySelector(`#${menuID}`);
    menu.classList.toggle(toggleClass);
  });
}

document.addEventListener('turbo:load', function () {
  addToggleListener('hamburger', 'navbar-menu', 'collapse');
  addToggleListener('account', 'dropdown-menu', 'active');
});
