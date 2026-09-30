// pkgdown has no Mongolian interface translation, so the Mongolian site
// replaces its built-in English labels once the page has loaded.
document.addEventListener("DOMContentLoaded", function () {
  var labels = {
    "On this page": "Энэ хуудсанд",
    "Skip to contents": "Агуулга руу шилжих",
    "Package index": "Функцийн жагсаалт",
    "Articles": "Нийтлэлүүд",
    "All vignettes": "Бүх нийтлэл",
    "Usage": "Хэрэглээ",
    "Arguments": "Аргумент",
    "Value": "Буцаах утга",
    "Details": "Дэлгэрэнгүй",
    "Examples": "Жишээ",
    "See also": "Мөн үзэх",
    "Format": "Бүтэц",
    "Source": "Эх сурвалж",
    "Authors and Citation": "Зохиогч, иш татах",
    "Authors": "Зохиогч",
    "Citation": "Иш татах",
    "License": "Лиценз",
    "Source:": "Эх код:"
  };
  // Translate the element's own text, leaving child elements (such as the
  // anchor links pkgdown adds to headings) in place.
  document.querySelectorAll("h1, h2, h3, h4, nav a, .nav-link, small.dont-index, a.skip-link")
    .forEach(function (el) {
      el.childNodes.forEach(function (node) {
        if (node.nodeType !== Node.TEXT_NODE) return;
        var text = node.textContent.trim();
        if (text && Object.prototype.hasOwnProperty.call(labels, text)) {
          node.textContent = node.textContent.replace(text, labels[text]);
        }
      });
    });
  Object.keys(labels).forEach(function (en) {
    if (document.title.indexOf(en + " •") === 0) {
      document.title = labels[en] + document.title.slice(en.length);
    }
  });
  var search = document.querySelector("input[type=search]");
  if (search) {
    search.placeholder = "Хайх";
    search.setAttribute("aria-label", "Хайх");
  }
});
