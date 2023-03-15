// Tiny module used to connect to the database.
// Uses environment variables set in the pm2.json file to figure
// out which database to connect to. dev branch connects to the test database
// in the mysql container, prod branch connects to the real database hosted
// directly in the EC2 instance. (each branch has its own docker-compose.yml)

const mysql = require('mysql2');

// get environment variables
const MYSQL_HOST_IP_OR_HOSTNAME = process.env.MYSQL_HOST_IP;
const MYSQL_USER = process.env.MYSQL_USER;
const MYSQL_PASSWORD = process.env.MYSQL_PASSWORD;
const MYSQL_PORT = process.env.MYSQL_PORT;
const MYSQL_DATABASE = process.env.MYSQL_DATABASE;
const NODE_ENV = process.env.NODE_ENV;

if (NODE_ENV === "development") {
	const connection = mysql.createPool({
    	host: MYSQL_HOST_IP_OR_HOSTNAME,
    	user: MYSQL_USER,
    	password: MYSQL_PASSWORD,
    	database: MYSQL_DATABASE
	});
}
else if (NODE_ENV === "production") {
	const connection = mysql.createConnection({
    	host: MYSQL_HOST_IP_OR_HOSTNAME,
    	user: MYSQL_USER,
    	port: MYSQL_PORT,
    	database: MYSQL_DATABASE
	});
}
else {
	const connection = null;
	console.error('NODE_ENV environment variable not set properly');
}

connection.connect(function(err) {
    if (err) {
        console.error('Error connecting to database: ' + err.stack);
        return;
    }
    console.log('Connected to database with ID ' + connection.threadId);
});

module.exports = connection;

