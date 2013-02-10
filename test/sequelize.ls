should = (require \chai).should!

expect = (require \chai).expect
var plv8x, conn
describe 'db', -> ``it``
  .. 'loaded successfully.', (done) ->
    # Load home page
    conString = "tcp://localhost/#{ process.env.TESTDBNAME }"
    console.log conString
    plv8x := require \plv8x
    plv8x.should.be.ok
    conn := plv8x.connect conString
    conn.should.be.ok
    done!
  .. 'bootstrap', (done) ->
    <- plv8x.bootstrap conn
    1.should.be.ok
    done!
  .. 'purge', (done) ->
    <- plv8x.purge conn
    done!
  .. 'import', (done) ->
    <- plv8x.import-bundle conn, \LiveScript, './node_modules/LiveScript/package.json'
    <- plv8x.import-bundle conn, \plv8x, './node_modules/plv8x/package.json'
    <- plv8x.import-bundle conn, \sequelize, './node_modules/sequelize/package.json'
    done!
  .. 'test data', (done) ->
    err, res <- conn.query """
    DROP TABLE IF EXISTS pgrest_test;
    CREATE TABLE pgrest_test (
        field text not null,
        value text not null,
        last_update timestamp
    );
    INSERT INTO pgrest_test (field, value, last_update) values('pgrest_version', '0.0.1', NOW());
    """
    expect(err).to.be.a('null');
    done!
  .. 'plv8x_require', (done) ->
    err, res <- conn.query """select plv8x.eval(plv8x.lscompile($1, '{"bare": true}'))::plv8x.json as ret""", ["""
    ``console`` = { log: -> plv8.elog(WARNING, ...arguments) }

    serial = 0
    deferred = []
    ``setTimeout`` = (fn, ms=0) -> deferred.push [fn, ms + (serial++ * 0.001)]

    {STRING, TEXT, DATE, BOOLEAN, INTEGER}:Sequelize = plv8x_require "sequelize"
    sql = new Sequelize null, null, null { dialect: "plv8", -logging }

    SystemModel = do
        field: { type: STRING, +primaryKey }
        value: STRING
        last_update: DATE

    System = sql.define 'pgrest_test' SystemModel, { +freezeTableName }

    rv = null
    do
        (entry) <- System.find('pgrest_version').on "success"
        rv := entry

    doit = (-> return unless deferred.length; deferred.shift!0!; doit!)
    doit!

    JSON.stringify rv
    """]
    expect(err).to.be.a('null');
    {ret} = res.rows.0
    ret = JSON.parse ret
    expect ret?field .to.equal "pgrest_version"
    expect ret?value .to.equal "0.0.1"
    done!
