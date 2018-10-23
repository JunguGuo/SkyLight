const express = require('express');
const multer = require('multer');
const ejs = require('ejs');
const path = require('path');
const fs = require('fs');
// Set The Storage Engine
const storage = multer.diskStorage({
  destination: './public/uploads/',
  filename: function(req, file, cb) {
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  }
});

// Init Upload
const upload = multer({
  storage: storage,
  // limits: {
  //   fileSize: 1000000
  // },
  fileFilter: function(req, file, cb) {
    checkFileType(file, cb);
  }
}).single('myImage');

// Check File Type
function checkFileType(file, cb) {
  // Allowed ext
  const filetypes = /jpeg|jpg|png|gif/;
  // Check ext
  const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
  // Check mime
  const mimetype = filetypes.test(file.mimetype);

  if (mimetype && extname) {
    return cb(null, true);
  } else {
    cb('Error: Images Only!');
  }
}

// Init app
const app = express();
var http = require('http').Server(app);
// EJS
app.set('view engine', 'ejs');

// Public Folder    './public'
app.use(express.static('./public'));


const testFolder = './public/uploads/';
//fix this: endswith g


app.get('/', (req, res) => {
  var skyImages = [];
  fs.readdirSync(testFolder).filter(file => file.endsWith("g")).forEach(file => {
    console.log(file);
    //fix this: maybe not the best way to get filename?
    skyImages.push(`uploads/${file.toString()}`);
  })
  console.log(skyImages);
  res.render('index', {
    files: skyImages
  });
});
app.post('/upload', (req, res) => {
  upload(req, res, (err) => {
    if (err) {
      res.render('index', {
        msg: err
      });
    } else {
      if (req.file == undefined) {
        res.render('index', {
          msg: 'Error: No File Selected!'
        });
      } else {
        res.render('index2', {
          msg: 'File Uploaded!',
          file: `uploads/${req.file.filename}`
        });

      }
    }
  });
});

const port = 3000;

http.listen(port, () => console.log(`Server started on port ${port}`));

//------osc--------
var osc = require('node-osc');
var io = require('socket.io')(http);


var oscServer, oscClient;

var isConnected = false;

io.sockets.on('connection', function(socket) {
  console.log('connection');
  socket.on("config", function(obj) {
    isConnected = true;
    oscServer = new osc.Server(obj.server.port, obj.server.host);
    oscClient = new osc.Client(obj.client.host, obj.client.port);
    oscClient.send('/status', socket.sessionId + ' connected');
    oscServer.on('message', function(msg, rinfo) {
      socket.emit("message", msg);
    });
    socket.emit("connected", 1);
  });
  socket.on("message", function(obj) {
    oscClient.send.apply(oscClient, obj);
  });
  socket.on('disconnect', function() {
    if (isConnected) {
      oscServer.kill();
      oscClient.kill();
    }
  });
});