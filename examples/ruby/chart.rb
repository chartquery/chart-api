# Chart Render API – Ruby example (stdlib only)
# Usage: CHARTQUERY_API_KEY=your-key ruby chart.rb
require "json"
require "net/http"
require "uri"

def call(method, url, body = nil)
  uri = URI(url)
  klass = { "GET" => Net::HTTP::Get, "POST" => Net::HTTP::Post, "PUT" => Net::HTTP::Put, "PATCH" => Net::HTTP::Patch }[method]
  req = klass.new(uri)
  req["x-api-key"] = ENV.fetch("CHARTQUERY_API_KEY")
  if body
    req["Content-Type"] = "application/json"
    req.body = body
  end
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true, read_timeout: 120) { |http| http.request(req) }
  abort "HTTP #{res.code}: #{res.body}" unless res.is_a?(Net::HTTPSuccess)
  res.body
end

uri = URI("https://api.chartquery.com/v1/chart")
uri.query = URI.encode_www_form('query' => '{"type":"bar","title":"Monthly Sales","legend":"bottom","width":1200,"height":600,"device_pixel_ratio":1,"data":{"labels":["Jan","Feb","Mar","Apr","May","Jun"],"datasets":[{"label":"2025","data":[42,58,37,65,49,72],"backgroundColor":"rgba(99,102,241,0.85)"},{"label":"2026","data":[51,67,44,71,58,85],"backgroundColor":"rgba(249,115,22,0.85)"}]},"scales":{"y":{"beginAtZero":true}}}')
response = call("GET", uri.to_s)

File.binwrite("chart.png", response)
puts "Saved chart.png"
