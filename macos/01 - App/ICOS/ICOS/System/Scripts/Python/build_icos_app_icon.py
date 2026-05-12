#!/usr/bin/env python3
"""Build a macOS-ready ICOS app icon PNG from a square source image."""

from __future__ import annotations

import pathlib
import sys

from PIL import Image, ImageChops, ImageDraw

CANVAS = 1024
INNER = 824
OFFSET = (CANVAS - INNER) // 2
RADIUS = 185
SUPERSAMPLE = 4
GRADIENT_TOP_LIFT = 0.06
GRADIENT_BOTTOM_DARKEN = 0.06
HIGHLIGHT_HEIGHT_FRAC = 0.20
HIGHLIGHT_PEAK_ALPHA = 38
SHADOW_HEIGHT_FRAC = 0.10
SHADOW_PEAK_ALPHA = 28


def make_squircle_mask(size: int) -> Image.Image:
    big = size * SUPERSAMPLE
    mask = Image.new("L", (big, big), 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, big - 1, big - 1),
        radius=RADIUS * SUPERSAMPLE,
        fill=255,
    )
    return mask.resize((size, size), Image.LANCZOS)


def vertical_l_column(height: int, alpha_at_y) -> Image.Image:
    column = Image.new("L", (1, height))
    pixels = column.load()
    for y in range(height):
        t = y / (height - 1) if height > 1 else 0.0
        pixels[0, y] = max(0, min(255, int(round(alpha_at_y(t)))))
    return column


def main(src_path: pathlib.Path, out_path: pathlib.Path) -> None:
    if not src_path.exists():
        print(f"Source not found: {src_path}", file=sys.stderr)
        sys.exit(1)

    source = Image.open(src_path).convert("RGBA").resize((INNER, INNER), Image.LANCZOS)
    squircle_mask = make_squircle_mask(INNER)

    def gradient_value(t: float) -> float:
        delta = GRADIENT_TOP_LIFT - (GRADIENT_TOP_LIFT + GRADIENT_BOTTOM_DARKEN) * t
        return 255 * (1.0 + delta)

    gradient = vertical_l_column(INNER, gradient_value).resize((INNER, INNER))
    gradient_rgb = Image.merge("RGB", (gradient, gradient, gradient))
    lit = ImageChops.multiply(source.convert("RGB"), gradient_rgb).convert("RGBA")
    lit.putalpha(source.getchannel("A"))

    highlight_height = int(INNER * HIGHLIGHT_HEIGHT_FRAC)

    def highlight_alpha_at(t: float) -> float:
        y = t * (INNER - 1)
        if y >= highlight_height:
            return 0.0
        local_t = y / (highlight_height - 1) if highlight_height > 1 else 0.0
        return HIGHLIGHT_PEAK_ALPHA * (1 - local_t) ** 1.5

    highlight = Image.new("RGBA", (INNER, INNER), (255, 255, 255, 0))
    highlight.putalpha(vertical_l_column(INNER, highlight_alpha_at).resize((INNER, INNER)))

    shadow_height = int(INNER * SHADOW_HEIGHT_FRAC)
    shadow_start = INNER - shadow_height

    def shadow_alpha_at(t: float) -> float:
        y = t * (INNER - 1)
        if y < shadow_start:
            return 0.0
        local_t = (y - shadow_start) / (shadow_height - 1) if shadow_height > 1 else 0.0
        return SHADOW_PEAK_ALPHA * (local_t ** 1.2)

    shadow = Image.new("RGBA", (INNER, INNER), (0, 0, 0, 0))
    shadow.putalpha(vertical_l_column(INNER, shadow_alpha_at).resize((INNER, INNER)))

    stack = Image.new("RGBA", (INNER, INNER), (0, 0, 0, 0))
    stack.alpha_composite(lit)
    stack.alpha_composite(highlight)
    stack.alpha_composite(shadow)

    clipped = Image.new("RGBA", (INNER, INNER), (0, 0, 0, 0))
    clipped.paste(stack, (0, 0), squircle_mask)

    canvas = Image.new("RGBA", (CANVAS, CANVAS), (0, 0, 0, 0))
    canvas.paste(clipped, (OFFSET, OFFSET), clipped)

    out_path.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out_path, format="PNG", optimize=True)
    print(f"Wrote {out_path} ({out_path.stat().st_size // 1024} KB)")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: build_icos_app_icon.py SOURCE_PNG OUTPUT_PNG", file=sys.stderr)
        sys.exit(2)

    main(pathlib.Path(sys.argv[1]).expanduser(), pathlib.Path(sys.argv[2]).expanduser())
