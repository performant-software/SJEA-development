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

      lines = load_transcription_from_file( xmlfile )
      puts "#{tfilename}: #{lines.size} lines loaded"

      lines.each do |line|

        local_lnumber = line[:loc_line]
        hl_lnumber = line[:hl_line]
        text_line = CGI::escapeHTML( line[:content] )

        fname = "#{workdir}/#{hl_lnumber}.xml"
        output = "<l attr=\'#{tfilename}\' line=\'#{local_lnumber}'>#{text_line}</l>\n"

        # add a div tag if necessary... required for the subsequent XML parsing !!!
        if file_exists( fname ) == false
           append_to_file( fname, "<div>\n" )
        end
        append_to_file( fname, output )

      end

    end

    # close the div for each file
    files = Dir.glob( "#{workdir}/*.xml" )
    files.each do |fname|
       append_to_file( fname, "</div>\n" )
    end

    files = Dir.glob( "#{workdir}/*.xml" ).sort! { |a, b| filename_sort_helper( a, b ) }
    puts "rolling up comparisons: #{files.size} files to process..."

    ix = 0
    ixend = files.size() - 1

    files.each do |fname|

       lines = load_comparison_from_file( fname )
       outfile = targetdir + "/" + fname.split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1') + ".html";

       # generate the previous and next page tags...
       if ix == 0  # first page of comparisons
          prevpage = "HL.2147"
          nextpage = files[ ix + 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1');
       elsif ix == ixend    # last page of comparisons
         prevpage = files[ ix - 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1');
         nextpage = "HL.0001"
       else
          prevpage = files[ ix - 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1');
          nextpage = files[ ix + 1 ].split( "/" )[ 2 ].gsub(/^(.*).xml$/, '\1');
       end

       append_to_file( outfile, "<div id=\"previous-page\" href=\"#{prevpage}\"></div><div id=\"next-page\" href=\"#{nextpage}\"></div>\n<table id=\"compare-results\">\n" )

       alt = 0
       transcription_file_list( ).each do |tname|

         # row shading...
         if alt % 2 == 0
            compline = "<tr class=\"alt\">"
         else
            compline = "<tr>"
         end
         alt += 1

         # do we have this particular transcript
         tx = lines.index{|l| l[:trans] == tname}

         if tx != nil
            compline << "<td>#{lines[tx][:loc_line]}</td><td>(#{tname})</td><td class=\"textline\">#{lines[tx][:content]}</td>\n"
         else
            compline << "<td></td><td>(#{tname})</td><td class=\"textline\">---- no text ----</td>\n"
         end

         append_to_file( outfile, compline )

       end

       append_to_file( outfile, "</table>\n" )
       ix += 1

    end

    finish_line(start_time)
  end

end
