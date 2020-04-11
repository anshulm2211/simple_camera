var expess = require("express");
var bodyParser = require("body-parser");
var fs = require("fs");
var app = expess();
var ip= require("ip");



app.use(bodyParser.urlencoded({ extended: true, limit: "50mb" }));
app.post("/image", function(req, res){

  console.log('entered');
  var name = req.body.name;
  var img = req.body.image;
  var realFile = Buffer.from(img,"base64");
  fs.writeFile(name, realFile, function(err) {
      if(err)
         console.log(err);
   });
   res.send(realFile);
   });

app.listen(3000, '0.0.0.0', () => {
	console.log('started');
});