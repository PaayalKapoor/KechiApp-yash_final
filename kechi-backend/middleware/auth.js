const jwt = require('jsonwebtoken');
const SalonOwner = require('../models/salon-owner/user');
const { jwtSecret } = require('../config'); 

const auth = async (req, res, next) => {
    try {
        const token = req.header('Authorization')?.replace('Bearer ', '');
        console.log('Received Token:', token);

        if (!token) {
            throw new Error('No authentication token provided');
        }

        const decoded = jwt.verify(token, jwtSecret); // <-- Using jwtSecret from config
        console.log('Decoded Token Payload:', decoded);

        const salonOwner = await SalonOwner.findOne({ _id: decoded.id }); // <- use decoded.id not _id

        if (!salonOwner) {
            throw new Error('User not found');
        }

        req.token = token;
        req.salonOwner = salonOwner;
        next();
    } catch (error) {
        console.error('Auth Middleware Error:', error.message);
        res.status(401).json({ error: 'Please authenticate' });
    }
};

module.exports = auth;
