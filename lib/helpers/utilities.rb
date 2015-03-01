# For compatibility with nanoc
# License: MIT

module ErpetuUtilities
  def listchildren
   children = item.children.reject{ |i| i[:is_hidden] ||
                                        i.binary?     ||
                                        ( ! i[:toc].nil? && i[:toc] == "ignore")
                                  }
   sorted = children.sort{ |a, b| sortchildren(a,b) }
   returnval = "<dl>"
   sorted.each do |child| 
     returnval += formatitementry(child)
   end
   returnval += "</dl>"
   return returnval
  end

  def recentactivity
   is = @items.select  { |i| ! i[:type].nil? && 
                                 ( i[:type] == "article" ||
                                   i[:type] == "person"  ||
                                   i[:type] == "blog"
                                 ) && ! (
                                   ( ! i[:toc].nil? && i[:toc] == "ignore") ||
                                   i.identifier.match(/^\/drafts\//)
                                 )
                       } 
   sorted = is.sort{ |a, b| sortchildren(a,b) }
   returnval = "<dl>"
   sorted[0..9].each do |child| 
     returnval += formatitementry(child)
   end
   returnval += "</dl>"
   return returnval


  end



  def formatitementry(i) 
    returnval = "<dt><a href=\""+i.identifier+"\">"
    if ! i[:title].nil?
     returnval =returnval+i[:title]
    else
     returnval =returnval+i.identifier
    end
    returnval =returnval+"</a>"
    if ! i[:modified].nil?
     returnval =returnval+i[:modified].strftime(" (Modified %Y-%m-%d)")
    end
    returnval =returnval+"</dt>"
    if ! i[:summary].nil?
     returnval = returnval+"<dd>"+i[:summary] + "</dd>"
    end
     return returnval

  end


  def sortchildren(a,b)
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
  end

end

