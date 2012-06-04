require "xml"

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
    #return %w{ SJE }
  end

  def manuscript_view_list( )
    return %w{ alltags critical diplomatic scribal }
  end

  def description_file_list( )
    return %w{ ADescription CDescription DDescription EDescription ExDescription LDescription PDescription UDescription VDescription }
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


  def load_transcription_from_file( xmlfile )

     xmldoc = XML::Reader.file( xmlfile, :options => XML::Parser::Options::NOBLANKS | XML::Parser::Options::PEDANTIC )

     linecount = 0
     pagecount = 0
     seqtags = 0
     pending_line_content = ""
     hl_line = ""
     loc_line = ""
     page_image_file = ""
     result = []

     while xmldoc.read
        unless xmldoc.node_type == XML::Reader::TYPE_END_ELEMENT

           case xmldoc.name

             # the initial tag for the start of a new page
             when "milestone"

               # always flush any pending data...
               if pending_line_content.empty? == false
                   abort( "hl_line empty!") unless hl_line.empty? == false
                   abort( "loc_line empty!") unless loc_line.empty? == false
                   abour( "page_image_file empty!") unless page_image_file.empty? == false

                   result[ linecount ] = { :pageimg => page_image_file, :loc_line => loc_line, :hl_line => hl_line, :content => pending_line_content }
                   pending_line_content = ""
                   linecount += 1
               end

               page_image_file = xmldoc[ "entity" ]
               pagecount += 1

             when "l"

               # always flush any pending data...
               if pending_line_content.empty? == false
                 abort( "hl_line empty!") unless hl_line.empty? == false
                 abort( "loc_line empty!") unless loc_line.empty? == false
                 abour( "page_image_file empty!") unless page_image_file.empty? == false
                 result[ linecount ] = { :pageimg => page_image_file, :loc_line => loc_line, :hl_line => hl_line, :content => pending_line_content }
                 pending_line_content = ""
                 linecount += 1
               end

               # TODO: fix me...
               #pending_line_content = xmldoc.node.content
               # if pending_line_content.empty? == true
                   #puts "*********** ALERT line #{linecount} should not be empty ***********"
               # end

                loc_line = xmldoc[ "xml:id" ]
                hl_line = xmldoc[ "n" ]

             # we are in a line and this is a bit of content
             when "seg"

                # sometimes there is a parent <seq> tag with no content so ignore those; they have a "type" attribute
                if xmldoc[ "type" ] == nil
                  pending_line_content << xmldoc.read_string << " "
                end
           end
        end
     end

     # gets any remaining content that has not already been processed
     if pending_line_content.empty? == false
       abort( "hl_line empty!") unless hl_line.empty? == false
       abort( "loc_line empty!") unless loc_line.empty? == false
       abour( "page_image_file empty!") unless page_image_file.empty? == false
        result[ linecount ] = { :pageimg => page_image_file, :loc_line => loc_line, :hl_line => hl_line, :content => pending_line_content }
        linecount += 1
     end

     xmldoc.close
     #puts "processed #{pagecount} pages and #{linecount} lines"

     return result
  end

  def load_comparison_from_file( xmlfile )

    result = []
    linecount = 0
    xmldoc = XML::Reader.file( xmlfile, :options => XML::Parser::Options::NOBLANKS | XML::Parser::Options::PEDANTIC )

    while xmldoc.read
       unless xmldoc.node_type == XML::Reader::TYPE_END_ELEMENT

          case xmldoc.name
            when "l"
               trans = xmldoc[ "attr" ]
               loc_line = xmldoc[ "line" ]
               line_content = xmldoc.node.content
               result[ linecount] = { :trans => trans, :loc_line => loc_line, :content => line_content }
               linecount += 1

          end
       end
    end

    xmldoc.close
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

                  #puts "name [#{xmldoc.name}]: [#{content}]"
               end
          end
       end
    end

    xmldoc.close
    return result

  end

  def load_annotation_from_file( xmlfile )

    # TODO: implement me
    result = []
    result[ 0 ] = "this is line number one"
    result[ 1 ] = "this is line number two"
    result[ 2 ] = "this is line number three"
    result[ 3 ] = "this is line number four"
    result[ 4 ] = "this is line number five"
    return result

  end

end
