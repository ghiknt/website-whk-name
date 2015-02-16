# For compatibility with nanoc
# License: MIT

module ErpetuUtilities
  def listchildren
   returnval = ""
   returnval += "<dl>"

   children = item.children
   sorted = children.sort{ |a, b|
     if ( ! a[:modified].nil? ) 
       a_date = a[:modified]
     else
       a_date = Date.jd(999999999999)
     end

     if ( ! b[:modified].nil? ) 
       b_date = b[:modified]
     else
       b_date = Date.jd(999999999999)
     end

     if (a_date == b_date)
      if ( ! a[:title].nil? ) 
        a_title = a[:title]
      else
        a_title = a.identifier
      end
      if ( ! b[:title].nil? ) 
        b_title = b[:title]
      else
        b_title = b.identifier
      end
      a_title <=> b_title
     else
      # Most recent on top
      b_date <=> a_date
     end

   }
   sorted.each do |child|
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
     returnval =returnval+"</a>"
     if ! child[:modified].nil?
      returnval =returnval+child[:modified].strftime(" (Modified %Y-%m-%d)")
     end
     returnval =returnval+"</dt>"
     if ! child[:summary].nil?
      returnval = returnval+"<dd>"+child[:summary] + "</dd>"
     end
    end 
   end
   returnval += "</dl>"
   return returnval
  end
end

