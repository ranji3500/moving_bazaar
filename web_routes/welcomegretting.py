

import os
import smtplib
import mimetypes
from email.message import EmailMessage
from email.utils import make_msgid


def send_welcome_email(receiver_email, user_name="User"):
    sender_email = "mbsystemuser@gmail.com"
    app_password = "izqs uhon vasc cytq"

    signin_url = "https://www.movingbazaar.in/login"  # Replace with real login link
    logo_cid = make_msgid(domain="movingbazaar.com")[1:-1]

    html_body = f"""
    <html>
      <body style="margin: 0; padding: 0; background-color: #f9f9f9; font-family: 'Segoe UI', sans-serif;">
        <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; margin: 30px auto; background-color: #ffffff; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

          <!-- Logo -->
          <tr>
            <td style="padding: 20px 30px;">
              <img src="cid:{logo_cid}" alt="MovingBazaar Logo" width="130" style="display: block;" />
            </td>
          </tr>

          <!-- Welcome Text -->
          <tr>
            <td style="padding: 10px 30px; text-align: center;">
              <h1 style="font-size: 26px; color: #333; margin-bottom: 10px;">Hi {user_name}!</h1>
              <h2 style="font-size: 22px; color: #3f51b5; margin-top: 0;">Welcome to MovingBazaar.</h2>
              <p style="font-size: 16px; color: #555; margin-top: 15px;">
                Your account has been registered successfully.
              </p>
              <p style="font-size: 15px; color: #555; margin: 20px 0 0;">
                Click the button below to sign in and get started.
              </p>
            </td>
          </tr>

          <!-- Button -->
          <tr>
            <td style="padding: 20px; text-align: center;">
              <a href="{signin_url}" target="_blank" style="
                display: inline-block;
                padding: 14px 28px;
                background-color: #3f51b5;
                color: #fff;
                font-size: 16px;
                font-weight: bold;
                text-decoration: none;
                border-radius: 6px;">
                Sign In to Your Account
              </a>
              <p style="font-size: 14px; margin-top: 15px; color: #666;">
                Or click this <a href="{signin_url}" style="color: #3f51b5; text-decoration: underline;">link</a>.
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="text-align: center; padding: 20px; background-color: #f1f1f1; font-size: 13px; color: #555;">
              If you have questions or received this in error, please 
              <a href="mailto:mbsystemuser@gmail.com" style="color: #3f51b5; text-decoration: underline;">contact us</a>.<br>
              © 2025 MovingBazaar. All rights reserved.
            </td>
          </tr>

        </table>
      </body>
    </html>
    """

    msg = EmailMessage()
    msg["Subject"] = "Welcome to MovingBazaar – Account Created"
    msg["From"] = sender_email
    msg["To"] = receiver_email
    msg.set_content("Please view this email in an HTML-compatible viewer.")
    msg.add_alternative(html_body, subtype="html")

    # Attach the logo
    logo_path = os.path.abspath("web_routes/movingbazaar_logo.png")
    if os.path.exists(logo_path):
        with open(logo_path, "rb") as img:
            mime_type, _ = mimetypes.guess_type(logo_path)
            if mime_type:
                maintype, subtype = mime_type.split("/")
            else:
                maintype, subtype = "image", "png"  # fallback
            msg.get_payload()[1].add_related(
                img.read(),
                maintype=maintype,
                subtype=subtype,
                cid=f"<{logo_cid}>"
            )
    else:
        print("⚠️ Logo not found, sending email without logo.")

    # Send email
    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
            smtp.login(sender_email, app_password)
            smtp.send_message(msg)
            print(f"✅ Welcome email sent to {receiver_email}")
    except Exception as e:
        print(f"❌ Failed to send email: {e}")
