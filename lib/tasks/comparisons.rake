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
        hl_lnumber = line[:hl_line].gsub( ", ", "-" )
        text_line = CGI::escapeHTML( line[:content].gsub(/\n/, "" ) )

        # create json files of the information...
        fname = "#{workdir}/#{hl_lnumber}.json"
        output = "{ \"trans\" : \"#{tfilename}\", \"loc_line\" : \"#{local_lnumber}\", \"content\" : \"#{text_line}\"}\n"
        append_to_file( fname, output )

      end

    end

    files = Dir.glob( "#{workdir}/*.json" ).sort! { |a, b| filename_sort_helper( a, b ) }
    puts "rolling up comparisons: #{files.size} files to process..."

    ix = 0
    ixend = files.size() - 1

    files.each do |fname|

       lines = load_comparison_from_file( fname )
       outfile = targetdir + "/" + fname.split( "/" )[ 2 ].gsub(/^(.*).json$/, '\1') + ".html";

       # generate the previous and next page tags...
       if ix == 0  # first page of comparisons
          prevpage = "HL.2147"
          nextpage = files[ ix + 1 ].split( "/" )[ 2 ].gsub(/^(.*).json$/, '\1');
       elsif ix == ixend    # last page of comparisons
         prevpage = files[ ix - 1 ].split( "/" )[ 2 ].gsub(/^(.*).json$/, '\1');
         nextpage = "HL.0001"
       else
          prevpage = files[ ix - 1 ].split( "/" )[ 2 ].gsub(/^(.*).json$/, '\1');
          nextpage = files[ ix + 1 ].split( "/" )[ 2 ].gsub(/^(.*).json$/, '\1');
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
         tx = lines.index{|l| l["trans"] == tname}

         if tx != nil
            compline << "<td>#{lines[tx]["loc_line"].split( "." )[1].sub(/^[0]*/,"")}</td><td>(#{tname.sub("SJ", "" )})</td><td class=\"textline\">#{lines[tx]["content"]}</td>\n"
         else
            compline << "<td></td><td>(#{tname.sub("SJ", "")})</td><td class=\"textline\">---- no text ----</td>\n"
         end

         append_to_file( outfile, compline )

       end

       append_to_file( outfile, "</table>\n" )
       ix += 1

    end

    finish_line(start_time)
  end

end
