#!/usr/bin/env python3
import urllib.request
import re
import sys
import os

themes = [
    "tokyo-night", "catppuccin", "lumon", "ethereal", "everforest",
    "gruvbox", "miasma", "hackerman", "osaka-jade", "kanagawa",
    "nord", "matte-black", "vantablack", "ristretto", "retro-82",
    "flexoki-light", "rose-pine", "catppuccin-latte", "white"
]

name_mapping = {
    "tokyo-night": "Tokyo Night",
    "catppuccin": "Catppuccin",
    "lumon": "Lumon",
    "ethereal": "Ethereal",
    "everforest": "Everforest",
    "gruvbox": "Gruvbox",
    "miasma": "Miasma",
    "hackerman": "Hackerman",
    "osaka-jade": "Osaka Jade",
    "kanagawa": "Kanagawa",
    "nord": "Nord",
    "matte-black": "Matte Black",
    "vantablack": "Vantablack",
    "ristretto": "Ristretto",
    "retro-82": "Retro 82",
    "flexoki-light": "Flexoki Light",
    "rose-pine": "Rose Pine",
    "catppuccin-latte": "Catppuccin Latte",
    "white": "White"
}

def fetch_theme(theme_name):
    url = f"https://raw.githubusercontent.com/basecamp/omarchy/master/themes/{theme_name}/colors.toml"
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req) as response:
            return response.read().decode('utf-8')
    except Exception as e:
        print(f"Failed to fetch {theme_name}: {e}", file=sys.stderr)
        return None

def parse_colors(content):
    colors = {}
    for line in content.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        match = re.match(r'^([\w\d_]+)\s*=\s*[\'"]?([#\w\d_.-]+)[\'"]?', line)
        if match:
            colors[match.group(1)] = match.group(2)
    return colors

def main():
    print("Fetching Omarchy themes from GitHub...")
    generated_calls = []
    
    for t in themes:
        content = fetch_theme(t)
        if not content:
            continue
        
        c = parse_colors(content)
        
        # Verify required keys
        required_keys = ["background", "foreground"] + [f"color{i}" for i in range(16)]
        missing = [k for k in required_keys if k not in c]
        if missing:
            print(f"Warning: Theme {t} is missing keys: {missing}", file=sys.stderr)
            # Fill missing keys with defaults
            for m in missing:
                c[m] = "#000000" if "background" in m or "color0" in m else "#ffffff"
        
        name = name_mapping.get(t, t.capitalize())
        bg = c["background"]
        fg = c["foreground"]
        
        # Mapping: generate_theme NAME BG FG C0 C8 C1 C9 C2 C10 C3 C11 C4 C12 C5 C13 C6 C14 C7 C15
        call = (
            f'generate_theme "{name}" "{bg}" "{fg}" '
            f'"{c["color0"]}" "{c["color8"]}" "{c["color1"]}" "{c["color9"]}" '
            f'"{c["color2"]}" "{c["color10"]}" "{c["color3"]}" "{c["color11"]}" '
            f'"{c["color4"]}" "{c["color12"]}" "{c["color5"]}" "{c["color13"]}" '
            f'"{c["color6"]}" "{c["color14"]}" "{c["color7"]}" "{c["color15"]}"'
        )
        generated_calls.append(call)
        print(f"Parsed theme: {name}")

    if not generated_calls:
        print("No themes fetched successfully. Exiting.", file=sys.stderr)
        sys.exit(1)

    # Append to generate_themes.sh
    script_path = "generate_themes.sh"
    if not os.path.exists(script_path):
        script_path = os.path.join(os.path.dirname(__file__), "generate_themes.sh")
        
    with open(script_path, "r") as f:
        script_content = f.read()

    # Check if we already appended them to avoid duplicates
    header_comment = "\n# --- Omarchy Default Themes (Auto-Generated) ---"
    if header_comment in script_content:
        # Strip everything after header_comment to refresh
        script_content = script_content.split(header_comment)[0]
        
    new_content = script_content + header_comment + "\n" + "\n".join(generated_calls) + "\n"
    
    with open(script_path, "w") as f:
        f.write(new_content)
        
    print(f"Successfully appended {len(generated_calls)} Omarchy themes to generate_themes.sh")

if __name__ == "__main__":
    main()
