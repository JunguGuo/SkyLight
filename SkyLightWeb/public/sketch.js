var x, y;
var socket;

var pic;
var w = 480,
  h = 640;
var picWidth = 480,
  picHeight = 640;
//--
var begin;
var end;
var isInit = true;
var cols;
var resolution = 12;
var buttonOSC;
var buttonSent;

function preload() {
  // var skypic = document.getElementById('skypic');
  // skypic.hidden = true;
  pic = loadImage(SKY_URL);
  //console.log(skypic.src);
}

function setup() {
  createCanvas(w, h);
  end = createVector(0, 0);
  pic.resize(picWidth, picHeight);
  setupOsc(12000, 3334);
  // buttonOSC = createButton('setupOSC');
  // buttonOSC.position(170, 230);
  // buttonOSC.mousePressed(
  //   () => {
  //     setupOsc(12000, 3334);
  //   }
  // );

  buttonSent = createButton('sent');
  buttonSent.position(270, 0);
  buttonSent.mousePressed(() => {
    SampleAndSent();
  });
  // put setup code here
  //setupOsc(12000, 3334);

}

function draw() {
  background(0);
  // put drawing code here

  //test osc
  // fill(0, 255, 0);
  // ellipse(x, y, 100, 100);
  // fill(0);
  // text("I'm p5.js", x - 25, y);
  //-----
  image(pic, 0, 0, picWidth, picHeight);
  showDebugColors(cols);
  showSampleStrip();
}



function receiveOsc(address, value) {
  console.log("received OSC: " + address + ", " + value);

  if (address == '/test') {
    x = value[0];
    y = value[1];
  }
}

function sendOsc(address, value) {
  socket.emit('message', [address].concat(value));
}

function setupOsc(oscPortIn, oscPortOut) {
  socket = io();
  socket.on('connect', function() {
    socket.emit('config', {
      server: {
        port: oscPortIn,
        host: '127.0.0.1'
      },
      client: {
        port: oscPortOut,
        host: '127.0.0.1'
      }
    });
  });
  socket.on('message', function(msg) {
    if (msg[0] == '#bundle') {
      for (var i = 2; i < msg.length; i++) {
        receiveOsc(msg[i][0], msg[i].splice(1));
      }
    } else {
      receiveOsc(msg[0], msg.splice(1));
    }
  });
}
//---------pictureapp----------
function keyReleased() {
  if (key == ' ') {
    //myPort.write("12:44:123:34:66:78:123:222:9:1:2:4:12:44:123:34:66:78:123:222:9:1:2:4:12:44:123:34:66:78:123:222:9:1:2:4:\n");

    SampleAndSent();
    //img = loadImage("test2.jpg");

  }
  // if (key == 'm')
  //   movieFeed = true;
}

//----
function mouseDragged() {
  if (isInit) {
    begin = createVector(mouseX, mouseY);
    end = begin.copy();
    isInit = false;
  } else {
    end = createVector(mouseX, mouseY);
  }
  return false;
}

function mouseReleased() {
  isInit = true;
}

function showSampleStrip() {
  if (begin == undefined || end == undefined)
    return;
  strokeCap(ROUND);
  strokeWeight(2);
  stroke(0);
  line(begin.x, begin.y, end.x, end.y);
}
//-----
function SampleAndSent() {
  cols = SampleColor(resolution, pic, true);

  sendOsc('/test', [Colors2String(cols)]);
  // if (!testMode && readySent) {
  //   myPort.write(Colors2var(cols));
  //   readySent = false;
  //   //img = loadImage("test2.jpg");
  // }
}
//-----
function SampleColor(sampleNum, img, useStrip) {
  var colors = [];

  if (!useStrip || begin == undefined || end == undefined) {
    //defualt way to sample

    var padding = 10;
    var validHeight = img.height - padding * 2;
    var step = picHeight / (sampleNum - 1);

    for (var i = 0; i < sampleNum; i++) {
      //console.log(get(img.width / 2, padding + i * step));
      colors.push(get(img.width / 2, padding + i * step));
    }

    //console.log(img);
    return colors;
  } else if (useStrip) {
    //use custom strip to sample
    var step = 1.0 / (sampleNum - 1);
    for (var i = 0; i < sampleNum; i++) {
      var v = p5.Vector.lerp(begin, end, i * step);
      //console.log(v);
      colors.push(img.get(v.x, v.y));
    }
  }

  for (var i = 0; i < colors.length; i++)
    colors[i] = filterColor(colors[i]);
  return colors;
}

function Colors2String(colors) {
  var s = "";
  colorMode(RGB, 255);
  for (var i = 0; i < colors.length; i++) {
    var r = red(cols[i]);
    s += r;
    s += ":";
    var g = green(cols[i]);
    s += g;
    s += ":";
    var b = blue(cols[i]);
    s += b;
    s += ":";
  }
  s += '\n';
  return s;
}

function showDebugColors(colors) {
  //debug show cols
  if (colors == undefined)
    return;
  for (var i = 0; i < colors.length; i++) {
    fill(colors[i]);
    rectMode(CENTER);
    var size = height / resolution;
    rect(0, i * size + size / 2, size, size);
  }
}


function filterColor(c) {
  colorMode(HSB, 255);
  var b = brightness(c);
  var s = saturation(c);
  newC = color(hue(c), s, b);
  colorMode(RGB, 255);
  return color(red(c), green(c), blue(c));
}