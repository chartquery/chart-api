// Chart Render API – C# example (.NET 6+, top-level statements)
// Usage: dotnet new console -n Example && copy this file to Program.cs, then CHARTQUERY_API_KEY=your-key dotnet run
using System.Text;
using System.Text.Json;

var apiKey = Environment.GetEnvironmentVariable("CHARTQUERY_API_KEY") ?? throw new InvalidOperationException("Set CHARTQUERY_API_KEY");
using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(120) };
http.DefaultRequestHeaders.Add("x-api-key", apiKey);

var query = "query=" + Uri.EscapeDataString("{\"type\":\"bar\",\"title\":\"Monthly Sales\",\"legend\":\"bottom\",\"width\":1200,\"height\":600,\"device_pixel_ratio\":1,\"data\":{\"labels\":[\"Jan\",\"Feb\",\"Mar\",\"Apr\",\"May\",\"Jun\"],\"datasets\":[{\"label\":\"2025\",\"data\":[42,58,37,65,49,72],\"backgroundColor\":\"rgba(99,102,241,0.85)\"},{\"label\":\"2026\",\"data\":[51,67,44,71,58,85],\"backgroundColor\":\"rgba(249,115,22,0.85)\"}]},\"scales\":{\"y\":{\"beginAtZero\":true}}}");
var response = await http.GetAsync("https://api.chartquery.com/v1/chart" + (query.Length > 0 ? "?" + query : ""));
if (!response.IsSuccessStatusCode)
{
    Console.Error.WriteLine($"HTTP {(int)response.StatusCode}: {await response.Content.ReadAsStringAsync()}");
    return;
}

await File.WriteAllBytesAsync("chart.png", await response.Content.ReadAsByteArrayAsync());
Console.WriteLine("Saved chart.png");
