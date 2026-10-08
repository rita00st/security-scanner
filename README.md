
# 🛡️ Ruby Security Scanner

A simple web vulnerability scanner written in Ruby, 
capable of detecting SQL Injection and XSS vulnerabilities.

## ✨ Features
- Detects SQL Injection (error-based)
- Detects XSS (reflected)
- Generates a professional HTML report
- Works with GET parameters
- Color-coded results (VULNERABLE / SUSPICIOUS / OK)

## 🚀 Installation
```bash
gem install httparty
```

## 📖 Usage
```bash
ruby scanner.rb "http://target.com/page.asp?id=1"
```
After the scan completes, open `report.html` in your browser.

## 🧪 Tested On
- testasp.vulnweb.com (ASP test target)
- example.com (for baseline check)

## 📚 Related Work
This project is inspired by academic research such as 
"Symbolic Security Analysis of Ruby-on-Rails Web Applications" 
(Chaudhuri & Foster, ACM CCS 2010), which introduced the 
Rubyx tool for static security analysis of Ruby apps.

## ⚠️ Disclaimer
This tool is for **educational purposes only**. 
Do not use it on websites you don't own or have permission to test.

## 📜 License
MIT


### 📄 فایل `.gitignore` — فایل‌هایی که نباید پوش شوند

```
*.log
*.tmp
.DS_Store
report_*.html
```

---

## 🚀 روش پوش کردن: از سیستم یا سایت؟

**پیشنهاد من: از سیستم (خط فرمان یا VS Code)**

دلیلش این است که:

1. **Git را یک بار یاد می‌گیری و برای همیشه بلد می‌شوی** — این یک مهارت اساسی هر برنامه‌نویس است.
2. **کنترل کامل‌تری داری** — می‌توانی commitهای مختلف بسازی، تغییرات را ببینی، و مدیریت کنی.
3. **VS Code خودش Git را در خود دارد** — بدون ترمینال، با چند کلیک می‌توانی push کنی.
4. **کارفرمایان آینده از GitHub activity شما خوششان می‌آید** — نشان می‌دهد با Git کار می‌کنی.

### 🛠️ مراحل پوش کردن از VS Code (ساده‌ترین روش)

**قدم ۱: ساخت ریپازیتوری در GitHub**
1. به `github.com` برو و لاگین کن (اگر حساب نداری، بساز).
2. روی دکمه‌ی **`+`** بالای صفحه کلیک کن → **`New repository`**.
3. نام: `ruby-security-scanner`
4. توضیح: `A simple web vulnerability scanner in Ruby (SQLi + XSS)`
5. **Public** را انتخاب کن (تا استادت هم ببیند).
6. تیک `Add a README file` را **نزن** (چون خودمان README داریم).
7. روی **`Create repository`** کلیک کن.

**قدم ۲: اتصال VS Code به GitHub**
1. VS Code را باز کن.
2. پوشه‌ی `security-scanner` را باز کن (`File → Open Folder`).
3. اگر Git نصب نیست، از `git-scm.com` دانلود و نصب کن.
4. نوار سمت چپ، آیکون **Source Control** (سه دایره به هم چسبیده) را بزن.
5. روی **`Initialize Repository`** کلیک کن.

**قدم ۳: ساخت اولین Commit**
1. در پنل Source Control، فایل‌های `scanner.rb`, `payloads.rb`, `README.md`, `.gitignore` را می‌بینی.
2. کنار هر فایل، آیکون `+` را بزن (Stage) — یا روی `Changes` کلیک کن تا همه Stage شوند.
3. در کادر بالا یک پیام commit بنویس: `Initial commit - basic scanner`
4. روی **✓ Commit** کلیک کن.

**قدم ۴: Publish به GitHub**
1. بعد از commit، VS Code می‌پرسد `Publish Branch?`
2. روی `Publish Branch` کلیک کن.
3. اگر پرسید `Sign in to GitHub`، اجازه بده VS Code به حساب GitHub تو وصل شود.
4. نام ریپازیتوری را `ruby-security-scanner` بگذار و **Public** را انتخاب کن.
5. تمام! پروژه‌ات روی GitHub است. 🎉

**قدم ۵ (اختیاری): تنظیم کردن آدرس ریپو به دستی**
اگر VS Code خودکار پوش نکرد، در ترمینال VS Code این دستورها را بزن:

```bash
git remote add origin https://github.com/rita00st/ruby-security-scanner.git
git branch -M main
git push -u origin main
```

