#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from pathlib import Path
from datetime import datetime, timedelta
from html import escape
import mimetypes, base64
from playwright.sync_api import sync_playwright

# ---------- YOUR DATA ----------

# ---------- PATH TO YOUR LOGO (PNG/JPG/SVG) ----------
LOGO_PATH = "web_routes/logo.png"  # change to your actual file


# ---------- HELPERS ----------
def money(n: float, currency: str = "AED") -> str:
    # Space after currency for readability
    return f"{currency} {float(n):,.2f}"


def logo_data_url(path: Path) -> str:
    """Read the logo file and return a data: URL (base64)."""
    if not path:
        return None
    p = Path(path)
    if not p.exists():
        return None
    mime, _ = mimetypes.guess_type(str(p))
    if not mime:
        mime = "image/png"
    b64 = base64.b64encode(p.read_bytes()).decode("ascii")
    return f"data:{mime};base64,{b64}"


def derived_totals(d: dict):
    items = d["billing_details"]["order_summary"]
    subtotal = sum(float(i.get("total_price", float(i["quantity"]) * float(i["unit_price"]))) for i in items)
    discount = float(d["billing_details"].get("discount", 0.0))
    tax_rate = float(d["billing_details"].get("tax_rate", 0.0))  # e.g., 0.18 for 18%
    tax_total = subtotal * tax_rate
    grand_total = float(d["billing_details"].get("grand_total", subtotal - discount + tax_total))
    balance_due = grand_total - float(d["billing_details"].get("outstanding_balance", 0.0))
    return subtotal, discount, tax_rate, tax_total, grand_total, balance_due


def delivery_window(d: dict) -> str:
    ed = d.get("delivery_details", {}).get("estimated_delivery", {}) or {}
    s, e = ed.get("start_date"), ed.get("end_date")
    return f"{s} – {e}" if s and e else (s or e or "-")


def get_order_id(d: dict) -> str:
    # Use DATA["order_id"] if present; else a fallback
    if "order_id" in d and str(d["order_id"]).strip():
        return str(d["order_id"]).strip()
    # Fallback based on sender + date
    sender = d.get("delivery_details", {}).get("sender", {}).get("name", "INV")
    short = "".join(ch for ch in sender.upper() if ch.isalnum())[:6] or "INV"
    return f"{short}"


