async function loadConfig() {
  const response = await fetch("/site_config.json");
  return await response.json();
}
