const toggleButton = document.getElementById("darkModeToggle");

// Apply saved theme or system preference
function applyTheme() {
  const savedTheme = localStorage.getItem("theme");
  const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches;

  if (savedTheme === "dark" || (!savedTheme && prefersDark)) {
    document.body.classList.add("dark");
    toggleButton.textContent = "☀️ Light Mode";
  } else {
    document.body.classList.remove("dark");
    toggleButton.textContent = "🌙 Dark Mode";
  }
}

// Toggle theme on button click
toggleButton.addEventListener("click", () => {
  document.body.classList.toggle("dark");

  if (document.body.classList.contains("dark")) {
    localStorage.setItem("theme", "dark");
    toggleButton.textContent = "☀️ Light Mode";
  } else {
    localStorage.setItem("theme", "light");
    toggleButton.textContent = "🌙 Dark Mode";
  }
});

// Run on load
applyTheme();
