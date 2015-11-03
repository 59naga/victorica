# Dependencies
victorica= require '../src'

# Environment

# Specs
describe 'victorica',->
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

      result= victorica fixture

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

      result= victorica fixture

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

      result= victorica fixture,{space:'\t'}

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

      result= victorica fixture,{ignore:[]}

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

      result= victorica fixture,{removeSelfClose:no}

      expect(result).toBe '<meta charset="UTF-8" />'

  describe 'issues',->
    it '#1',->
      fixture= '<!doctype html><html><head><title>はろわ</title>
      <meta/></head><body><main></main></body></html>'

      result= victorica fixture

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
      expect(victorica '<').toBe '<'
      fixture= '<html><</html>'

      result= victorica fixture

      expect(result).toBe '''
      <html>
        <
      </html>
      '''

    it '#3',->
      brokenCloseTag= ->
        victorica '\n</strong</html>'
      expect(brokenCloseTag).toThrowError Error,'unexpected `strong` close element (line 1)'

    it '#4',->
      fixture= '<span><strong>foo<strong>bar<strong>baz'
      result= victorica fixture

      expect(result).toBe '''
      <span>
      <strong>foo
      <strong>bar
      <strong>baz
      '''

    it '#5',->
      fixture= '''
      <p>
        foo
          bar
            <p>
      '''
      result= victorica fixture

      expect(result).toBe '''
      <p>
        foo
          bar
            <p>
      '''

    it '#6',->
      fixture= '''
      <svg><g>
      <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z"/>
      <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z" />
      <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z"/>
      <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z" />
      <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z"/>
      </g></svg>
      '''
      result= victorica fixture,{removeSelfClose:false}

      expect(result).toBe '''
      <svg>
        <g>
          <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z"/>
          <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z" />
          <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z"/>
          <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z" />
          <path fill="rgba(0,0,0,255)" d="M0,0h10v10h-10Z"/>
        </g>
      </svg>
      '''

    xit 'TODO: element of open implies close',->
      fixture= '''
      <ul><li>foo<li>bar<li>baz</ul>
      '''

      result= victorica fixture,{debug:yes}

      expect(result).toBe '''
      <ul>
        <li>foo
        <li>bar
        <li>baz
      </ul>
      '''
