# Dependencies
Utility= (require './utility').Utility

# Public
class Victorica extends Utility
  maxLevel: 100

  beautify: (str,{ignore,space,removeSelfClose,debug}={})=>
    html= ''

    ignore?= @ignores
    space?= '  '
    removeSelfClose?= true
    debug?= false

    if debug
      console.log '\n'
      console.log 'Level, Open, Close, Ignore, Void, Alone, Uplevel'
      console.log 'L O C I V A U -------- chunk --------'

    level= 0
    offset= str.indexOf '<',offset
    content= ''
    while offset > -1
      content= str.slice tag.last,offset if tag?.last

      tag= @parse str,offset,ignore
      unless content[0] is '\n'
        indent= @getIndent level,space
        content= '\n'+indent+content
        indent= @getIndent level-1,space unless tag.open
        content+= '\n'+indent

      level-= 1 unless tag.open?
      if level<0
        line= (str.match /\n/g)?.length ? 0
        throw new Error "unexpected `#{tag.name}` close element (line #{line})"

      chunk= ''
      if content
        indent= @getIndent level,space
        content= content.replace /\n\s*/g,'\n'+indent if content.match /^\n\s*$/

        chunk+= content

      if tag.open
        tag.open= tag.open.replace /( )?\/>/,'>' if tag.closeSelf and removeSelfClose
        chunk+= tag.open

      if tag.content
        chunk+= tag.content

      if tag.close
        chunk+= tag.close

      if debug
        console.log level,
          ~~(tag.open?),~~(tag.close?),~~(tag.ignore?),~~tag.alone,~~tag.void
          ~~(not (tag.close? or tag.alone or tag.void))
          JSON.stringify chunk

      html+= chunk
      level+= 1 unless tag.close? or tag.alone or tag.void
      if level>@maxLevel
        line= (str.match /\n/g)?.length ? 0
        throw new Error "unexpected `#{tag.name}` close element (line #{line})"

      offset= str.indexOf '<',tag.last

    if debug
      console.log 'L O C I V A U -------- chunk --------'
      console.log 'Level, Open, Close, Ignore, Void, Alone, Uplevel'

    return str if html is ''

    html.trim()

module.exports= new Victorica
module.exports.Victorica= Victorica
