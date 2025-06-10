require('dotenv').config();
const express = require('express');
const axios = require('axios');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const PORT = process.env.PORT || 3000;
const shortCode = "4586772"; // <-- Replace with your M-Pesa Till Number
const passkey = process.env.MPESA_PASSKEY;
const consumerKey = process.env.MPESA_CONSUMER_KEY;
const consumerSecret = process.env.MPESA_CONSUMER_SECRET;
const callbackURL = "https://yourdomain.com/mpesa/callback";

async function getAccessToken() {
  const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString("base64");
  const res = await axios.get(
    "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
    { headers: { Authorization: `Basic ${auth}` } }
  );
  return res.data.access_token;
}

app.post("/api/stkpush", async (req, res) => {
  const { phone, amount } = req.body;
  const timestamp = new Date().toISOString().replace(/[-T:\.Z]/g, '').substring(0, 14);
  const password = Buffer.from(shortCode + passkey + timestamp).toString('base64');

  try {
    const token = await getAccessToken();

    const mpesaRes = await axios.post(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      {
        BusinessShortCode: shortCode,
        Password: password,
        Timestamp: timestamp,
        TransactionType: "CustomerBuyGoodsOnline", // Use this for Till
        Amount: amount,
        PartyA: phone,
        PartyB: shortCode,
        PhoneNumber: phone,
        CallBackURL: callbackURL,
        AccountReference: "RideApp",
        TransactionDesc: "Ride Payment"
      },
      { headers: { Authorization: `Bearer ${token}` } }
    );

    res.status(200).json({ success: true, message: mpesaRes.data.CustomerMessage });
  } catch (err) {
    res.status(500).json({ success: false, error: err.response?.data || err.message });
  }
});

// M-Pesa payment confirmation callback
app.post("/mpesa/callback", async (req, res) => {
  // Safaricom will POST payment result here
  const body = req.body;
  // You can log the callback for debugging
  console.log("M-Pesa Callback:", JSON.stringify(body, null, 2));

  // Example: Check if payment was successful
  const resultCode = body?.Body?.stkCallback?.ResultCode;
  const mpesaReceipt = body?.Body?.stkCallback?.CallbackMetadata?.Item?.find(i => i.Name === 'MpesaReceiptNumber')?.Value;
  const phone = body?.Body?.stkCallback?.CallbackMetadata?.Item?.find(i => i.Name === 'PhoneNumber')?.Value;

  if (resultCode === 0) {
    // Payment successful: update your database here (e.g., Firestore, MongoDB, etc.)
    // Example: Add bonus ride to user with this phone number
    // await addBonusRideToUser(phone, mpesaReceipt);
    console.log(`Payment success for ${phone}, receipt: ${mpesaReceipt}`);
  } else {
    // Payment failed or cancelled
    console.log(`Payment failed or cancelled for ${phone}`);
  }

  // Respond to Safaricom
  res.json({ ResultCode: 0, ResultDesc: "Received" });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
