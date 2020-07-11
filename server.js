// Initial Checks
const isEnvVarEmpty = function(key) {
  const value = process.env[key];

  if(typeof value === 'undefined' || value == '') {
    console.error(`Missing key: ${key}` )
    return true;
  }

  return false
}

const areAnyEnvVarsMissing = function() {
  return false;
}

if(areAnyEnvVarsMissing()) {
  console.error("Please fill in all values in your .env file first.");
  process.exit(1);
}

//

const
  fs = require('fs'),
  http = require('http'),
  port = process.env.PORT;

const readFile = function(path) {
  return new Promise(function(resolve, reject) {
    fs.readFile(path, 'utf8', function(err, contents) {
      if(err) {
        reject(err);
      } else {
        resolve(contents);
      }
    })
  });
}

const getIndexBody = function(variables) {
  let template = `
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" type="text/css" href="src/app.css" />
      </head>

      <body>
        <div id="outlet"></div>

        <script src="src/app.js"></script>

        <script type="text/javascript">
          // Look! I'm client-side JavaScript in server-side JavaScript!
          var node = document.getElementById('outlet');
          var app = 'PasswordGenerator';

          if(typeof Elm === 'object' && Elm[app] && Elm[app].init) {
            Elm[app].init({
              node: node,
              flags: {
              }
            });
          } else {
            node.innerHTML = 'Compilation failed. See errors on your command line.';
          }
        </script>
      </body>
    </html>
  `

  Object.keys(variables).forEach(function(key) {
    template = template.replace(key, variables[key]);
  });

  return template;
};

http.createServer(async function (req, res) {
  if(req.url == '/') {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.write(getIndexBody({
    }));
    res.end();
  } else {
    const
      filepath = `.${req.url}`;

    await readFile(filepath)
      .then(function(contents) {
        res.write(contents);
        res.end();
      })
      .catch(function(err) {
        console.log(err);

        res.writeHead(404);
        res.write(err.toString());
        res.end();
      })
  }
}).listen(port);

console.log(`Server listening on port ${port}`);
