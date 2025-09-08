from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin
from flask_cors import CORS
import google.generativeai as genai
import os

app = Flask(__name__)
CORS(app)
genai.configure(api_key=os.environ.get('AIzaSyBb_UHJJZw5PQ5_KCxwE5FamZTT_PBC8IM'))

SQLI_PAYLOADS = ["' OR '1'='1", "' OR 'a'='a", "';--", "' UNION SELECT NULL,NULL--"]
XSS_PAYLOADS = ["<script>alert(1)</script>", "\" onmouseover=alert(1) \"", "'><img src=x onerror=alert(1)>"]

def get_forms(url):
    try:
        response = requests.get(url, timeout=10)
        soup = BeautifulSoup(response.text, "lxml")
        return soup.find_all("form")
    except:
        return []

def test_sqli(url):
    vulns = []
    forms = get_forms(url)
    for form in forms:
        action = form.get("action")
        method = form.get("method", "get").lower()
        inputs = form.find_all("input")

        for payload in SQLI_PAYLOADS:
            data = {}
            for inp in inputs:
                if inp.get("name"):
                    data[inp.get("name")] = payload

            target_url = urljoin(url, action)
            try:
                if method == "post":
                    res = requests.post(target_url, data=data, timeout=5)
                else:
                    res = requests.get(target_url, params=data, timeout=5)

                if "error" in res.text.lower() or "syntax" in res.text.lower():
                    vulns.append({"form_action": target_url, "payload": payload, "type": "SQL Injection"})
            except:
                pass
    return vulns

def test_xss(url):
    vulns = []
    forms = get_forms(url)
    for form in forms:
        action = form.get("action")
        method = form.get("method", "get").lower()
        inputs = form.find_all("input")

        for payload in XSS_PAYLOADS:
            data = {}
            for inp in inputs:
                if inp.get("name"):
                    data[inp.get("name")] = payload

            target_url = urljoin(url, action)
            try:
                if method == "post":
                    res = requests.post(target_url, data=data, timeout=5)
                else:
                    res = requests.get(target_url, params=data, timeout=5)

                if payload in res.text:
                    vulns.append({"form_action": target_url, "payload": payload, "type": "XSS"})
            except:
                pass
    return vulns

def analyze_with_gemini(url, html_content):
    """Use Gemini AI to analyze the website for additional vulnerabilities"""
    try:
        model = genai.GenerativeModel('gemini-pro')
        
        prompt = f"""
        Analyze this website for security vulnerabilities. URL: {url}
        HTML Content (partial): {html_content[:2000]}...
        
        Look for:
        1. Common security headers missing
        2. Sensitive information exposure
        3. Outdated libraries/frameworks
        4. CSRF vulnerabilities
        5. Authentication issues
        6. Other OWASP Top 10 vulnerabilities
        
        Return the analysis in JSON format with:
        - vulnerability_type
        - severity (High/Medium/Low)
        - description
        - recommendation
        """
        
        response = model.generate_content(prompt)
        return response.text
    except Exception as e:
        return f"Gemini analysis failed: {str(e)}"

@app.route('/scan', methods=['POST'])
def scan():
    url = request.json.get("url")
    if not url:
        return jsonify({"error": "URL is required"}), 400

    try:
        # Get website content for Gemini analysis
        response = requests.get(url, timeout=10)
        html_content = response.text
        
        # Run traditional scans
        sqli_vulns = test_sqli(url)
        xss_vulns = test_xss(url)
        
        # Run AI analysis
        gemini_analysis = analyze_with_gemini(url, html_content)
        
        result = {
            "url": url,
            "sqli_vulnerabilities": sqli_vulns,
            "xss_vulnerabilities": xss_vulns,
            "ai_analysis": gemini_analysis,
            "scan_status": "completed"
        }
        return jsonify(result)
        
    except Exception as e:
        return jsonify({"error": f"Scan failed: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)