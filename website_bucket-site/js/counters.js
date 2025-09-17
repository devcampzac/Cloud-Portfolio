    // Year
    document.getElementById("year").textContent = new Date().getFullYear();

    // Visit Counter
    loadConfig().then(cfg => {
      const API_BASE = cfg.api_url;

      fetch(`${API_BASE}/visits`)
        .then(res => res.json())
        .then(data => {
          document.getElementById("visit-counter").innerText = data.visits;
        })
        .catch(err => console.error("Error fetching visits:", err));
    });
