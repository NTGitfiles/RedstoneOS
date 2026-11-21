#!/usr/bin/env python3
from pathlib import Path
import math
out=Path(__file__).resolve().parent.parent/"output"/"branding"
out.mkdir(parents=True,exist_ok=True)
palettes=[
("circuit-core","#0b1420","#172c3b","#f04b3e","#ffb078","#f7eee8"),
("deepslate","#10151d","#27323d","#d9473d","#ff9d73","#f4eee8"),
("redstone-sunset","#25182b","#813c46","#ff624b","#ffc17c","#fff0e4"),
("blueprint","#081b2b","#123c50","#f15a4b","#7dd3d7","#eff8f5"),
("nether-glow","#1b1018","#46202b","#ff493e","#ff9b58","#fff0df"),
("obsidian","#080b12","#252433","#e84b4b","#b98cff","#f4efff"),
("redstone-rain","#101923","#263c4a","#ff5949","#9bd5d1","#f1f7f4"),
("copper-circuit","#171a20","#3b3430","#e86b48","#e9b17b","#fff0df"),
("ember-grid","#1c1116","#43202a","#ff503e","#ffb15f","#fff0e8"),
("frost-signal","#0c1a25","#24404c","#e65a52","#a5e2e5","#effaff"),
("redstone-forest","#0d1a19","#243b32","#ee5141","#a8d28c","#f0f5e9"),
("midnight-pulse","#090e1d","#202746","#ff5149","#8c9cff","#f1f1ff"),
("lava-lamp","#211018","#4a2028","#ff563b","#ffc16c","#fff0dc"),
("signal-wave","#0b1822","#17404b","#ef5549","#65c9c4","#e9f7f4"),
("redstone-dawn","#251c2b","#5b3544","#f15a4a","#ffd09a","#fff4e9"),
("iron-ember","#171b20","#3a4249","#ed5145","#d5a17d","#f5f0e9"),
("crimson-orbit","#130f20","#34213e","#ff514e","#d08cff","#fff0f4"),
("charged-stone","#10171b","#2d3c3c","#f45143","#b2d99a","#f1f6ec"),
("pixel-night","#080d17","#1d2638","#f04e46","#ffb16b","#f5f0eb"),
("redstone-horizon","#151522","#423044","#f85a49","#f5b17a","#fff0e8")]
for i,(name,bg,mid,red,accent,fg) in enumerate(palettes,1):
 pts=[(170+j*277,980+int(150*math.sin(i*.41+j*.82))) for j in range(9)]
 path="M"+" L".join(f"{x},{y}" for x,y in pts)
 nodes="".join(f'<rect x="{x-22}" y="{y-22}" width="44" height="44" fill="{accent}"/>' for x,y in pts[1:-1])
 svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="2560" height="1440" viewBox="0 0 2560 1440">
<defs><linearGradient id="bg" x2="1" y2="1"><stop stop-color="{bg}"/><stop offset="1" stop-color="{mid}"/></linearGradient><radialGradient id="glow"><stop stop-color="{red}" stop-opacity=".36"/><stop offset="1" stop-color="{red}" stop-opacity="0"/></radialGradient><pattern id="grid" width="96" height="96" patternUnits="userSpaceOnUse"><path d="M96 0H0V96" fill="none" stroke="{accent}" stroke-opacity=".13" stroke-width="3"/></pattern></defs>
<rect width="2560" height="1440" fill="url(#bg)"/><rect width="2560" height="1440" fill="url(#grid)"/><ellipse cx="1280" cy="650" rx="1050" ry="690" fill="url(#glow)"/>
<path d="{path}" fill="none" stroke="{red}" stroke-width="36" opacity=".4"/><path d="{path}" fill="none" stroke="{red}" stroke-width="11"/>{nodes}
<g transform="translate(1280 600)"><path d="M0-255 225-125 0 5-225-125Z" fill="{accent}" stroke="{fg}" stroke-opacity=".6" stroke-width="7"/><path d="M-225-125 0 5V260L-225 130Z" fill="{red}"/><path d="M225-125 0 5V260L225 130Z" fill="{mid}"/><path d="M0-60 70-20V65L0 105-70 65V-20Z" fill="{bg}" stroke="{accent}" stroke-width="8"/><path d="M0-30 40-8V38L0 60-40 38V-8Z" fill="{red}"/></g>
<g font-family="DejaVu Sans Mono,monospace" text-anchor="middle"><text x="1280" y="1260" font-size="88" font-weight="bold" textLength="1040" lengthAdjust="spacingAndGlyphs" fill="{fg}">REDSTONE OS</text><text x="1280" y="1320" font-size="25" letter-spacing="11" fill="{accent}">POWERED BY REDSTONE</text></g></svg>'''
 (out/f"redstone-wallpaper-{i:02d}-{name}.svg").write_text(svg,encoding="utf-8")
print("Generated 20 measured-title wallpaper SVGs.")
