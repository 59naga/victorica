# Dependencies
victorica= require '../src'

# Environment

# Specs
describe 'victorica',->
  describe '.beautify',->
    describe 'default',->
      it 'no touch',->
        fixture= '''
        <pre>
          hyper
            text
            <!-- comment -->
              markup
                language
        </pre>
        '''

        result= victorica.beautify fixture

        expect(result).toBe '''
        <pre>
          hyper
            text
            <!-- comment -->
              markup
                language
        </pre>
        '''

      it 'mixin',->
        fixture= '''
        <!DOCTYPE html><html>
        <head><meta charset="UTF-8" />
        <title>日本語</title><script>
          console.log("<dont touch this>")
        </script><style>/*ignore me*/</style></head>
        <body><pre>foo bar baz</pre><div>
          <span><strong>Lorem</strong> <em>ipsum</em> dolor sit amet.</span>
          <pre>  dont touch
          this.  </pre>
        </div><!--this
         is
          comment -->
        </body>
        </html>
        '''

        result= victorica.beautify fixture

        expect(result).toBe '''
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <title>日本語</title>
            <script>
          console.log("<dont touch this>")
        </script>
            <style>/*ignore me*/</style>
          </head>
          <body>
            <pre>foo bar baz</pre>
            <div>
              <span><strong>Lorem</strong> <em>ipsum</em> dolor sit amet.</span>
              <pre>  dont touch
          this.  </pre>
            </div>
            <!--this
         is
          comment -->
          </body>
        </html>
        '''

    describe 'use options',->
      it "options.space='\\t'",->
        fixture= '<!DOCTYPE html><html lang="en"><head></head></html>'

        result= victorica.beautify fixture,{space:'\t'}

        expect(result).toBe '''
        <!DOCTYPE html>
        <html lang="en">
        \t<head></head>
        </html>
        '''

      it 'options.ignore=[]',->
        fixture= '''
        <!DOCTYPE html><html>
        <head><meta charset="UTF-8" />
        <title>日本語</title><script>
          console.log("dont touch this")
        </script><style>/*ignore me*/</style></head>
        <body ui-view><pre>foo bar baz</pre><div>
          <span><strong>Lorem</strong> <em>ipsum</em> dolor sit amet.</span>
          <pre>  dont touch
          this.  </pre>
        </div><!--this
         is
          comment -->
        </body>
        </html>
        '''

        result= victorica.beautify fixture,{ignore:[]}

        expect(result).toBe '''
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <title>日本語</title>
            <script>
          console.log("dont touch this")
        </script>
            <style>/*ignore me*/</style>
          </head>
          <body ui-view>
            <pre>foo bar baz</pre>
            <div>
              <span>
                <strong>Lorem</strong>
                <em>ipsum</em>
                 dolor sit amet.
              </span>
              <pre>  dont touch
          this.  </pre>
            </div>
            <!--this
         is
          comment -->
          </body>
        </html>
        '''

      it 'options.removeSelfClose=false',->
        fixture= '<meta charset="UTF-8" />'

        result= victorica.beautify fixture,{removeSelfClose:no}

        expect(result).toBe '<meta charset="UTF-8" />'

    describe 'issues',->
      it '#1',->
        fixture= '<!doctype html><html><head><title>はろわ</title>
        <meta/></head><body><main></main></body></html>'

        result= victorica.beautify fixture

        expect(result).toBe '''
        <!doctype html>
        <html>
          <head>
            <title>はろわ</title>
            <meta>
          </head>
          <body>
            <main></main>
          </body>
        </html>
        '''

      it '#2',->
        expect(victorica.beautify '<').toBe '<'
        fixture= '<html><</html>'

        result= victorica.beautify fixture

        expect(result).toBe '''
        <html>
          <
        </html>
        '''

      it '#3',->
        brokenCloseTag= ->
          victorica.beautify '\n</strong</html>'
        expect(brokenCloseTag).toThrowError Error,'unexpected `strong` close element (line 1)'

      xit 'TODO: element of open implies close',->
        fixture= '''
        <ul><li>foo<li>bar<li>baz</ul>
        '''

        result= victorica.beautify fixture,{debug:yes}

        expect(result).toBe '''
        <ul>
          <li>foo
          <li>bar
          <li>baz
        </ul>
        '''
