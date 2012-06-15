require "xml"
require "rexml/document"

module TaskUtilities

	def cmd_line(str)
		puts str
		puts `#{str}`
	end

	def start_line(msg)
		puts "=== #{msg}"
		puts "=============================================================================="
		return Time.now
	end

	def finish_line(start_time)
		duration = Time.now-start_time
		if duration >= 60
			str = "Finished in #{"%.2f" % (duration/60)} minutes."
		else
			str = "Finished in #{"%.2f" % duration} seconds."
		end
		puts "=== #{str}"
		puts "=============================================================================="
	end

	def file_exists(path)
		return File.file?(path)
	end

  def delete_dir(dname)
    begin
      FileUtils.rm_rf(dname)
    rescue
    end
  end

	def delete_file(fname)
		begin
			File.delete(fname)
		rescue
		end
	end

  def copy_file(sfname, dfname)
    begin
      FileUtils.copy(sfname, dfname)
    rescue
    end
  end

  def make_dir(dname)
    begin
      Dir.mkdir(dname)
    rescue
    end
  end

  def append_to_file(fname, line)
    begin
       File.open( fname, "a") {|f| f << line}
    rescue
    end
  end

  def filename_sort_helper( aname, bname )

    anumS = aname.split( "/" )[ 2 ].slice( 3..-1 )
    anum = anumS.to_f
    bnumS = bname.split( "/" )[ 2 ].slice( 3..-1 )
    bnum = bnumS.to_f

    # standard spaceship op behavior until they are ==. Then sort by length.
    if anum < bnum
      return -1
    elsif anum > bnum
      return 1
    else
      if anumS.length < bnumS.length
        return -1
      elsif anumS.length > bnumS.length
        return 1
      else
        return 0
      end
    end
  end

  def transcription_file_list( )
    return %w{ SJA SJC SJD SJE SJEx SJL SJP SJU SJV }
  end

  def manuscript_view_list( )
    return %w{ alltags critical diplomatic scribal }
  end

  def description_file_list( )
    return %w{ ADescription CDescription DDescription EDescription ExDescription LDescription PDescription UDescription VDescription }
  end

  def copyright_text_list( )

     return [ "&#169;THE BRITISH LIBRARY BOARD.  ALL RIGHTS RESERVED.",
              "&#169;THE BRITISH LIBRARY BOARD.  ALL RIGHTS RESERVED.",
              "Reproduced by permission of the Trustees of Lambeth Palace Library",
              "Reproduced by permission of the Trustees of the Huntington Library",
              "Reproduced by permission of the Devon Record Office",
              "Reproduced by permission of the Bodleian Library, University of Oxford Bodleian Library, MS Laud Misc. 656, Fol. _FOLIONAME_",
              "Reproduced by permission of Princeton University Library",
              "Reproduced by kind permission of the Syndics of Cambridge University Library",
              "&#169;THE BRITISH LIBRARY BOARD.  ALL RIGHTS RESERVED." ]
  end


  def transcript_title_list()
    return [ "British Library, MS Additional 31042 (A)",
             "British Library, MS Cotton Caligula A.ii, part I (C)",
             "Lambeth Palace Library, MS 491 (D)",
             "Huntington Library, MS HM 128 (E)",
             "Devon Record Office, Deposit 2507 (Ex)",
             "Bodleian Library, MS Laud Misc. 656 (L)",
             "Princeton University Library, MS Taylor Medieval 11 (P)",
             "Cambridge University Library, MS Mm.v.14 (U)",
             "British Library, MS Cotton Vespasian E.xvi (V)" ]
  end

  def xsl_transform_cmd( xmlfile, xslfile )
    return "java -jar tools/saxonhe-9-3-0-5j/saxon9he.jar -s:#{xmlfile} -xsl:#{xslfile}"
  end

