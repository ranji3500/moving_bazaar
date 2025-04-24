from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm

# File name
file_name = "billing_invoice.pdf"

# Create canvas
c = canvas.Canvas(file_name, pagesize=A4)
width, height = A4  # Width: 210mm, Height: 297mm

# Helper for positioning
def draw_text(c, x_mm, y_mm, text, size=10, bold=False):
    c.setFont("Helvetica-Bold" if bold else "Helvetica", size)
    c.drawString(x_mm * mm, y_mm * mm, text)

# Header
draw_text(c, 20, 280, "Moving Bazaar", size=16, bold=True)

# Estimated Delivery
draw_text(c, 20, 265, "Estimated Delivery", bold=True)
draw_text(c, 20, 260, "Jan 27 - Jan 28")

# Sender and Receiver
draw_text(c, 20, 245, "Sender", bold=True)
sender_info = [
    "AA Seller",
    "Apartment 506, Blue Wave Tower",
    "Al Barsha 1, Sheikh Zayed Road Dubai, UAE",
    "Sample@gmail.com",
    "971(4)2255112"
]
for i, line in enumerate(sender_info):
    draw_text(c, 20, 240 - i*5, line)

draw_text(c, 110, 245, "Receiver", bold=True)
receiver_info = [
    "BB Seller"
] + sender_info[1:]
for i, line in enumerate(receiver_info):
    draw_text(c, 110, 240 - i*5, line)

# Billing Info
draw_text(c, 20, 200, "Bill to", bold=True)
for i, line in enumerate(sender_info):
    draw_text(c, 20, 195 - i*5, line)

# Order Summary
draw_text(c, 20, 160, "Order summary", bold=True)
items = [
    ("Vegetables (2x AED 21)", "AED 42"),
    ("Groceries (1x AED 30)", "AED 30"),
    ("Others (1x AED 30)", "AED 30")
]
for i, (desc, amount) in enumerate(items):
    draw_text(c, 20, 155 - i*5, desc)
    draw_text(c, 160, 155 - i*5, amount)

# Totals
draw_text(c, 20, 135, "Total", bold=True)
draw_text(c, 160, 135, "AED 102")
draw_text(c, 20, 130, "Outstanding balance", bold=True)
draw_text(c, 160, 130, "AED 10")
draw_text(c, 20, 125, "Grand Total", bold=True)
draw_text(c, 160, 125, "AED 112")

# Note
draw_text(c, 20, 115, "Amount to be paid by", size=9)
draw_text(c, 20, 110, "the Sender - AA Seller", size=9)

# Thank you
draw_text(c, 80, 90, "Thank you!", size=14, bold=True)

# Save
c.save()
print("PDF generated:", file_name)