# ---------- HTML BUILDERS ----------
def build_html_a4(d: dict, logo_url: str, *, accent_blue="#1F66CC", currency="AED") -> str:
    sender = d["delivery_details"]["sender"]
    bill_to = d["billing_details"]["bill_to"]
    receiver = d["delivery_details"]["receiver"]
    note = d["billing_details"].get("note", "")
    today = datetime.now().date()
    due = today + timedelta(days=7)

    subtotal, discount, tax_rate, tax_total, grand_total, balance_due = derived_totals(d)
    rows = "\n".join(
        f"""
        <tr>
          <td class="desc">{escape(str(i.get('item', '')))}</td>
          <td class="num">{int(i.get('quantity', 0))}</td>
          <td class="num">{money(i.get('unit_price', 0.0), currency)}</td>
          <td class="num">{money(i.get('total_price', 0.0), currency)}</td>
        </tr>"""
        for i in d["billing_details"]["order_summary"]
    )

    logo_block = (
        f'<img src="{logo_url}" alt="logo" style="width:54px;height:54px;border-radius:50%;object-fit:cover;">'
        if logo_url else
        '<div style="width:54px;height:54px;border-radius:50%;background:#888;color:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;">LOGO</div>'
    )

    # A4 layout: Sender details in header; full Bill To + Receiver details (Receiver includes delivery window)
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8"/>
<title>Invoice - {escape(sender['name'])}</title>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<style>
:root{{--blue:{accent_blue};--text:#222;--muted:#666;--line:#E6E6E6; --font:"Calibri","Inter","Helvetica Neue",Arial,sans-serif;}}
*{{box-sizing:border-box;}}
body{{font-family:var(--font);color:var(--text);margin:0;background:#f7f7f7;}}
.page{{width:210mm;min-height:297mm;margin:12mm auto;background:#fff;border-radius:12px;
box-shadow:0 6px 24px rgba(0,0,0,.08);padding:18mm 16mm;}}
.header{{display:flex;justify-content:space-between;align-items:flex-start;gap:24px;margin-bottom:12mm;}}
.company h1{{font-size:24pt;font-weight:600;margin:0;color:var(--blue);}}
.company .small{{font-size:10.5pt;color:var(--muted);}}
.grid{{display:grid;grid-template-columns:1fr 1fr;gap:24px;margin:6mm 0 8mm;}}
.label{{font-size:10.5pt;color:var(--blue);text-transform:uppercase;font-weight:700;margin-bottom:2mm;}}
.box{{border:1px solid var(--line);border-radius:10px;padding:10px;}}
.box .line{{font-size:11pt;line-height:1.45;margin:0;}}
.table{{width:100%;border-collapse:collapse;font-size:11pt;border-radius:10px;overflow:hidden;}}
.table thead th{{background:var(--blue);color:#fff;text-transform:uppercase;font-weight:700;padding:8px;}}
.table td{{padding:8px;border-bottom:1px solid var(--line);}}
.table td.num{{text-align:right;}}
.table td.desc{{width:60%;}}
.totals{{width:50%;margin-left:auto;margin-top:8mm;font-size:11pt;}}
.totals .row{{display:flex;justify-content:space-between;padding:6px 0;border-bottom:1px solid var(--line);}}
.totals .row:last-child{{border-bottom:none;}}
.balance{{font-weight:700;color:var(--blue);font-size:12.5pt;}}
.note{{margin-top:10mm;font-size:10.5pt;color:var(--muted);}}
.footer{{margin-top:10mm;font-size:9.5pt;color:var(--muted);}}
@media print{{ body{{background:#fff;}} .page{{box-shadow:none;margin:0;border-radius:0;}} }}
</style>
</head>
<body>
  <div class="page">
    <div class="header">
      <div class="company">
        <h1>{escape(sender['name'])}</h1>
        <div class="small">{escape(sender['address'])}</div>
        <div class="small">{escape(sender['email'])} · {escape(sender['phone'])}</div>
      </div>
      <div class="dates" style="text-align:right">
        {logo_block}
        <p style="font-size:10.5pt;margin-top:6px">
          <b>Invoice Date:</b> {today.strftime("%d-%b-%Y")}<br/>
          <b>Due Date:</b> {due.strftime("%d-%b-%Y")}
        </p>
      </div>
    </div>

    <div class="grid">
      <div class="box">
        <div class="label">Bill To</div>
        <p class="line"><b>{escape(bill_to['name'])}</b></p>
        <p class="line">{escape(bill_to['address'])}</p>
        <p class="line">{escape(bill_to['email'])} · {escape(bill_to['phone'])}</p>
      </div>
      <div class="box">
        <div class="label">Receiver</div>
        <p class="line"><b>{escape(receiver['name'])}</b></p>
        <p class="line">{escape(receiver['address'])}</p>
        <p class="line">{escape(receiver['email'])} · {escape(receiver['phone'])}</p>
        <p class="line"><b>Estimated Delivery:</b> {escape(delivery_window(d))}</p>
      </div>
    </div>

    <table class="table">
      <thead>
        <tr><th>Description</th><th>Qty</th><th>Unit Price</th><th>Total</th></tr>
      </thead>
      <tbody>
        {rows}
      </tbody>
    </table>

    <div class="totals">
      <div class="row"><span><b>Subtotal</b></span><span>{money(subtotal, currency)}</span></div>
      <div class="row"><span><b>Discount</b></span><span>{money(discount, currency)}</span></div>
      <div class="row"><span><b>Tax Rate</b></span><span>{tax_rate:.0%}</span></div>
      <div class="row"><span><b>Total Tax</b></span><span>{money(tax_total, currency)}</span></div>
      <div class="row"><span class="balance">Balance Due</span><span class="balance">{money(balance_due, currency)}</span></div>
    </div>

    <div class="note"><b>Terms & Instructions:</b> {escape(note)}</div>
    <div class="footer">Thank you for your business.</div>
  </div>
</body>
</html>
"""


def build_html_thermal_80mm(d: dict, logo_url: str, *, currency="AED") -> str:
    """80mm receipt layout with FULL Sender, Bill To, and Receiver details."""
    sender = d["delivery_details"]["sender"]
    bill_to = d["billing_details"]["bill_to"]
    receiver = d["delivery_details"]["receiver"]
    subtotal, discount, tax_rate, tax_total, grand_total, balance_due = derived_totals(d)
    today = datetime.now().strftime("%d-%b-%Y")
    window = delivery_window(d)

    # items: 2-line per product for narrow paper
    item_rows = []
    for i in d["billing_details"]["order_summary"]:
        item_rows.append(
            f"<div class='item'>"
            f"<div class='line1'>{escape(i['item'])}</div>"
            f"<div class='line2'>{int(i['quantity'])} × {money(i['unit_price'], currency)}"
            f"<span class='amt'>{money(i['total_price'], currency)}</span></div></div>"
        )
    items_html = "\n".join(item_rows)
    logo_block = f'<img src="{logo_url}" alt="logo" class="logo"/>' if logo_url else ""

    return f"""<!DOCTYPE html>
<html><head><meta charset="utf-8"/>
<title>Receipt - {escape(sender['name'])}</title>
<style>
@page {{ size: 80mm auto; margin: 0; }}
body {{
  width: 80mm; margin: 0; color:#000; background:#fff;
  font-family: "Arial","Helvetica",sans-serif; font-size: 11.5pt;
}}
.receipt {{ width: 72mm; margin: 0 auto; padding: 4mm 0; }}
.center {{ text-align:center; }}
.logo {{ width: 36mm; height: auto; margin: 0 auto 2mm auto; display:block; }}
.title {{ font-weight:700; font-size: 13pt; }}
.hr {{ border-top: 1px dashed #000; margin: 2mm 0; }}

.block {{ margin: 2mm 0; }}
.block .h {{ font-weight:700; text-transform:uppercase; margin-bottom: 0.5mm; }}
.line {{ display:block; }}
.kv {{ display:flex; justify-content:space-between; gap:6px; }}
.item {{ margin: 1.5mm 0; }}
.item .line1 {{ font-weight:600; }}
.item .line2 {{ font-size: 10.5pt; display:flex; justify-content:space-between; }}
.item .amt {{ font-weight:600; }}
.small {{ font-size:10pt; color:#111; }}
.bold {{ font-weight:700; }}
.big {{ font-size: 13pt; font-weight:700; }}
</style></head>
<body>
  <div class="receipt">
    {logo_block}
    <div class="center title">{escape(sender['name'])}</div>
    <div class="center small">{escape(sender['address'])}</div>
    <div class="center small">Email: {escape(sender['email'])} · Ph: {escape(sender['phone'])}</div>

    <div class="hr"></div>
    <div class="block">
      <div class="h">Bill To</div>
      <span class="line">{escape(bill_to['name'])}</span>
      <span class="line">{escape(bill_to['address'])}</span>
      <span class="line">Email: {escape(bill_to['email'])}</span>
      <span class="line">Phone: {escape(bill_to['phone'])}</span>
    </div>

    <div class="block">
      <div class="h">Receiver</div>
      <span class="line">{escape(receiver['name'])}</span>
      <span class="line">{escape(receiver['address'])}</span>
      <span class="line">Email: {escape(receiver['email'])}</span>
      <span class="line">Phone: {escape(receiver['phone'])}</span>
      <span class="line"><b>Delivery:</b> {escape(window)}</span>
    </div>

    <div class="hr"></div>
    <div class="kv"><div>Date</div><div>{today}</div></div>
    <div class="hr"></div>

    {items_html}

    <div class="hr"></div>
    <div class="kv"><div>Subtotal</div><div>{money(subtotal, currency)}</div></div>
    <div class="kv"><div>Discount</div><div>{money(discount, currency)}</div></div>
    <div class="kv"><div>Tax ({tax_rate:.0%})</div><div>{money(tax_total, currency)}</div></div>
    <div class="kv bold"><div>Total</div><div>{money(grand_total, currency)}</div></div>
    <div class="kv big"><div>Balance Due</div><div>{money(balance_due, currency)}</div></div>

    <div class="hr"></div>
    <div class="center small">Thank you!</div>
  </div>
</body></html>
"""


# ---------- PLAYWRIGHT EXPORT ----------
def export_pdf(html: str, pdf_path: Path, *, width: str = None, height: str = None,
               format: str = None, margin=None, print_background=True):
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()
        page.set_content(html, wait_until="load")
        page.emulate_media(media="print")
        if width and not height:
            full_height_px = page.evaluate("Math.ceil(document.documentElement.scrollHeight)")
            height = f"{full_height_px}px"
        page.pdf(
            path=str(pdf_path),
            print_background=print_background,
            width=width,
            height=height,
            format=format,
            margin=margin or {"top": "0", "right": "0", "bottom": "0", "left": "0"},
            prefer_css_page_size=True
        )
        browser.close()


from pathlib import Path


def create_thermal_invoice_pdf(
        data: dict,
        output_dir: Path = Path("documents"),
        order_id: str = None,
        filename: str = None
) -> Path:
    """
    Builds the thermal (80mm) invoice, writes PDF into `output_dir`,
    deletes the temporary HTML, and returns the final PDF Path.
    """
    # ✅ Fix: remove trailing comma → ensures it's a Path, not tuple
    logo_path: Path = Path("web_routes/logo.png")

    docs_dir = Path(output_dir)
    docs_dir.mkdir(parents=True, exist_ok=True)

    # logo (data URL)
    logo_url = logo_data_url(logo_path)

    # build HTML and write temp file
    if not filename:
        filename = f"invoice_{order_id}"

    html_80 = build_html_thermal_80mm(data, logo_url)
    html_path = docs_dir / f"{filename}.html"
    pdf_path = docs_dir / f"{filename}.pdf"

    html_path.write_text(html_80, encoding="utf-8")

    # export PDF
    export_pdf(
        html_80,
        pdf_path,
        width="80mm",
        margin={"top": "0", "right": "0", "bottom": "0", "left": "0"},
        print_background=True,
    )

    # remove the temp HTML (safe even if already missing)
    try:
        html_path.unlink(missing_ok=True)  # Python 3.8+
    except TypeError:
        if html_path.exists():
            html_path.unlink()

    return pdf_path


def pdf_invoice(DATA, output_dir, filename):
    pdf_path = create_thermal_invoice_pdf(
        data=DATA,
        output_dir=output_dir,
        filename=filename
    )
    print("✅ PDF written:")
    print(f" - {pdf_path}")

    return pdf_path, filename

# if __name__ == "__main__":
#     pdf_invoice()
