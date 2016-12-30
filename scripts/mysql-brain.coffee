# Description:
#   A hubot script to persist hubot's brain using MySQL
#
# Configuration:
#   MYSQL_URL mysql://user:pass@host/db
#   MYSQL_TABLE brain
#
# Commands:
#   None
#
# Author:
#   Akhyar Amarullah <akhyrul@gmail.com>

tag = 'hubot-mysql-brain'
mysql = require 'mysql'

module.exports = (robot) ->
  url = process.env.MYSQL_URL
  table = process.env.MYSQL_TABLE or 'brain'

  conn = mysql.createConnection(url)

  load_data = () ->
    conn.query "SELECT `data` FROM `#{table}` WHERE `id`= 0", (err, rows) ->
      if err or rows.length == 0
        robot.brain.mergeData {}
      else
        robot.brain.mergeData rows[0].data

  conn.connect (err) ->
    if err?
      robot.logger.info "#{tag}: Error\n#{err}"
    else
      robot.logger.info "#{tag}: Connected to MySQL brain (table: #{table})"
      load_data()

  robot.brain.on 'save', (data = {}) ->
    vals = { 'id': 0, 'data': JSON.stringify(data) }
    conn.query "INSERT INTO `#{table}` SET ? ON DUPLICATE KEY UPDATE `data` = VALUES(`data`)", vals, (err, result) ->
      return