=begin
  def processLineNote( line )


     # diagnostic only
     hl_line = line.attributes["n"]

     # create a hash of the line text tags and their corresponding location in the tree.
     # We will use this to merge with the other tag content in order to construct the full line
     textlist = Hash.new
     textnodes = line.texts( )
     textnodes.each do | tn |
        text = tn.value().gsub(/^[ ]*/, "" ).gsub(/\n/, "" )
        if text.empty?() == false
           textlist[ tn.index_in_parent( ) ] = text
        end
     end

     textixs = textlist.keys( ).sort( )
     ixlimit = textixs.size
     ix = 0
     content = ""

     # from this node, recurse through all its children and extract the data as necessary
     line.each_recursive() do |child|

        # if the next piece of content to insert is a text tag then do so
        childix = child.index_in_parent()
        if ix < ixlimit && childix > textixs[ ix ]
           content << textlist[ textixs[ ix ] ] << " "
           ix += 1
        end

        # look at each child node and process as appropriate
      	case child.name

            # these are the main content nodes provided they have an "ana" attribute
            # we need to take care as this could have children whose ext should come first
            when "seg"
           	   if child.attributes["ana"] != nil
       		        content << " " << child.text( ) unless child.has_text?( ) == false
               else
                  # otherwise, we look to see what type of seg node this is
                  case child.attributes["type"]

                    when "shadowHyphen", "punct"
                       content << child.text( ) unless child.has_text?( ) == false
                    when "averse", "bverse"
                      # ignore these...
                    else
                       #puts "UNPROCESSED seg tag #{child.attributes} #{hl_line}"
                  end
           	   end

            # these tags contain content thjat we want too
            when "expan", "damage", "add", "hi", "orig", "supplied", "corr"
                content << child.text( ) unless child.has_text?( ) == false

            # these are not interesting
            when "del", "note", "choice", "abbr", "reg", "g", "sic"
            	# do nothing...

            # so we can see the error case
            else
           	   puts "UNSUPPORTED TAG #{child.name} #{hl_line}"

    	  end

     end

     # if we have not added all the text nodes yet then add them to the end of the line
     while ix != ixlimit do
        content << " " << textlist[ textixs[ ix ] ]
        ix += 1
     end

     # if we do not have any content
     if content.empty? == true
        puts "** EMPTY LINE: #{hl} **"
     end

     return content

  end
