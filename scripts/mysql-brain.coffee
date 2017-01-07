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
        robot.logger.info "hubot-mysql-brain: Initializing new data for brain"
        robot.brain.mergeData {}
      else
        robot.logger.info "hubot-mysql-brain: Data for brain retrieved from Mysql"
        robot.brain.mergeData JSON.parse(rows[0].data.toString())

  conn.connect (err) ->
    if err?
      robot.logger.info "#{tag}: Error\n#{err}"
    else
      robot.logger.info "#{tag}: Connected to MySQL brain (table: #{table})"
      load_data()

  robot.brain.on 'save', (data = {}) ->
    vals = { 'id': 0, 'data': JSON.stringify(data) }
    robot.logger.debug "#{tag}: Saving into database"
    conn.query "INSERT INTO `#{table}` SET ? ON DUPLICATE KEY UPDATE `data` = VALUES(`data`)", vals, (err, result) ->
      if err?
        robot.logger.error "#{tag}: error after save: #{err}"
      return
