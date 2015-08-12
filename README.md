# hubot-mysql-brain
 A hubot script to persist hubot's brain using MySQL

 See [`scripts/mysql-brain.coffee`](scripts/movie.coffee) for full documentation.

 ## Installation

 1. In hubot project repo, run:

 ```
 npm install hubot-mysql-brain --save
 ```

 2. Then add **hubot-mysql-brain** to your `external-scripts.json`:

   ```json
   [
     "hubot-mysql-brain"
   ]
   ```

 3. Create your database schema

   ```
   CREATE TABLE `brain` (
     `id` INT,
     `data` TEXT,
     PRIMARY KEY (`id`)
     )
   ```

## Configurations

- **MYSQL_URL** : e.g. `mysql://user:pass@host/db_name`
- **MYSQL_TABLE** : default to `brain`
