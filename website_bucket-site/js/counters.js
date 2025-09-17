    // Year
    document.getElementById("year").textContent = new Date().getFullYear();

    // Visit Counter
    loadConfig().then(cfg => {
    const API_BASE = cfg.api_url;

    (async () => {
      try {
        const response = await fetch("${API_BASE}/visits");
        if (!response.ok) throw new Error("API error");
        const data = await response.json();
        document.getElementById("visit-counter").textContent = data.visits;
      } catch (err) {
        document.getElementById("visit-counter").textContent = "N/A";
        console.error(err);
      }
    })();