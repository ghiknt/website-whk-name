# For compatibility with nanoc
# License: MIT

module ErpetuUtilities
  def listchildren
   returnval = ""
   returnval += "<dl>"
   item.children.each do |child|
    if ! child[:toc].nil? && child[:toc] == "ignore"
      next
    elsif ! child.binary?
     returnval =returnval+
                "<dt><a href=\""+child.identifier+"\">"
     if ! child[:title].nil?
      returnval =returnval+child[:title]
     else
      returnval =returnval+child.identifier
     end
     returnval =returnval+"</a></dt>"
     if ! child[:summary].nil?
      returnval = returnval+"<dd>"+child[:summary] + "</dd>"
     end
    end 
   end
   returnval += "</dl>"
   return returnval
  end
end

