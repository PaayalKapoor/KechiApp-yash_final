const axios = require('axios');
const config = require('../config');

class OTPService {
  constructor() {
    if (!process.env.MSG91_AUTH_KEY) {
      throw new Error('MSG91_AUTH_KEY is not configured in environment variables');
    }
    if (!process.env.MSG91_TEMPLATE_ID) {
      throw new Error('MSG91_TEMPLATE_ID is not configured in environment variables');
    }
    
    this.authKey = process.env.MSG91_AUTH_KEY;
    this.templateId = process.env.MSG91_TEMPLATE_ID;
    this.baseUrl = 'https://control.msg91.com/api/v5';
  }

  async sendOTP(mobile) {
    try {
      console.log('Sending OTP with auth key:', this.authKey); // Debug log
      const response = await axios.post(
        `${this.baseUrl}/otp`,
        {
          template_id: this.templateId,
          mobile: `91${mobile}`,
          authkey: this.authKey,
          otp_expiry: 5, // OTP expiry in minutes
          otp_length: 4  // Length of OTP
        },
        {
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
        }
      );
      return response.data;
    } catch (error) {
      console.error('Message91 API Error:', {
        status: error.response?.status,
        data: error.response?.data,
        config: {
          url: error.config?.url,
          method: error.config?.method,
          headers: error.config?.headers,
          data: error.config?.data
        }
      });
      throw new Error(`Failed to send OTP: ${error.response?.data?.message || error.message}`);
    }
  }

  async verifyOTP(mobile, otp) {
    try {
      const response = await axios.get(
        `${this.baseUrl}/otp/verify`,
        {
          params: {
            mobile: `91${mobile}`,
            otp: otp,
            authkey: this.authKey
          },
          headers: {
            'Accept': 'application/json'
          }
        }
      );
      return response.data;
    } catch (error) {
      console.error('Message91 API Error:', {
        status: error.response?.status,
        data: error.response?.data,
        config: {
          url: error.config?.url,
          method: error.config?.method,
          headers: error.config?.headers,
          params: error.config?.params
        }
      });
      throw new Error(`Failed to verify OTP: ${error.response?.data?.message || error.message}`);
    }
  }

  async resendOTP(mobile) {
    try {
      const response = await axios.get(
        `${this.baseUrl}/otp/retry`,
        {
          params: {
            mobile: `91${mobile}`,
            authkey: this.authKey
          },
          headers: {
            'Accept': 'application/json'
          }
        }
      );
      return response.data;
    } catch (error) {
      console.error('Message91 API Error:', {
        status: error.response?.status,
        data: error.response?.data,
        config: {
          url: error.config?.url,
          method: error.config?.method,
          headers: error.config?.headers,
          params: error.config?.params
        }
      });
      throw new Error(`Failed to resend OTP: ${error.response?.data?.message || error.message}`);
    }
  }
}

module.exports = new OTPService(); 