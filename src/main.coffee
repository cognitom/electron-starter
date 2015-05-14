app      = require 'app'
shell    = require 'shell'
request  = require 'request'
path     = require 'path'
Menu     = require 'menu'
Tray     = require 'tray'

CITY_ID    = '1850147'
API_URL    = "http://api.openweathermap.org/data/2.5/weather?id=#{ CITY_ID }"
DETAIL_URL = "http://openweathermap.org/city/#{ CITY_ID }"
INTERVAL   = 1000 * 60 * 10 # 10 min
ICON_RED   = path.join __dirname, 'tray-red.png'
ICON_GRAY  = path.join __dirname, 'tray-gray.png'

createMenu = (desc) ->
  Menu.buildFromTemplate [
    label: "Weather Detail..."
    click: -> shell.openExternal DETAIL_URL
  ,
    type: 'separator'
  ,
    label: 'Quit'
    click: -> app.quit()
  ]

app.on 'ready', ->
  tray = new Tray ICON_GRAY

  checkRaining = ->
    request API_URL, (err, res, body) ->
      unless err
        data = JSON.parse body
        weather = data.weather
        tray.setContextMenu createMenu()
        isRaining = 500 <= weather.id && weather.id < 600
        tray.setImage if isRaining then ICON_RED else ICON_GRAY

  app.dock?.hide()
  checkRaining()
  setInterval checkRaining, INTERVAL
