const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');
const Document = require('../../models/salon-owner/document');

class DocumentService {
    static #gfs = null;

    static initialize(connection) {
        if (!connection) {
            throw new Error('Database connection is required');
        }
        DocumentService.#gfs = new GridFSBucket(connection.db, {
            bucketName: 'documents'
        });
    }

    static async uploadFile(file, salonId, documentType, customFilename) {
        if (!DocumentService.#gfs) {
            throw new Error('GridFS not initialized');
        }

        if (!file || !file.buffer) {
            throw new Error('Invalid file object');
        }

        if (!salonId || !documentType || !customFilename) {
            throw new Error('Missing required parameters: salonId, documentType, or customFilename');
        }

        return new Promise((resolve, reject) => {
            const uploadStream = DocumentService.#gfs.openUploadStream(customFilename, {
                contentType: file.mimetype,
                metadata: {
                    salonId,
                    documentType,
                    originalName: file.originalname
                }
            });

            uploadStream.on('error', (error) => {
                console.error('Upload stream error:', error);
                reject(new Error('File upload failed'));
            });

            uploadStream.on('finish', async () => {
                try {
                    // Get the complete file information from GridFS using filename
                    const gridFSFile = await mongoose.connection.db.collection('documents.files').findOne({ 
                        filename: customFilename 
                    });

                    const doc = new Document({
                        filename: customFilename,
                        originalName: file.originalname,
                        contentType: file.mimetype,
                        length: gridFSFile ? gridFSFile.length : file.size || file.buffer.length,
                        uploadDate: new Date(),
                        metadata: {
                            salonId,
                            documentType
                        }
                    });
                    await doc.save();
                    resolve(doc);
                } catch (error) {
                    console.error('Document save error:', error);
                    reject(new Error('Failed to save document metadata'));
                }
            });

            uploadStream.end(file.buffer);
        });
    }

    static async getFile(filename) {
        if (!DocumentService.#gfs) {
            throw new Error('GridFS not initialized');
        }
        if (!filename) {
            throw new Error('Filename is required');
        }
        return mongoose.connection.db.collection('documents.files').findOne({ filename });
    }

    static async deleteFile(filename) {
        if (!DocumentService.#gfs) {
            throw new Error('GridFS not initialized');
        }
        if (!filename) {
            throw new Error('Filename is required');
        }

        const file = await mongoose.connection.db.collection('documents.files').findOne({ filename });
        if (!file) {
            return null;
        }

        await DocumentService.#gfs.delete(file._id);
        await Document.deleteOne({ filename });
        return file;
    }

    static async getSalonFiles(salonId) {
        if (!DocumentService.#gfs) {
            throw new Error('GridFS not initialized');
        }
        if (!salonId) {
            throw new Error('Salon ID is required');
        }

        return mongoose.connection.db.collection('documents.files')
            .find({ 'metadata.salonId': salonId })
            .toArray();
    }

    static createReadStream(filename) {
        if (!DocumentService.#gfs) {
            throw new Error('GridFS not initialized');
        }
        if (!filename) {
            throw new Error('Filename is required');
        }

        return DocumentService.#gfs.openDownloadStreamByName(filename);
    }
}

// Initialize GridFS when mongoose connects
mongoose.connection.once('open', () => {
    DocumentService.initialize(mongoose.connection);
});

module.exports = DocumentService;



