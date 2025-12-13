from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, Image
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_LEFT, TA_RIGHT
from reportlab.lib.units import inch
import os

def generate_invoice(data, filename="styled_invoice.pdf", logo_path=None):
    doc = SimpleDocTemplate(filename, pagesize=A4, rightMargin=40, leftMargin=40, topMargin=40, bottomMargin=30)
    elements = []

    styles = getSampleStyleSheet()
    styles.add(ParagraphStyle(name='RightAlign', alignment=TA_RIGHT, fontSize=10))
    styles.add(ParagraphStyle(name='LeftAlign', alignment=TA_LEFT, fontSize=10))
    styles.add(ParagraphStyle(name='Bold', fontSize=10, leading=12, spaceAfter=4, fontName='Helvetica-Bold'))
    styles.add(ParagraphStyle(name='SectionTitle', fontSize=10, fontName='Helvetica-Bold', backColor=colors.lightgrey, spaceAfter=6, leftIndent=2))

    # === Logo Section ===
    logo_table_data = []
    if logo_path and os.path.exists(logo_path):
        logo = Image(logo_path, width=40, height=20)
        logo_table_data.append([logo, Paragraph("<b>moving bazaar</b>", styles['Bold'])])
    else:
        logo_table_data.append(["", Paragraph("<b>moving bazaar</b>", styles['Bold'])])

    logo_table = Table(logo_table_data, colWidths=[50, 400])
    logo_table.setStyle(TableStyle([('VALIGN', (0, 0), (-1, -1), 'MIDDLE')]))
    elements.append(logo_table)
    elements.append(Spacer(1, 12))

    # === Estimated Delivery ===
    est = data["delivery_details"]["estimated_delivery"]
    elements.append(Paragraph("Estimated Delivery", styles['SectionTitle']))
    elements.append(Paragraph(f"{est['start_date']} - {est['end_date']}", styles['LeftAlign']))
    elements.append(Spacer(1, 10))

    # === Sender & Receiver Boxes ===
    def build_address_block(title, info):
        return [
            Paragraph(f"<b>{title}</b>", styles['Bold']),
            Paragraph(f"<b>{info['name']}</b>", styles['LeftAlign']),
            Paragraph(info['address'], styles['LeftAlign']),
            Paragraph(info['email'], styles['LeftAlign']),
            Paragraph(info['phone'], styles['LeftAlign']),
        ]

    sender = build_address_block("Sender", data["delivery_details"]["sender"])
    receiver = build_address_block("Receiver", data["delivery_details"]["receiver"])

    info_table = Table([[sender, receiver]], colWidths=[250, 250])
    info_table.setStyle(TableStyle([('BOX', (0, 0), (-1, -1), 0.75, colors.black),
                                    ('VALIGN', (0, 0), (-1, -1), 'TOP'),
                                    ('TOPPADDING', (0, 0), (-1, -1), 6),
                                    ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                                    ('LEFTPADDING', (0, 0), (-1, -1), 6),
                                    ('RIGHTPADDING', (0, 0), (-1, -1), 6)]))
    elements.append(info_table)
    elements.append(Spacer(1, 10))

    # === Bill To Box ===
    bill_to = build_address_block("Bill to", data["billing_details"]["bill_to"])
    bill_table = Table([[bill_to]], colWidths=[500])
    bill_table.setStyle(TableStyle([('BOX', (0, 0), (-1, -1), 0.75, colors.black),
                                    ('TOPPADDING', (0, 0), (-1, -1), 6),
                                    ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
                                    ('LEFTPADDING', (0, 0), (-1, -1), 6),
                                    ('RIGHTPADDING', (0, 0), (-1, -1), 6)]))
    elements.append(bill_table)
    elements.append(Spacer(1, 10))

    # === Order Summary ===
    order_data = [[Paragraph("Order summary", styles['Bold']), ""]]

    for item in data["billing_details"]["order_summary"]:
        line = f"{item['item']} ({item['quantity']}x AED {item['unit_price']})"
        total = f"AED {item['total_price']}"
        order_data.append([Paragraph(line, styles['LeftAlign']),
                           Paragraph(total, styles['RightAlign'])])

    # Totals
    order_data.append(["", ""])
    order_data.append([Paragraph("<b>Total</b>", styles['LeftAlign']),
                       Paragraph(f"<b>AED {data['billing_details']['total']}</b>", styles['RightAlign'])])

    order_table = Table(order_data, colWidths=[400, 100])
    order_table.setStyle(TableStyle([('TOPPADDING', (0, 0), (-1, -1), 4),
                                     ('BOTTOMPADDING', (0, 0), (-1, -1), 4)]))
    elements.append(order_table)

    # Build PDF
    doc.build(elements)
    return filename


# invoice_data = {
#         "billing_details": {
#             "bill_to": {
#                 "address": "21, Linking Road, Bandra, Mumbai",
#                 "email": "spice.junction@exampljue.com",
#                 "name": "Spice Junction",
#                 "phone": "87654321"
#             },
#             "grand_total": 41960,
#             "note": "Amount to be paid by the Sender - Spice Junction",
#             "order_summary": [
#                 {
#                     "item": "Kids Bicycle",
#                     "quantity": 2,
#                     "total_price": 10400,
#                     "unit_price": 5100
#                 },
#                 {
#                     "item": "Kids Bicycle",
#                     "quantity": 2,
#                     "total_price": 10400,
#                     "unit_price": 5100
#                 },
#                 {
#                     "item": "Kids Bicycle",
#                     "quantity": 2,
#                     "total_price": 10400,
#                     "unit_price": 5100
#                 },
#                 {
#                     "item": "Kids Bicycle",
#                     "quantity": 2,
#                     "total_price": 10400,
#                     "unit_price": 5100
#                 },
#                 {
#                     "item": "Vegetables",
#                     "quantity": 2,
#                     "total_price": 90,
#                     "unit_price": 45
#                 },
#                 {
#                     "item": "Vegetables",
#                     "quantity": 2,
#                     "total_price": 90,
#                     "unit_price": 45
#                 },
#                 {
#                     "item": "Vegetables",
#                     "quantity": 2,
#                     "total_price": 90,
#                     "unit_price": 45
#                 },
#                 {
#                     "item": "Vegetables",
#                     "quantity": 2,
#                     "total_price": 90,
#                     "unit_price": 45
#                 }
#             ],
#             "outstanding_balance": 0,
#             "total": 41960
#         },
#         "delivery_details": {
#             "estimated_delivery": {
#                 "end_date": "May 31",
#                 "start_date": "May 29"
#             },
#             "receiver": {
#                 "address": "123 Street, Area A, New York",
#                 "email": "vignesh@example.com",
#                 "name": "Vignesh Store",
#                 "phone": "12345678"
#             },
#             "sender": {
#                 "address": "21, Linking Road, Bandra, Mumbai",
#                 "email": "spice.junction@exampljue.com",
#                 "name": "Spice Junction",
#                 "phone": "87654321"
#             }
#         }
#     }

# pdf_path = generate_invoice(invoice_data,"my.pdf")
# print(f"Invoice generated: {pdf_path}")
