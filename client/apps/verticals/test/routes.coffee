routes = require '../routes'
_ = require 'underscore'
Backbone = require 'backbone'
sinon = require 'sinon'
fixtures = require '../../../../test/helpers/fixtures'
User = require '../../../models/user'

describe 'routes', ->

  beforeEach ->
    sinon.stub Backbone, 'sync'
    @req = { query: {}, user: new User(fixtures().users), params: {} }
    @res = { render: sinon.stub(), locals: fixtures().locals }

  afterEach ->
    Backbone.sync.restore()

  describe '#save', ->

    it 'saves the serialized form data to the vertical', ->
      @req.body =
        title: 'Foobar'
        featured_article_ids: ['foo', 'bar', '', '']
      routes.save @req, @res
      Backbone.sync.args[0][1].toJSON().title.should.equal 'Foobar'
      Backbone.sync.args[0][1].toJSON().featured_article_ids.length
        .should.equal 2
      Backbone.sync.args[0][1].toJSON().featured_article_ids.join('')
        .should.equal 'foobar'

  describe '#edit', ->

    it 'renders the edit page', ->
      routes.edit @req, @res
      Backbone.sync.args[0][2].success fixtures().verticals
      @res.render.args[0][0].should.equal 'edit'
      @res.render.args[0][1].vertical.get('id')
        .should.equal '55356a9deca560a0137aa4b7'