# AI Chart API – Ruby example (stdlib only)
# Usage: CHARTQUERY_API_KEY=your-key ruby chart_ai.rb
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

uri = URI("https://api.chartquery.com/v1/chart/ai")
uri.query = URI.encode_www_form('prompt' => 'Bar chart of monthly sales from January to June, indigo bars, clean style', 'format' => 'png')
response = call("GET", uri.to_s)

File.binwrite("ai-chart.png", response)
puts "Saved ai-chart.png"
