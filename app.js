const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello Akshay Sir, This is Abhishekh an IT DevOps Engineer from Panvel, Raigarh, Maharashtra');
});

app.listen(3000, () => {
    console.log('Node.js app running on port 3000');
});
