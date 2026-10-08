require 'httparty'
require 'uri'
require 'time'
require_relative 'payloads'

# ------- Data collection -------

$results = []
$target_url = ""
$start_time = Time.now
$baseline_size = 0

# ------- Helpers -------

def build_url(base_url, param_name, param_value)
  uri = URI.parse(base_url)
  query = URI.decode_www_form(uri.query || "")
  query.map! { |k, v| k == param_name ? [k, param_value] : [k, v] }
  uri.query = URI.encode_www_form(query)
  uri.to_s
end

def fetch(url)
  response = HTTParty.get(url, timeout: 10)
  { code: response.code, body: response.body }
rescue => e
  puts "  [!] Connection error: #{e.message}"
  nil
end

def has_sql_error?(body)
  SQL_ERROR_SIGNATURES.any? { |sig| body.include?(sig) }
end

def payload_reflected?(body, payload)
  body.include?(payload)
end

# ------- HTML report generator -------

def generate_html_report(filename = "report.html")
  duration = (Time.now - $start_time).round(2)
  vulnerable_count = $results.count { |r| r[:status] == "VULNERABLE" }
  suspicious_count = $results.count { |r| r[:status] == "SUSPICIOUS" }
  ok_count = $results.count { |r| r[:status] == "OK" }

  html = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Security Scan Report</title>
      <style>
        * { box-sizing: border-box; }
        body {
          font-family: 'Segoe UI', Arial, sans-serif;
          background: #f4f6f8; margin: 0; padding: 24px; color: #222;
        }
        .container { max-width: 960px; margin: 0 auto; }
        header {
          background: linear-gradient(135deg, #1e293b, #334155);
          color: #fff; padding: 24px; border-radius: 10px;
          margin-bottom: 20px;
        }
        header h1 { margin: 0 0 8px; font-size: 22px; }
        header .meta { font-size: 13px; opacity: 0.85; line-height: 1.6; }
        header code { background: rgba(255,255,255,0.15); padding: 2px 6px; border-radius: 4px; }
        .stats { display: flex; gap: 12px; margin-bottom: 20px; }
        .stat {
          flex: 1; padding: 16px; border-radius: 8px;
          background: #fff; text-align: center;
          border: 1px solid #e2e8f0;
        }
        .stat .num { font-size: 26px; font-weight: bold; }
        .stat .label { font-size: 12px; color: #64748b; margin-top: 4px; text-transform: uppercase; }
        .stat.vuln .num { color: #dc2626; }
        .stat.susp .num { color: #d97706; }
        .stat.ok   .num { color: #16a34a; }
        table {
          width: 100%; background: #fff; border-collapse: collapse;
          border-radius: 8px; overflow: hidden;
          box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        th, td { padding: 10px 12px; text-align: left; font-size: 13px; border-bottom: 1px solid #e2e8f0; }
        th { background: #f1f5f9; font-weight: 600; color: #334155; text-transform: uppercase; font-size: 11px; letter-spacing: 0.5px; }
        tr:last-child td { border-bottom: none; }
        .tag {
          display: inline-block; padding: 2px 8px; border-radius: 10px;
          font-size: 11px; font-weight: 600;
        }
        .tag.VULNERABLE { background: #fee2e2; color: #991b1b; }
        .tag.SUSPICIOUS { background: #fef3c7; color: #92400e; }
        .tag.OK         { background: #dcfce7; color: #166534; }
        .payload { font-family: 'Consolas', 'Courier New', monospace; font-size: 12px; color: #475569; }
        footer { text-align: center; font-size: 12px; color: #64748b; margin-top: 24px; }
      </style>
    </head>
    <body>
      <div class="container">
        <header>
          <h1>🛡️ Security Scan Report</h1>
          <div class="meta">
            <div><strong>Target:</strong> <code>#{$target_url}</code></div>
            <div><strong>Scan date:</strong> #{Time.now.strftime('%Y-%m-%d %H:%M:%S')}</div>
            <div><strong>Duration:</strong> #{duration} seconds</div>
          </div>
        </header>

        <div class="stats">
          <div class="stat vuln"><div class="num">#{vulnerable_count}</div><div class="label">Vulnerable</div></div>
          <div class="stat susp"><div class="num">#{suspicious_count}</div><div class="label">Suspicious</div></div>
          <div class="stat ok"><div class="num">#{ok_count}</div><div class="label">Passed</div></div>
        </div>

        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Type</th>
              <th>Parameter</th>
              <th>Payload</th>
              <th>Status</th>
              <th>Detail</th>
            </tr>
          </thead>
          <tbody>
  HTML

  $results.each_with_index do |r, i|
    html << <<~ROW
      <tr>
        <td>#{i + 1}</td>
        <td>#{r[:type]}</td>
        <td><strong>#{r[:param]}</strong></td>
        <td class="payload">#{r[:payload].gsub('<', '&lt;').gsub('>', '&gt;')}</td>
        <td><span class="tag #{r[:status]}">#{r[:status]}</span></td>
        <td>#{r[:detail]}</td>
      </tr>
    ROW
  end

  html << <<~HTML
          </tbody>
        </table>

        <footer>
          Generated by <strong>Ruby Security Scanner</strong> · Educational project
        </footer>
      </div>
    </body>
    </html>
  HTML

  File.write(filename, html)
  puts "\n[+] HTML report saved to: #{File.expand_path(filename)}"
end

# ------- MAIN -------

if ARGV.empty?
  puts "Usage: ruby scanner.rb <URL>"
  puts "Example: ruby scanner.rb 'http://testasp.vulnweb.com/Search.asp?tfSearch=test'"
  exit
end

$target_url = ARGV[0]
puts "\n[*] Target: #{$target_url}\n"

uri = URI.parse($target_url)
params = URI.decode_www_form(uri.query || "")

if params.empty?
  puts "[!] This URL has no GET parameters. The scanner needs parameters to test."
  exit
end

puts "[*] Parameters found: #{params.map(&:first).join(', ')}\n\n"

puts "[*] Fetching baseline response..."
baseline = fetch($target_url)

unless baseline
  puts "[!] Could not reach the target. Scan aborted."
  exit
end

$baseline_size = baseline[:body].length
puts "  [+] Baseline: HTTP #{baseline[:code]}, #{$baseline_size} bytes\n\n"

# ------- SQLi -------

puts "=" * 60
puts "[*] Testing for SQL Injection"
puts "=" * 60

params.each do |param_name, original_value|
  puts "\nParameter: #{param_name}"

  SQLI_PAYLOADS.each do |payload|
    test_url = build_url($target_url, param_name, original_value + payload)
    print "  -> Testing: #{payload[0..30].inspect} ... "

    result = fetch(test_url)
    next unless result

    status = "OK"
    detail = "No indicator found"

    if has_sql_error?(result[:body])
      status = "VULNERABLE"
      detail = "SQL error signature detected in response"
      puts "[VULNERABLE] SQL error detected"
    elsif result[:body].length > $baseline_size * 1.5
      status = "SUSPICIOUS"
      detail = "Response size significantly larger than baseline"
      puts "[SUSPICIOUS] Response size larger"
    else
      puts "[OK]"
    end

    $results << {
      type: "SQLi", param: param_name, payload: payload,
      status: status, detail: detail
    }
  end
end

# ------- XSS -------

puts "\n"
puts "=" * 60
puts "[*] Testing for XSS (Cross-Site Scripting)"
puts "=" * 60

params.each do |param_name, original_value|
  puts "\nParameter: #{param_name}"

  XSS_PAYLOADS.each do |payload|
    test_url = build_url($target_url, param_name, payload)
    print "  -> Testing: #{payload[0..30].inspect} ... "

    result = fetch(test_url)
    next unless result

    status = "OK"
    detail = "Payload not reflected"

    if payload_reflected?(result[:body], payload)
      status = "VULNERABLE"
      detail = "Payload reflected unescaped in response"
      puts "[VULNERABLE] Payload reflected"
    else
      puts "[OK]"
    end

    $results << {
      type: "XSS", param: param_name, payload: payload,
      status: status, detail: detail
    }
  end
end

# ------- Report -------

puts "\n\n[+] Scan finished."
generate_html_report