require "cgi"
require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

  #
  # Regenerates the comparison HTML content
  #

  desc "Regenerate the HTML comparison content from the XML/XSL"
  task :regencompare => :environment do
    start_time = start_line("Regenerate the HTML comparison content from the XML/XSL.")

    targetdir = "public/comparisons"
    delete_dir( targetdir )
    make_dir( targetdir )

    workdir = "tmp/comp"
    delete_dir( workdir )
    make_dir( workdir )

    transcription_file_list( ).each do |tfilename|

      xmlfile = "XSLT/xml/#{tfilename}.xml"

      puts "processing #{tfilename}..."

      begin
        xmldoc = Nokogiri::XML( File.open( xmlfile ) ) { |config| config.strict }
        rescue Nokogiri::XML::SyntaxError => e
        abort "caught exception processing #{xmlfile}: #{e}"
      end

      xml_lines = xmldoc.css('l')
      xml_lines.each do |xml_line|

        hl_number = xml_line.attribute('n')
        text_line = CGI::escapeHTML( xml_line.content.split.join(" ") )
        fname = "#{workdir}/#{hl_number}.xml"
        output = "<l attr=\'#{tfilename}\'>#{text_line}</l>\n"

        # add a div tag if necessary... required for the subsequent XML parsing !!!
        if file_exists( fname ) == false
           append_to_file( fname, "<div>" )
        end
        append_to_file( fname, output )

      end

    end

    # close the div for each file
    files = Dir.glob( "#{workdir}/*.xml" )
    files.each do |fname|
       append_to_file( fname, "</div>" )
    end

    puts "rolling up comparisons..."

    files = Dir.glob( "#{workdir}/*.xml" ).sort! { |a, b| filename_sort_helper( a, b ) }

    ix = 0
    ixend = files.size() - 1

    files.each do |fname|

       begin
         complist = Nokogiri::XML( File.open( fname ) ) { |config| config.strict }
         rescue Nokogiri::XML::SyntaxError => e
         abort "caught exception processing #{fname}: #{e}"
       end

       outfile = targetdir + "/" + fname.split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1') + ".html"

       if ix == 0  # first page of comparisons
          prevpage = "HL.2147.html"
          nextpage = files[ ix + 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1') + ".html"
       elsif ix == ixend    # last page of comparisons
         prevpage = files[ ix - 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1') + ".html"
         nextpage = "HL.0001.html"
       else
          prevpage = files[ ix - 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1') + ".html"
          nextpage = files[ ix + 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1') + ".html"
       end

       append_to_file( outfile, "<div id=\"previous-page\" href=\"#{prevpage}\"></div><div id=\"next-page\" href=\"#{nextpage}\"></div>\n<table id=\"compare-results\">\n" )

       comparisons = complist.css('l')
       compare_set = Hash.new( )
       comparisons.each do |compare|
          compare_set[ compare.attribute('attr').to_s() ] = compare.content
       end

       alt = 0
       transcription_file_list( ).each do |tname|

         # row shading...
         if alt % 2 == 0
            compline = "<tr class=\"alt\">"
         else
            compline = "<tr>"
         end
         alt += 1

         if compare_set.key?( tname )
           compline << "<td>xx</td><td>(#{tname})</td><td class=\"textline\">"
           compline << compare_set[ tname ]
           compline << "</td>\n"
         else
            compline << "<td>xx</td><td>(#{tname})</td><td class=\"textline\">---- NOTHING ----</td>\n"
         end

         append_to_file( outfile, compline )

       end

       append_to_file( outfile, "</table>\n" )
       ix += 1

    end

    finish_line(start_time)
  end

end
