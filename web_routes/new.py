import smtplib
import random
from email.message import EmailMessage
from email.utils import make_msgid
import mimetypes


def send_registration_email(receiver_email,otp):
    sender_email = "mbsystemuser@gmail.com"
    app_password = "izqs uhon vasc cytq"

    logo_cid = make_msgid(domain='movingbazaar.com')[1:-1]

    html_body = f"""
    <html>
      <body style="margin: 0; padding: 0; background-color: #f6f9fc; font-family: 'Segoe UI', sans-serif;">
        <table width="100%" cellpadding="0" cellspacing="0" style="max-width: 600px; margin: 20px auto; background-color: #ffffff; box-shadow: 0 2px 8px rgba(0,0,0,0.1); border-radius: 6px; overflow: hidden;">

          <!-- Logo Row -->
          <tr>
            <td style="padding: 15px 20px;">
              <img src="cid:{logo_cid}" alt="MovingBazaar Logo" width="120" style="display: block;" />
            </td>
          </tr>

          <!-- Banner Row -->
          <tr>
            <td style="background-color: #3f51b5; padding: 20px; text-align: center;">
              <h2 style="margin: 0; color: #ffffff; font-size: 20px;">MovingBazaar Verification Code</h2>
            </td>
          </tr>

          <!-- Message Content -->
          <tr>
            <td style="padding: 30px;">
              <p style="font-size: 16px; color: #333;">Dear Customer,</p>
              <p style="font-size: 15px; color: #555;">
                Thank you for registering with MovingBazaar. Please use the following One-Time Password (OTP) to complete your signup process:
              </p>

              <div style="margin: 20px 0; padding: 20px; background-color: #f0f4ff; border-left: 4px solid #3f51b5; font-size: 18px;">
                <strong>Your OTP is:</strong> {otp}
              </div>

              <p style="color: #555;">This OTP is valid for a limited time. Please do not share it with anyone.</p>

              <p style="margin-top: 30px; color: #555;">
                Regards,<br><strong>MovingBazaar Team</strong>
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="text-align: center; background-color: #f1f1f1; padding: 12px; font-size: 12px; color: #888;">
              © 2025 MovingBazaar. All rights reserved.
            </td>
          </tr>

        </table>
      </body>
    </html>
    """

    msg = EmailMessage()
    msg['Subject'] = "Your MovingBazaar OTP Code"
    msg['From'] = sender_email
    msg['To'] = receiver_email
    msg.set_content("Please use an HTML-compatible email viewer to see this message.")
    msg.add_alternative(html_body, subtype='html')

    # Attach logo (uploaded earlier)
    logo_path = r"D:\today26\moving_bazaar-main\web_routes\movingbazaar_logo.png"
    try:
        with open(logo_path, 'rb') as img:
            maintype, subtype = mimetypes.guess_type(logo_path)[0].split('/')
            msg.get_payload()[1].add_related(img.read(), maintype=maintype, subtype=subtype, cid=logo_cid)
    except FileNotFoundError:
        print("⚠️ Logo file not found. Email will be sent without logo.")

    # Send email
    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login(sender_email, app_password)
            smtp.send_message(msg)
            print(f"✅ OTP email sent to {receiver_email}")
            return otp
    except Exception as e:
        print(f"❌ Failed to send email: {e}")
        return None


# Example usage
if __name__ == "__main__":
    user_email = "ranji3500@gmail.com"
    otp = send_registration_email(user_email)
    if otp:
        print(f"Generated OTP: {otp}")
