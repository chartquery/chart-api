// Chart Render API – Node.js example (Node 18+, ES module)
// Usage: CHARTQUERY_API_KEY=your-key node chart.mjs
import { writeFile } from "node:fs/promises";

const headers = { "x-api-key": process.env.CHARTQUERY_API_KEY, "Content-Type": "application/json" };

const params = new URLSearchParams({
  "query": "{\"type\":\"bar\",\"title\":\"Monthly Sales\",\"legend\":\"bottom\",\"width\":1200,\"height\":600,\"device_pixel_ratio\":1,\"data\":{\"labels\":[\"Jan\",\"Feb\",\"Mar\",\"Apr\",\"May\",\"Jun\"],\"datasets\":[{\"label\":\"2025\",\"data\":[42,58,37,65,49,72],\"backgroundColor\":\"rgba(99,102,241,0.85)\"},{\"label\":\"2026\",\"data\":[51,67,44,71,58,85],\"backgroundColor\":\"rgba(249,115,22,0.85)\"}]},\"scales\":{\"y\":{\"beginAtZero\":true}}}",
});
const response = await fetch(`https://api.chartquery.com/v1/chart?${params}`, { headers });
if (!response.ok) {
  console.error(`HTTP ${response.status}: ${await response.text()}`);
  process.exit(1);
}

await writeFile("chart.png", Buffer.from(await response.arrayBuffer()));
console.log("Saved chart.png");
