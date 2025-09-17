document.getElementById("contact-form").addEventListener("submit", async (e) => {
  e.preventDefault();

  const formData = {
    name: e.target.name.value,
    email: e.target.email.value,
    message: e.target.message.value,
  };

  const statusElement = document.getElementById("form-status");
  statusElement.textContent = "Sending...";

  try {
    const cfg = await loadConfig();
    const API_BASE = cfg.api_url;

    const response = await fetch("${API_BASE}/contact", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(formData),
    });

    if (response.ok) {
      statusElement.textContent = "✅ Message sent successfully!";
      e.target.reset();
    } else {
      statusElement.textContent = "❌ Failed to send. Try again later.";
    }
  } catch (error) {
    statusElement.textContent = "⚠️ Error: " + error.message;
  }
});
