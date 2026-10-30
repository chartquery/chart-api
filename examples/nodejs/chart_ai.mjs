// AI Chart API – Node.js example (Node 18+, ES module)
// Usage: CHARTQUERY_API_KEY=your-key node chart_ai.mjs
import { writeFile } from "node:fs/promises";

const headers = { "x-api-key": process.env.CHARTQUERY_API_KEY, "Content-Type": "application/json" };

const params = new URLSearchParams({
  "prompt": "Bar chart of monthly sales from January to June, indigo bars, clean style",
  "format": "png",
});
const response = await fetch(`https://api.chartquery.com/v1/chart/ai?${params}`, { headers });
if (!response.ok) {
  console.error(`HTTP ${response.status}: ${await response.text()}`);
  process.exit(1);
}

await writeFile("ai-chart.png", Buffer.from(await response.arrayBuffer()));
console.log("Saved ai-chart.png");
