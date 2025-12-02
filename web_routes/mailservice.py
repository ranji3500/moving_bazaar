import yagmail ,os
def send_invoice_email(
    to_email,
    subject="Your Invoice from MovingBazaar",
    body_message="Please find your invoice attached.",
    pdf_path="invoice.pdf",
    logo_path="movingbazaar_logo.png"
):
    # Email credentials
    sender_email = "mbsystemuser@gmail.com"
    app_password = "izqs uhon vasc cytq"  # App Password if Gmail 2FA is on

    # Initialize SMTP client
    yag = yagmail.SMTP(sender_email, app_password)

    # Get file names to refer by CID
    logo_filename = os.path.basename(logo_path)

    html_body = f"""
    <html>
      <body style="font-family: 'Segoe UI', sans-serif; margin: 0; padding: 0; background-color: #f6f9fc;">
        <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; margin: 0 auto; background-color: #ffffff; box-shadow: 0 0 10px rgba(0,0,0,0.05);">
          <tr style="background-color: #3f51b5;">
            <td style="text-align: center; padding: 20px;">
              <img src="cid:{logo_filename}" width="100" alt="MovingBazaar Logo" style="display:block; margin: 0 auto 10px;" />
              <h1 style="color: #ffffff; margin: 0;">MovingBazaar</h1>
            </td>
          </tr>
          <tr>
            <td style="padding: 30px;">
              <h2 style="color: #3f51b5;">Invoice Details</h2>
              <p style="color: #555;">Dear Customer,</p>
              <p style="color: #555;">Thank you for your purchase. Your invoice is attached below as a PDF.</p>

              <div style="margin: 20px 0; padding: 20px; background-color: #f0f4ff; border-left: 5px solid #3f51b5;">
                <p><strong>Invoice Number:</strong> #INV123456</p>
                <p><strong>Date:</strong> July 25, 2025</p>
                <p><strong>Total:</strong> ₹2,500.00</p>
              </div>

              <p style="color: #333;">If you have any questions or need assistance, feel free to contact our support team.</p>

              <p style="color: #555;">Regards,<br><strong>MovingBazaar Team</strong></p>
            </td>
          </tr>
          <tr>
            <td style="text-align: center; background-color: #f1f1f1; padding: 15px; font-size: 12px; color: #888;">
              © 2025 MovingBazaar. All rights reserved.
            </td>
          </tr>
        </table>
      </body>
    </html>
    """

    # Send email with attachments (logo + invoice)
    yag.send(
        to=to_email,
        subject=subject,
        contents=[
            yagmail.inline(logo_path),  # Inline image
            html_body,
            pdf_path  # PDF attachment
        ]
    )

    print("✅ Email sent successfully.")

# # 🔧 Call the function
# send_invoice_email(
#     to_email=["ranji3500@gmail.com", "mbsystemuser@gmail.com"]
# )
