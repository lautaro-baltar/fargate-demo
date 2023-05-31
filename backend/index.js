const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors')

const app = express();
const port = 8000;

// Enable CORS for all routes
app.use(cors());

// Middleware to parse JSON bodies
app.use(express.json());

// MongoDB connection URI
const mongoURI = process.env.MONGO_URI;

// MongoDB authentication credentials
const username = process.env.MONGO_USERNAME;
const password = process.env.MONGO_PASSWORD;

// Get all users
app.get('/api/users', async (req, res) => {
  try {
    
    // Connect to MongoDB with authentication
    const client = new MongoClient(mongoURI);
    await client.connect();  

    // Access the database and collection
    const db = client.db('mydb');
    const usersCollection = db.collection('users');

    // Retrieve all users
    const users = await usersCollection.find().toArray();

    // Send the response
    res.json(users);
  } catch (error) {
    console.error('Error retrieving users:', error);
    res.status(500).json({ message: 'Error retrieving users' });
  } finally {
    // Close the MongoDB connection
    client.close();
  }
});

// Create a new user
app.post('/api/users', async (req, res) => {
  const { username, email } = req.body;

  try {
    // Connect to MongoDB
    const client = new MongoClient(mongoURI);
    await client.connect();

    // Access the database and collection
    const db = client.db('mydb');
    const usersCollection = db.collection('users');

    // Insert the new user
    const result = await usersCollection.insertOne({ username, email });

    // Send the response
    res.status(201).json({ message: 'User created', userId: result.insertedId });
  } catch (error) {
    console.error('Error creating user:', error);
    res.status(500).json({ message: 'Error creating user' });
  } finally {
    // Close the MongoDB connection
    client.close();
  }
});

// Health check endpoint
app.get('/api/health', async (req, res) => {
  try {
    // Connect to MongoDB with authentication
    const client = new MongoClient(mongoURI);
    await client.connect();

    // Access the database and collection
    const db = client.db('mydb');
    const usersCollection = db.collection('users');

    // Perform a simple query to retrieve a document
    const user = await usersCollection.findOne();

    // Close the MongoDB connection
    client.close();

    // Send the response
    if (user) {
      res.status(200).json({ status: 'OK' });
    } else {
      res.status(500).json({ status: 'Error', message: 'API or MongoDB connection issue' });
    }
  } catch (error) {
    console.error('Error checking health:', error);
    res.status(500).json({ status: 'Error', message: 'API or MongoDB connection issue' });
  }
});

// Calculate the fibonacci number for a given index
app.get('/api/fibo/:number', (req, res) => {
  const number = parseInt(req.params.number);

  function fibonacci(n) {
    if (n <= 1) {
      return n;
    } else {
      return fibonacci(n - 1) + fibonacci(n - 2);
    }
  }

  const result = fibonacci(number);

  res.json({ number, result });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
