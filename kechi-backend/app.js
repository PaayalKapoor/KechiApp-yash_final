const app = require('./index');
const winston = require('./winston');
const morgan = require('morgan');
const connectToMongo = require('./connections/connect-db');  

app.use(morgan('combined', { stream: winston.stream }));

const PORT = 3000;

connectToMongo()
  .then(() => {
    app.listen(PORT, '0.0.0.0', (err) => {
      if (err) throw err;
      console.log(`Server running at http://202.177.235.116:${PORT}`);
    });
  })
  .catch((error) => {
    console.error('Failed to connect to MongoDB:', error);
    process.exit(1); 
  });
