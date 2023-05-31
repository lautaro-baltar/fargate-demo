import React, { useState, useEffect } from 'react';
import axios from 'axios';

import 'bootstrap/dist/css/bootstrap.min.css';

const App = () => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [users, setUsers] = useState([]);

  const [emailError, setEmailError] = useState('');

  const client = axios.create({
    baseURL: process.env.REACT_APP_BACKEND_URL,
  });

  // Function to create a new user
  const createUser = async () => {
    if (!username) {
      alert('Username is required');
      return;
    }

    if (!email) {
      alert('Email is required');
      return;
    }

    if (!validateEmail(email)) {
      setEmailError('Please enter a valid email');
      return;
    }

    try {
      await client.post('/users', { username, email });
      alert('User created successfully!');
      setUsername('');
      setEmail('');
      setEmailError('');
    } catch (error) {
      console.error('Error creating user:', error);
      alert('Error creating user');
    }
  };

  // Function to get all users
  const getUsers = async () => {
    try {
      const response = await client.get('/users');
      setUsers(response.data);
    } catch (error) {
      console.error('Error getting users:', error);
      alert('Error getting users');
    }
  };

  // Fetch users on initial component mount
  useEffect(() => {
    getUsers();
  }, []);

  // Email validation helper function
  const validateEmail = (email) => {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  };

  return (
    <div className="container">
      <h1>Create User</h1>
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Username"
          value={username}
          onChange={(e) => setUsername(e.target.value)}
        />
      </div>
      <div className="mb-3">
        <input
          type="email"
          className={`form-control ${emailError && 'is-invalid'}`}
          placeholder="Email"
          value={email}
          onChange={(e) => {
            setEmail(e.target.value);
            setEmailError('');
          }}
        />
        {emailError && <div className="invalid-feedback">{emailError}</div>}
      </div>
      <button className="btn btn-primary mb-3" onClick={createUser}>
        Create User
      </button>

      <h1>Users</h1>
      <button className="btn btn-primary mb-3" onClick={getUsers}>
        Get Users
      </button>
      {users.length === 0 ? (
        <p>No users created</p>
      ) : (
        <ul className="list-group">
          {users.map((user) => (
            <li className="list-group-item" key={user.userId}>
              {`${user.username} - ${user.email}`}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default App;
