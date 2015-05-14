(function() {
  var API_URL, CITY_ID, DETAIL_URL, ICON_GRAY, ICON_RED, INTERVAL, Menu, Tray, app, createMenu, path, request, shell;

  app = require('app');

  shell = require('shell');

  request = require('request');

  path = require('path');

  Menu = require('menu');

  Tray = require('tray');

  CITY_ID = '1850147';

  API_URL = "http://api.openweathermap.org/data/2.5/weather?id=" + CITY_ID;

  DETAIL_URL = "http://openweathermap.org/city/" + CITY_ID;

  INTERVAL = 1000 * 60 * 10;

  ICON_RED = path.join(__dirname, 'tray-red.png');

  ICON_GRAY = path.join(__dirname, 'tray-gray.png');

  createMenu = function(id) {
    return Menu.buildFromTemplate([
      {
        label: "Weather Detail(" + id + ")...",
        click: function() {
          return shell.openExternal(DETAIL_URL);
        }
      }, {
        type: 'separator'
      }, {
        label: 'Quit',
        click: function() {
          return app.quit();
        }
      }
    ]);
  };

  app.on('ready', function() {
    var checkRaining, ref, tray;
    tray = new Tray(ICON_GRAY);
    checkRaining = function() {
      return request(API_URL, function(err, res, body) {
        var data, id, isRaining;
        if (!err) {
          data = JSON.parse(body);
          id = data.weather[0].id - 0;
          isRaining = 500 <= id && id < 600;
          tray.setImage(isRaining ? ICON_RED : ICON_GRAY);
          return tray.setContextMenu(createMenu(id));
        }
      });
    };
    if ((ref = app.dock) != null) {
      ref.hide();
    }
    checkRaining();
    return setInterval(checkRaining, INTERVAL);
  });

}).call(this);
