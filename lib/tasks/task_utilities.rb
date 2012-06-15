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

  def processParentNode( seg, hl )

   content = ""

   seg.each_child() do |segchild|

       # a text node... add its content
       if ( segchild.kind_of? REXML::Text ) == true

          # a kind of hack...
          #if seg.name != "hi"
          #   content << " "
          #end
          content << segchild.value( )
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

  def processLineChildren( line )

      content = ""
      hl = line.attributes["n"]

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

  def processLineNode( node, folio, linelist )

     loc_line = node.attributes["xml:id"]
     hl_line = node.attributes["n"]
     content = processLineChildren( node )

     # if we have any content, clean it up and store it
     if content.empty? == false
        content = content.gsub(/\n/, "" ).squeeze( ).gsub( /^ /, "" )

        #puts "#{folio} : #{hl} #{content}"
        linelist[ linelist.size ] = { :pageimg => folio, :loc_line => loc_line, :hl_line => hl_line, :content => content }
     else
        puts "** EMPTY LINE: #{hl_line} **"
     end

  end

  def processLgTagStructure( doc, linelist )

     folio = "UNKNOWN"
     pages = 0
     lines = 0

     # process the list of lg tags
     doc.elements.each('//lg') do | lgtag |

        childlg = lgtag.elements[ 1 ]
        while childlg != nil do
           if ( childlg.kind_of? REXML::Text ) == false
              case childlg.name
                 when "l"
                    processLineNode( childlg, folio, linelist )
                    lines += 1

                 when "milestone"
                    folio = childlg.attributes["entity"]
                    pages += 1

                  when "trailer"
                     # ignore these for now...

                 when "lg"
                    break
                 else
                    puts "UNPROCESSED TAG in lg loop #{childlg.name}"
              end
           else
                  # nothing else of interest here so this is not an error
                  #puts "UNEXPECTED TEXT TAG in processLgTagStructure #{childlg.value}"
           end
           childlg = childlg.next_sibling_node()
        end
     end

     puts "Processed #{pages} pages, #{lines} lines"
  end

  def processDiv2TagStructure( doc, linelist )

     folio = "UNKNOWN"
     pages = 0
     lines = 0

     # process the list of div2's
     doc.elements.each('//div2') do | div2 |

         # we may hit one in the inner loop so we need a way to drop out
         newMilestone = false

         nextnode = div2.elements[ 1 ]
         while nextnode != nil do
           if ( nextnode.kind_of? REXML::Text ) == false
              case nextnode.name
                  when "l"
                     processLineNode( nextnode, folio, linelist )
                     lines += 1

                  when "milestone"
                     folio = nextnode.attributes["entity"]
                     pages += 1

                  when "marginalia", "head", "trailer", "fw"
                     # ignore these for now...

                  when "div2"
                     break

                  else
                     puts "UNPROCESSED TAG in processDiv2Structure #{nextnode.name}"
              end
           else
              # nothing else of interest here so this is not an error
              #puts "UNEXPECTED TEXT TAG in processDiv2Structure #{nextnode.value}"
           end
           nextnode = nextnode.next_sibling_node()
        end
     end
     puts "Processed #{pages} pages, #{lines} lines"
  end

  def processSpecialDiv2TagStructure( doc, linelist )

     folio = "UNKNOWN"
     pages = 0
     lines = 0

     # cant seem to just get thew first one...
     doc.root.elements.each( '//milestone' ) do | page |
        folio = page.attributes["entity"]
        pages = 1
        break
     end

     # process the list of div2's
     doc.elements.each('//div2') do | div2 |

         # we may hit one in the inner loop so we need a way to drop out
         newMilestone = false

         nextnode = div2.elements[ 1 ]
         while nextnode != nil do
           if ( nextnode.kind_of? REXML::Text ) == false
              case nextnode.name
                  when "l"
                     processLineNode( nextnode, folio, linelist )
                     lines += 1

                  when "milestone"
                     folio = nextnode.attributes["entity"]
                     pages += 1

                  when "head"
                     # ignore these for now...

                  when "div2"
                     break

                  else
                     puts "UNPROCESSED TAG in processSpecialDiv2TagStructure #{nextnode.name}"
              end
           else
              # nothing else of interest here so this is not an error
              #puts "UNEXPECTED TEXT TAG in processDiv2Structure #{nextnode.value}"
           end
           nextnode = nextnode.next_sibling_node()
        end
     end
     puts "Processed #{pages} pages, #{lines} lines"

  end

  # the simple structure consists of a div1 tag followed by peer milestone and line tags
  def processSimpleStructure( doc, linelist )

     pages = 0
     lines = 0

     # process the list of pages
     doc.elements.each('//milestone') do | page |

        #puts page.attributes
        folio = page.attributes["entity"]
        pages += 1

        nextnode = page.next_sibling_node( )
        while nextnode != nil do
           if ( nextnode.kind_of? REXML::Text ) == false
              case nextnode.name
                  when "l"
                     processLineNode( nextnode, folio, linelist )
                     lines += 1

                  when "milestone"
                     break

                  else
                     puts "UNPROCESSED TAG in processSimpleStructure #{nextnode.name}"
              end
           else
              # nothing else of interest here so this is not an error
              #puts "UNEXPECTED TEXT TAG in processSimpleStructure #{nextnode.value}"
           end
           nextnode = nextnode.next_sibling_node()
        end
     end
     puts "Processed #{pages} pages, #{lines} lines"
  end

  def load_transcription_from_file( xmlfile )

     linelist = []

     puts "Processing #{xmlfile}..."

     xml = File.read( xmlfile )
     doc = REXML::Document.new( xml )

     fileprefix = xmlfile.split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1')

     case fileprefix

     when "SJA", "SJC", "SJD", "SJL", "SJU"
        processDiv2TagStructure( doc, linelist )

     when "SJE"
        processLgTagStructure( doc, linelist )

     when "SJEx"
        processSimpleStructure( doc, linelist )

     when "SJP", "SJV"
        processSpecialDiv2TagStructure( doc, linelist )

     end

     return linelist

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
