const required = (name: string) => {
  const value = process.env[name];
  if (!value) throw new Error(`missing_${name}`);
  return value.replace(/\/$/, "");
};

async function check(name: string, url: string) {
  const response = await fetch(url, { method: "GET", signal: AbortSignal.timeout(10000) });
  if (!response.ok) throw new Error(`${name}_http_${response.status}`);
  console.log(`${name}: PASS (${response.status})`);
}

async function main() {
  await check("n8n", `${required("N8N_EDITOR_BASE_URL")}/healthz`);
  await check("woocommerce", `${required("WOOCOMMERCE_BASE_URL")}/wp-json/wc/v3/system_status`);
  console.log("Phase 9 smoke: PASS");
}

main().catch((error) => {
  console.error(`Phase 9 smoke: FAIL (${error.message})`);
  process.exit(1);
});
