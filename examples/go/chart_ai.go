// AI Chart API – Go example
// Usage: CHARTQUERY_API_KEY=your-key go run chart_ai.go
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"time"
)

var client = &http.Client{Timeout: 120 * time.Second}

func call(method, target string, body []byte) []byte {
	var reader io.Reader
	if body != nil {
		reader = bytes.NewReader(body)
	}
	req, _ := http.NewRequest(method, target, reader)
	req.Header.Set("x-api-key", os.Getenv("CHARTQUERY_API_KEY"))
	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()
	data, _ := io.ReadAll(resp.Body)
	if resp.StatusCode >= 400 {
		fmt.Fprintf(os.Stderr, "HTTP %d: %s\n", resp.StatusCode, data)
		os.Exit(1)
	}
	return data
}

func main() {
	_ = url.Values{}
	_ = json.Valid
	params := url.Values{}
	params.Set("prompt", "Bar chart of monthly sales from January to June, indigo bars, clean style")
	params.Set("format", "png")
	target := "https://api.chartquery.com/v1/chart/ai"
	if len(params) > 0 {
		target += "?" + params.Encode()
	}
	data := call("GET", target, nil)
	if err := os.WriteFile("ai-chart.png", data, 0o644); err != nil {
		panic(err)
	}
	fmt.Println("Saved ai-chart.png")
}
