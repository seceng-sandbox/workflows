#!/bin/bash
# Nmap scanning script
# NOTE: Remember to chmod +x this script

# Install packages:
# Nmap is used for running the scan
# xsltproc is used to convert the XML output file into HTML
# wkhtmltopdf is used to convert the HTML file into a PDF
sudo apt update && sudo apt -qq install nmap xsltproc wkhtmltopdf

# Scans targets under /assets/scan-targets.txt in the repo
# Fast scan:
echo -e "--------------------------------\n\033[32mScanning target IPs...\033[0m"
sudo nmap -oA /tmp/scanResults -v0 -sV -sC -sS -Pn -T4 --script vulners --top-ports 20 $(cat ./assets/scan-targets.txt) 
# Fail the script if there are no results found or no IPs were scanned
echo -e "--------------------------------\n\033[32mChecking scan results for failures...\033[0m"
grep "WARNING: No targets were specified, so 0 hosts scanned." /tmp/*scanResults* && exit 2
grep "0 IP addresses (0 hosts up)" /tmp/*scanResults* && exit 3

# Convert the XML output file to HTML
echo -e "--------------------------------\n\033[32mConverting scan output to HTML...\033[0m"
xsltproc /tmp/scanResults.xml -o /tmp/scanResults.html
# Convert the HTML file to a PDF
echo -e "--------------------------------\n\033[32mConverting HTML output to PDFs...\033[0m"
wkhtmltopdf /tmp/scanResults.html /tmp/Nmap_NetworkScan_$(date "+%Y-%m-%d").pdf
echo -e "--------------------------------\n\033[32mSUCCESS:\033[0m Nmap scan complete!"
