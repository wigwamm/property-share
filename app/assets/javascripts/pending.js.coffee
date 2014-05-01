$ = jQuery

dotDotDot = (target, speed) -> 
  dotCount = 1
  dot = () ->
    dotCount = 1 if dotCount % 50 == 0
    $(target).text( Array(dotCount+1).join('.') )
    dotCount += 1
    return true
  setInterval dot, speed

dotDotDot('div.processing_image .dot', 1000)

