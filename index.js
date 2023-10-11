const express = require("express");
const fs = require("fs");
const app = express();

// Middleware to parse request body as text
app.use(express.text());

const { exec } = require("child_process");

app.post("/stylua", (req, res) => {
  const text = req.body;
  fs.writeFile("output.luau", text, (err) => {
    if (err) {
      console.error(err);
      res.status(500).send("Error writing to file");
    } else {
      console.log("Text written to file");
      exec("stylua output.luau", (err, _, stderr) => {
        if (err) {
          console.error(err);
          res.status(500).send(stderr);
        } else {
          console.log("Stylua command executed");
          res.setHeader("Content-Type", "text/plain");
          res.sendFile(__dirname + "/output.luau");
        }
      });
    }
  });
});

app.listen(3000, () => {
  console.log("Server started on port 3000");
});