=end

  def processParentNode( seg, hl )

     content = ""
     seg.each_child() do |segchild|

         # a text node... add its content
         if ( segchild.kind_of? REXML::Text ) == true
            content << " " << segchild.value( )
         else

            if segchild.attributes["ana"] != nil
               segchild.each_child() do |anachild|
                  if ( anachild.kind_of? REXML::Text ) == true
                     content << " " << anachild.value( )
                  else
                     content << processParentNode( anachild, hl )
                  end

               end
            else
               case segchild.name
               # these nodes can have children...
               when "hi", "expan", "add", "choice", "reg", "supplied", "corr"
                     content << processParentNode( segchild, hl )

               when "note", "del", "orig", "abbr", "sic"
                  # always ignore these...

               else
                  # otherwise, we look to see what type of node this is
                  case segchild.attributes["type"]

                  when "shadowHyphen", "punct"
                     content << segchild.text( ) unless segchild.has_text?( ) == false

                  when "averse", "bverse"
                     content << processParentNode( segchild, hl )

                  else
                     puts "UNPROCESSED seg child #{segchild.name} #{segchild.attributes} #{hl}"
                  end
               end
            end
         end
     end
     return content
  end

  def processLine( line, hl )

      content = ""

      line.each_child() do |child|

         # a text node... add its content
         if ( child.kind_of? REXML::Text ) == true
            content << " " << child.value( )
         else

            case child.name

              when "seg"

                     child.each_child() do |grandchild|
                        # a text node... add its content
                        if ( grandchild.kind_of? REXML::Text ) == true
                           content << " " << grandchild.value( )
                        else
                           case grandchild.name
                           when "note"
                              # ignore these...
                           else
                              content << processParentNode( grandchild, hl )
                           end
                        end
                     end

              when "damage", "expan", "hi"
                  # take the text from these...
                  content << child.text( ) unless child.has_text?( ) == false

              when "g"
                # ignore these...

              else
                 puts "UNPROCESSED LINE TAG #{child.name} #{hl}"
            end
         end
      end
      return content
  end

  def load_transcription_from_file( xmlfile )

     linecount = 0
     pagecount = 0
     folio = ""
     result = []

     puts "Processing #{xmlfile}..."

     xml = File.read( xmlfile )
     doc = REXML::Document.new(xml)

     # create a list of pages
     doc.elements.each('//milestone') do |page|

        # extract the folio information from the page tag
        folio = page.attributes["entity"]
        pagecount += 1

        # continue to move to the next sibling processing each line until another page tag is identified
        nextnode = page.next_sibling_node( )
        while nextnode != nil do

           # text nodes should be ignored
           if ( nextnode.kind_of? REXML::Text ) == false

              case nextnode.name

                 # line nodes are the ones we want
                 when "l"

                     #puts nextnode.attributes
                     loc_line = nextnode.attributes["xml:id"]
                     hl_line = nextnode.attributes["n"]
                     content = processLine( nextnode, hl_line )

                     if content.empty? == false
                        content = content.gsub(/\n/, "" ).squeeze( ).gsub( /^ /, "" )
                        #puts "#{folio} : #{hl} #{content}"
                        result[ linecount ] = { :pageimg => folio, :loc_line => loc_line, :hl_line => hl_line, :content => content }
                        linecount += 1
                     else
                        puts "** EMPTY LINE: #{hl} **"
                     end

                 # we have reached the next page so drop out
                 when "milestone"
                    break
              end
           end
           nextnode = nextnode.next_sibling_node()
        end

     end

     puts "STATUS: #{xmlfile}: #{pagecount} pages, #{linecount} lines"
     return result
  end

  def load_comparison_from_file( xmlfile )

    result = Array.new
    linecount = 0
    file = File.new( xmlfile, "r")
    while ( json = file.gets )

       #puts "[#{json.gsub(/\n/, "" )}]"
       parsed_json = ActiveSupport::JSON.decode( json.strip )
       result[ linecount] = parsed_json
       linecount += 1

    end
    file.close
    return result

  end

  def load_description_from_file( xmlfile )

    result = []
    linecount = 0
    xmldoc = XML::Reader.file( xmlfile, :options => XML::Parser::Options::NOBLANKS | XML::Parser::Options::PEDANTIC )

    while xmldoc.read
       unless xmldoc.node_type == XML::Reader::TYPE_END_ELEMENT

          case xmldoc.name
            when "author",
                 "bibl",
                 "binding",
                 "collation",
                 "condition",
                 "contents",
                 "country",
                 "date",
                 "deconote",
                 "edition",
                 "editor",
                 "extent",
                 "foliation",
                 "format",
                 "graphic",
                 "hi",
                 "idno",
                 "item",
                 "layout",
                 "locus",
                 "measure",
                 "origDate",
                 "origPlace",
                 "p",
                 "persName",
                 "placeName",
                 "provenance",
                 "pubPlace",
                 "publisher",
                 "ref",
                 "repository",
                 "settlement",
                 "summary",
                 "support",
                 "title"

               content = xmldoc.node.content
               if content.empty? == false
                  result[ linecount] = content
                  linecount += 1

               end
          end
       end
    end

    xmldoc.close
    #puts "processed #{pagecount} pages and #{linecount} lines"

    return result

  end

  def load_annotations_from_file( xmlfile )

    pending_page_content = ""
    page_image_file = ""
    result = []
    pagecount = 0
    linecount = 0

    xmldoc = XML::Reader.file( xmlfile, :options => XML::Parser::Options::NOBLANKS | XML::Parser::Options::PEDANTIC )

    while xmldoc.read
       unless xmldoc.node_type == XML::Reader::TYPE_END_ELEMENT

          case xmldoc.name

             # the initial tag for the start of a new page
             when "milestone"

               # always flush any pending data...
               if pending_page_content.empty? == false
                   abort( "page_image_file empty!") unless page_image_file.empty? == false

                   result[ pagecount ] = { :pageimg => page_image_file, :content => pending_page_content }
                   #puts "page #{pagecount + 1}: img [#{page_image_file}], note [#{pending_page_content}]"
                   pending_page_content = ""
                   pagecount += 1
               end

               page_image_file = xmldoc[ "entity" ]

            when "note"

                content = xmldoc.read_string
                # sometimes there is a <note> tag with no content so ignore those
                if content.empty? == false
                  pending_page_content << content << " "
                  linecount += 1
                end

           end
        end
     end

     # gets any remaining content that has not already been processed
     if pending_page_content.empty? == false
       abort( "page_image_file empty!") unless page_image_file.empty? == false
        result[ pagecount ] = { :pageimg => page_image_file, :content => pending_page_content }
        #puts "page #{pagecount + 1}: img [#{page_image_file}], note [#{pending_page_content}]"
        pagecount += 1
     end

     xmldoc.close
     #puts "processed #{linecount} notes in #{pagecount} page(s)"

     return result

  end

end
