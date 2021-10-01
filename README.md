# Audit_Win
1. Install auditbeat (for windows, x64). Please refer to the official site;
2. Create a new folder `auditbeat` in the install dir;
3. Copy `auditbeat.yml` and override the former one;
4. Change the field `beat_path` in `config.ps1` to your install dir of auditbeat;
5. Launch powershell (in Admin mode!) and run the script `config.ps1`
