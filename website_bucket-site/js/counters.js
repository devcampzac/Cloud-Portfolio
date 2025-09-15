    // Year
    document.getElementById("year").textContent = new Date().getFullYear();

    // Visit Counter
    (async () => {
      try {
        const response = await fetch("https://3n5x6y8gok.execute-api.us-east-1.amazonaws.com/visits");
        if (!response.ok) throw new Error("API error");
        const data = await response.json();
        document.getElementById("visit-counter").textContent = data.visits;
      } catch (err) {
        document.getElementById("visit-counter").textContent = "N/A";
        console.error(err);
      }
    })();