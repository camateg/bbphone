var app = require('express')(),
    http = require('http').Server(app),
    request = require('request'),
    io = require('socket.io')(http),
    serialport = require("serialport"),
    SerialPort = serialport.SerialPort;

var sp = new SerialPort("/dev/ttyACM0", {parser: serialport.parsers.readline("\n")});

var numAccum = '';
var hookState = 1;

sp.on('open', function(){
  sp.flush();
  console.log('Serial Port Opened');
  sp.on('data', function(data){
     var dataJson = JSON.parse(data) || {};

     console.log(data);

     io.emit('data_ready', dataJson);

     if ((dataJson['type'] == 'hook_event') && (dataJson['status'] == '0')) {
       hookState = 1;
     } 
     
     if ((dataJson['type'] == 'hook_event') && (dataJson['status'] == '1')) {
       hookState = 0;
       numAccum = '';
     }

     if ((hookState == 1) && (dataJson['type'] == 'dial_event')) {
       numAccum = numAccum.concat(dataJson['status']);
     }

     if (numAccum.length >= 4) {
       var phJson = {};
       phJson['type'] = 'num_event';
       phJson['status'] = numAccum;

       var phText = '';

       for(s in numAccum) {
         phText += ' ' + numAccum[s];
       } 

       request.post({url:'http://localhost:4567/call', form: {message: 'You dialed' + phText, priority: 'low'}});

       io.emit('data_ready', phJson);
       numAccum = ''; 
     }
  });
});

app.get('/', function(req,res) {
   res.sendfile('./index.html');
}); 

app.get('/hook', function(req,res) {
   res.send({status:hookState});
});

io.on('connection', function(socket){
  console.log('a user connected');
});

io.on('data_ready', function(socket) {
  console.log('hi');
});


http.listen(3000, function(){
  console.log('listening on *:3000');
});
