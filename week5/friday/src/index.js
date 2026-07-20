const express = require('express');

const app = express();
app.use(express.json());

// Simple in-memory payment record for demo purposes
const payments = [];

function sum(a, b) {
    return a + b;
}

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'ok' });
});

app.post('/payments', (req, res) => {
    const { amount, currency } = req.body;

    if (typeof amount !== 'number' || amount <= 0) {
        return res.status(400).json({ error: 'amount must be a positive number' });
    }
    if (!currency) {
        return res.status(400).json({ error: 'currency is required' });
    }

    const payment = {
        id: payments.length + 1,
        amount,
        currency,
        createdAt: new Date().toISOString()
    };

    payments.push(payment);
    res.status(201).json(payment);
});

app.get('/payments/:id', (req, res) => {
    const payment = payments.find(p => p.id === parseInt(req.params.id, 10));
    if (!payment) {
        return res.status(404).json({ error: 'payment not found' });
    }
    res.status(200).json(payment);
});

const PORT = process.env.PORT || 3000;
if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`kijanikiosk-payments listening on port ${PORT}`);
    });
}

module.exports = { app, sum };