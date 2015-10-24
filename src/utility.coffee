class Utility
  ignores: [
    'script'
    'style'
    'title'

    # https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elemente
    'a'
    'abbr'
    'acronym'
    'b'
    'bdo'
    'big'
    'button'
    'cite'
    'code'
    'dfn'
    'em'
    'i'
    'img'
    'kbd'
    'label'
    'map'
    'object'
    'pre'
    'q'
    'samp'
    'small'
    'span'
    'strong'
    'sub'
    'sup'
    'textarea'
    'tt'
    'var'
  ]

  voids: [
    '!doctype'

    # http://www.w3.org/TR/2011/WD-html-markup-20110113/syntax.html#void-element
    'area'
    'base'
    'br'
    'col'
    'command'
    'embed'
    'hr'
    'img'
    'input'
    'keygen'
    'link'
    'meta'
    'param'
    'source'
    'track'
    'wbr'
  ]

  # To determine the appearance by the name of element
  # Doesn't handle the innerHTML If comment or name exists ignoreList
  parse: (str,offset,ignores=[])->
    left= str.indexOf '<',offset
    right= (str.indexOf '>',left)+1

    tag= str.slice left,right
    if tag[1] isnt '/'
      open= tag
    else
      close= tag

    nameLeft= 1
    nameRight= tag.indexOf ' '
    nameRight= tag.length-1 if nameRight is -1
    name= (tag.slice nameLeft,nameRight)?.toLowerCase() or ''
    name= name.slice 1 if name[0] is '/'

    if (str.slice offset,offset+4) is '<!--'
      name= 'comment'
      open= '<!--'
      close= '-->'

      begin= offset+4
      end= str.indexOf close,begin

      content= str.slice begin,end
      last= end+close.length
      return {name,open,content,close,last,alone:yes,void:no,ignore:yes}

    last= right

    isClose= tag[1] is '/'
    isSelfClose= (tag.match /\/>$/)?
    isOpen= not (isClose or isSelfClose)
    isVoid= name in @voids

    # treated as alone. To disable the indentation(for level)
    if name in ignores
      close= '</'+name+'>'

      begin= str.indexOf '>',offset
      end= str.indexOf close,begin

      content= str.slice begin+1,end
      last= end+close.length
      return {name,open,content,close,last,alone:yes,void:isVoid,ignore:yes}

    alone= isVoid
    if isOpen
      alone= (str.indexOf '</'+name+'>',right) is (str.indexOf '<',right)

      # Skip innerHTML formatting
      if alone
        content= str.slice right,(str.indexOf '<',right)
        close= '</'+name+'>'
        last= (str.indexOf '<',right)+close.length

    return {name,open,content,close,last,alone,void:isVoid,ignore:no,closeSelf:isSelfClose}

  getIndent: (repeat,space='  ')->
    repeat= 0 unless repeat>-1
    (new Array repeat+1).join space

module.exports= new Utility
module.exports.Utility= Utility
