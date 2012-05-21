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

       append_to_file( outfile, "<div id=\"previous-page\" href=\"#{prevpage}\"></div><div id=\"next-page\" href=\"#{nextpage}\"></div><div id=\"compare-spacer\"></div>\n" )

       comparisons = complist.css('l')
       compare_set = Hash.new( )
       comparisons.each do |compare|
          compare_set[ compare.attribute('attr').to_s() ] = compare.content
       end

       transcription_file_list( ).each do |tname|

         compline = "<div id=\"#{tname}-compare\" class=\"compare-box\">"

         if compare_set.key?( tname )
           compline << compare_set[ tname ]
         else
            compline << "---- NOTHING ----"
         end

         compline << "</div>\n"
         append_to_file( outfile, compline )

       end

       ix += 1

    end

    finish_line(start_time)
  end

end
