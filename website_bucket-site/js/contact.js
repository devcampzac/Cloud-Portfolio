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
    const response = await fetch("https://3n5x6y8gok.execute-api.us-east-1.amazonaws.com/contact", {
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
