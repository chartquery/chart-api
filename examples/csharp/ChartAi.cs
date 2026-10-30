// AI Chart API – C# example (.NET 6+, top-level statements)
// Usage: dotnet new console -n Example && copy this file to Program.cs, then CHARTQUERY_API_KEY=your-key dotnet run
using System.Text;
using System.Text.Json;

var apiKey = Environment.GetEnvironmentVariable("CHARTQUERY_API_KEY") ?? throw new InvalidOperationException("Set CHARTQUERY_API_KEY");
using var http = new HttpClient { Timeout = TimeSpan.FromSeconds(120) };
http.DefaultRequestHeaders.Add("x-api-key", apiKey);

var query = "prompt=" + Uri.EscapeDataString("Bar chart of monthly sales from January to June, indigo bars, clean style") + "&" +
    "format=" + Uri.EscapeDataString("png");
var response = await http.GetAsync("https://api.chartquery.com/v1/chart/ai" + (query.Length > 0 ? "?" + query : ""));
if (!response.IsSuccessStatusCode)
{
    Console.Error.WriteLine($"HTTP {(int)response.StatusCode}: {await response.Content.ReadAsStringAsync()}");
    return;
}

await File.WriteAllBytesAsync("ai-chart.png", await response.Content.ReadAsByteArrayAsync());
Console.WriteLine("Saved ai-chart.png");
