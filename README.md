# veyo: Smart Urban Mobility, Emergency Response & Green Rewards for Africa

## Problem Statement
Africa's cities face unique challenges in urban mobility, public transport reliability, rapid emergency response, and environmental sustainability. Commuters need real-time access to public transport, safe and cashless payments, and a way to quickly alert emergency contacts and dispatch services. There is also a need for a platform to support victims of emergencies and to incentivize eco-friendly travel choices.

## Solution Overview
**veyo** is a next-generation Flutter-based mobile app for Africa that:
- Shows real-time availability of public transport (Bus, Matatu, Boda, and more) on a Google Map.
- Lets users book seats and pay instantly via M-Pesa STK Push.
- Enables users to trigger emergency alerts (with a description) to contacts and dispatch via SMS, and stores incidents in Firebase.
- Allows users to donate to support victims, with instant M-Pesa STK Push for donations.
- Rewards users for choosing eco-friendly transport (electric cars, electric bodas, etc.) with green points redeemable for discounts and perks.
- Provides a modern, branded UI with custom icons and images for each transport type.
- Is designed for scalability across all African cities, not just Nairobi.

## What Makes veyo Unique? (Competitive Advantage)
- **Public Transport First**: Unlike Uber, Bolt, or Little, veyo is built around Africa's real public transport (matatus, buses, bodas), not just private cars.
- **Emergency Response Integration**: Instantly alert your loved ones and dispatch services with a description—no other ride app in Africa offers this.
- **Community Support**: Donate directly to victims of emergencies, with transparent, instant M-Pesa payments.
- **Green Rewards**: Earn points for every eco-friendly ride (electric car, boda, or bus) and redeem for discounts or perks—making Africa greener, one trip at a time.
- **Cashless, Inclusive Payments**: Deep M-Pesa integration for instant, secure payments—no credit card required.
- **Pan-African Vision**: veyo is designed for all African cities, with local branding, languages, and transport modes.
- **Open Ecosystem**: Built to integrate with local authorities, transport Saccos, and community organizations.

## Features
- **Public Transport Booking**: View available Buses, Matatus, Bodas, and more. See price, fullness, seats, and departure time. Book and pay via M-Pesa.
- **Emergency Alerts**: Describe your emergency and instantly notify your contacts and dispatch services via SMS. All incidents are logged in Firebase.
- **Victim Support**: Donate to victims by entering your M-Pesa number and amount; receive an STK Push to complete the donation.
- **Green Points & Rewards**: Earn points for every eco-friendly ride. Track your green impact and unlock rewards.
- **Custom Branding**: App icon, name, and images are fully customized for Africa's context.
- **Secure & Scalable**: Uses Firebase Auth, Firestore, and a Node.js backend for M-Pesa and SMS.

## Architecture
- **Frontend**: Flutter (Dart), Google Maps, Firebase Auth, Firestore, HTTP.
- **Backend**: Node.js (Express), M-Pesa Daraja API, Twilio for SMS, CORS enabled for local dev.
- **Payments**: Real M-Pesa STK Push via backend integration.
- **Emergency**: SMS via Twilio, incident storage in Firestore.
- **Green Points**: Points logic in-app and in Firestore, with rewards system.

## Setup & Installation
### Prerequisites
- Flutter SDK (3.x)
- Node.js (18+)
- Firebase project (with Auth & Firestore enabled)
- M-Pesa Daraja API credentials
- Twilio account for SMS

### 1. Clone the Repo
```sh
git clone <your-repo-url>
cd veyo/new_veyo
```

### 2. Flutter App Setup
- Add your Google Maps API key to `.env` and `android/app/src/main/AndroidManifest.xml`.
- Add Firebase config (`google-services.json`) to `android/app/`.
- Run:
```sh
flutter pub get
flutter run
```
- To generate the app icon:
```sh
flutter pub run flutter_launcher_icons:main
```

### 3. Backend Setup
- Go to `mpesa-backend/`.
- Create a `.env` file with:
  - M-Pesa Daraja credentials
  - Twilio credentials
  - Emergency contacts and dispatch number
- Install dependencies:
```sh
npm install
```
- Start the backend:
```sh
node server.js
node emergency.js
```

## Environment Variables
Example `.env` for backend:
```
DARAJA_CONSUMER_KEY=...
DARAJA_CONSUMER_SECRET=...
DARAJA_SHORTCODE=...
DARAJA_PASSKEY=...
DARAJA_CALLBACK_URL=...
TWILIO_ACCOUNT_SID=...
TWILIO_AUTH_TOKEN=...
TWILIO_PHONE_NUMBER=+2547XXXXXXXX
EMERGENCY_CONTACTS=+2547XXXXXXX,+2547YYYYYYY
DISPATCH_NUMBER=+2547ZZZZZZZZ
```

## Usage
- **Book a Ride**: Select a trip option, confirm, enter your M-Pesa number, and approve the STK Push.
- **Send Emergency Alert**: Go to Emergency Assistance, describe your issue, and send. Your contacts and dispatch will be notified by SMS, and the incident is logged.
- **Donate**: Enter amount and your M-Pesa number, receive an STK Push, and complete the donation.
- **Earn Green Points**: Choose electric or eco-friendly rides to earn points and unlock rewards.

## Project Structure
- `lib/` - Flutter app source
- `mpesa-backend/` - Node.js backend for M-Pesa and emergency SMS
- `assets/images/` - App icons and images

## Deployment
- For production, use a public backend URL and production Daraja endpoints.
- Secure your backend endpoints and validate all inputs.

## Contributors
- Zachariah Evans

## License
[MIT ]
