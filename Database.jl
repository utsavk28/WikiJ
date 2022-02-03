module Database

using MySQL

const HOST = "localhost"
const USER = "root"
const PASS = ""
const DB = "6dwikij"

const CONN = DBInterface.connect(MySQL.Connection, HOST, USER, PASS, db = DB)
export CONN

disconnect() = DBInterface.close!(CONN)
atexit(disconnect)

end