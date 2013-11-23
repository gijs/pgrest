should = (require \chai).should!
expect = (require \chai).expect

var pgrest, called
describe 'Plugin Handler', ->
  this.timeout 10000ms
  pgrest := require \..
  plugins = [posthook-express-configure: (opts, server) ->
                    called := true
                    opts.should.eq \arg1
                    server.should.eq \arg2
  ]
  beforeEach (done) ->
    called : false
    done!
  describe 'has a function to require plugins', ->  ``it``
    .. 'should catch invalde plugin name', (done) ->
      (-> pgrest.lookup-plugins! <[fs]>)
        .should.throw
      done!
  describe 'has a function to call hooks if plugins provide.', ->  ``it``
    .. 'should catch invalde hook name.', (done) ->
        (-> pgrest.try-invoke! plugins, 'xxxAhook-express-configure')
          .should.throw /^invalid hook/
        done!
    .. 'should be able to pass throw arguments.', (done) ->
        pgrest.try-invoke! plugins, 'posthook-express-configure', 'arg1', 'arg2'
        called.should.be.ok
        done!
