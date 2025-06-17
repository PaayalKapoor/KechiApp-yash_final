async function updateSalonOwnerProfile(req, res) {
  try {
    const { salonId, ...updateData } = req.body;
    if (!salonId) {
      return res.status(400).json({ message: 'Salon ID is required' });
    }
    const updatedSalonOwner = await salonOwnerSigninService.updateSalonOwnerProfile(salonId, updateData);
    res.status(200).json({ message: 'Profile updated successfully', data: updatedSalonOwner });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
}

module.exports = {
  signinSalonOwner,
  googleSignin,
  updateSalonOwnerProfile
}; 