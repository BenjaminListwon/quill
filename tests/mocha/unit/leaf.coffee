describe('Leaf', ->
  beforeEach( ->
    @container = $('#test-container').html('').get(0)
  )

  describe('isLeafNode', ->
    tests =
      'text node':
        html: 'Test'
        expected: false
      'empty element':
        html: '<b></b>'
        expected: true
      'break':
        html: '<br>'
        expected: true
      'element with element child':
        html: '<b><i></i></b>'
        expected: false
      'element with text child':
        html: '<b>Test</b>'
        expected: true

    _.each(tests, (test, name) ->
      it(name, ->
        @container.innerHTML = test.html
        expect(Quill.Leaf.isLeafNode(@container.firstChild)).to.be(test.expected)
      )
    )
  )

  describe('insertText', ->
    tests =
      'element with text node':
        initial:  '<b>Test</b>'
        expected: '<b>Te|st</b>'
        text: 'Test'
      'element without text node':
        initial:  '<b></b>'
        expected: '<b>|</b>'
      'break':
        initial:  '<br>'
        expected: '<span>|</span>'

    _.each(tests, (test, name) ->
      it(name, ->
        @container.innerHTML = test.initial
        leaf = new Quill.Leaf(@container.firstChild, {})
        text = test.text or ''
        length = text.length
        expect(leaf.text).to.equal(text)
        expect(leaf.length).to.equal(length)
        leaf.insertText(length/2, '|')
        expect.equalHTML(leaf.node.outerHTML, test.expected)
        expect(leaf.text).to.equal(leaf.node.innerHTML)
        expect(leaf.length).to.equal(length + 1)
      )
    )
  )
)
