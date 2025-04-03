# stripe_payment_demo

Sample Flutter project.

## Getting Started

Stripe Payment Integration on Flutter

Here are the common Stripe payment flows based on how the intent is created:

Token Flow – Create a payment token (tok_...) in the frontend and send it to the backend to create a charge. (Deprecated for newer integrations, but still used in some cases)

Payment Intent Flow – The frontend creates a PaymentIntent using Stripe.js or mobile SDK, then confirms it either client-side or server-side.
