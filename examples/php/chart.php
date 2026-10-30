<?php
// Chart Render API – PHP example (ext-curl)
// Usage: CHARTQUERY_API_KEY=your-key php chart.php

function call(string $method, string $url, ?string $body = null): string
{
    $ch = curl_init($url);
    $headers = ['x-api-key: ' . getenv('CHARTQUERY_API_KEY')];
    if ($body !== null) {
        $headers[] = 'Content-Type: application/json';
        curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
    }
    curl_setopt_array($ch, [
        CURLOPT_CUSTOMREQUEST => $method,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT => 120,
        CURLOPT_HTTPHEADER => $headers,
    ]);
    $res = curl_exec($ch);
    $status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    if ($status >= 400) {
        fwrite(STDERR, "HTTP $status: $res\n");
        exit(1);
    }
    return $res;
}

$query = http_build_query([
    'query' => '{"type":"bar","title":"Monthly Sales","legend":"bottom","width":1200,"height":600,"device_pixel_ratio":1,"data":{"labels":["Jan","Feb","Mar","Apr","May","Jun"],"datasets":[{"label":"2025","data":[42,58,37,65,49,72],"backgroundColor":"rgba(99,102,241,0.85)"},{"label":"2026","data":[51,67,44,71,58,85],"backgroundColor":"rgba(249,115,22,0.85)"}]},"scales":{"y":{"beginAtZero":true}}}'
]);
$response = call('GET', 'https://api.chartquery.com/v1/chart' . ($query ? '?' . $query : ''));

file_put_contents('chart.png', $response);
echo 'Saved chart.png', PHP_EOL;
