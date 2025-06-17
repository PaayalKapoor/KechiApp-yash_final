const DocumentService = require('../../services/salon-owner/upload-document-services');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });

// Upload a document
exports.uploadDocument = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({
                success: false,
                message: 'No file uploaded'
            });
        }

        const { salonId, documentType } = req.body;
        if (!salonId || !documentType) {
            return res.status(400).json({
                success: false,
                message: 'Salon ID and document type are required'
            });
        }

        // Validate file type and size
        const allowedTypes = ['image/jpeg', 'image/png', 'application/pdf'];
        if (!allowedTypes.includes(req.file.mimetype)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid file type. Only JPEG, PNG and PDF files are allowed'
            });
        }

        const maxSize = 5 * 1024 * 1024; // 5MB
        if (req.file.size > maxSize) {
            return res.status(400).json({
                success: false,
                message: 'File size too large. Maximum size is 5MB'
            });
        }

        // Create custom filename with timestamp to ensure uniqueness
        const timestamp = Date.now();
        const extension = req.file.originalname.split('.').pop();
        const customFilename = `${salonId}-${documentType}.${extension}`;

        const file = await DocumentService.uploadFile(req.file, salonId, documentType, customFilename);

        res.status(200).json({
            success: true,
            message: 'Document uploaded successfully',
            data: {
                filename: customFilename,
                originalName: req.file.originalname,
                salonId,
                documentType,
                uploadDate: file.uploadDate
            }
        });
    } catch (error) {
        console.error('Error uploading document:', error);
        res.status(500).json({
            success: false,
            message: 'Error uploading document',
            error: error.message
        });
    }
};

// Get a document
exports.getDocument = async (req, res) => {
    try {
        const { filename } = req.params;
        if (!filename) {
            return res.status(400).json({
                success: false,
                message: 'Filename is required'
            });
        }

        const file = await DocumentService.getFile(filename);
        if (!file) {
            return res.status(404).json({
                success: false,
                message: 'Document not found'
            });
        }

        const readStream = DocumentService.createReadStream(filename);
        res.set('Content-Type', file.contentType);
        res.set('Content-Disposition', `inline; filename="${file.metadata.originalName}"`);
        readStream.pipe(res);
    } catch (error) {
        console.error('Error retrieving document:', error);
        res.status(500).json({
            success: false,
            message: 'Error retrieving document',
            error: error.message
        });
    }
};

// Delete a document
exports.deleteDocument = async (req, res) => {
    try {
        const { filename } = req.params;
        if (!filename) {
            return res.status(400).json({
                success: false,
                message: 'Filename is required'
            });
        }

        const result = await DocumentService.deleteFile(filename);
        if (!result) {
            return res.status(404).json({
                success: false,
                message: 'Document not found'
            });
        }

        res.status(200).json({
            success: true,
            message: 'Document deleted successfully'
        });
    } catch (error) {
        console.error('Error deleting document:', error);
        res.status(500).json({
            success: false,
            message: 'Error deleting document',
            error: error.message
        });
    }
};

// Get all documents for a salon
exports.getSalonDocuments = async (req, res) => {
    try {
        const { salonId } = req.params;
        if (!salonId) {
            return res.status(400).json({
                success: false,
                message: 'Salon ID is required'
            });
        }

        const files = await DocumentService.getSalonFiles(salonId);
        res.status(200).json({
            success: true,
            data: {
                documents: files.map(file => ({
                    filename: file.filename,
                    originalName: file.metadata.originalName,
                    documentType: file.metadata.documentType,
                    uploadDate: file.uploadDate,
                    size: file.length,
                    contentType: file.contentType
                }))
            }
        });
    } catch (error) {
        console.error('Error retrieving salon documents:', error);
        res.status(500).json({
            success: false,
            message: 'Error retrieving salon documents',
            error: error.message
        });
    }
}; 