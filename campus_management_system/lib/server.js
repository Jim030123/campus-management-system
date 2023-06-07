const express = require('express');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

const app = express();

// API endpoint to fetch all users
app.get('/users', async (req, res) => {
  try {
    const listUsersResult = await admin.auth().listUsers();
    const users = listUsersResult.users.map((userRecord) => ({
      uid: userRecord.uid,
      email: userRecord.email,
      displayName: userRecord.displayName,
      // Add any other user data you want to retrieve
    }));
    res.json(users);
  } catch (error) {
    console.error('Error listing users:', error);
    res.status(500).send('Error listing users');
  }
});

// Start the server
const port = 3000; // Specify the port you want to run your server on
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
