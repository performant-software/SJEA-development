# encoding: UTF-8

require "cgi"
require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

  #tooldir = "tools/saxonhe-9-4-0-3j"
  tooldir = "tools/saxonhe-9-3-0-5j"

  jarfile = "#{tooldir}/saxon9he.jar"
  xsltdir = "XSLT"
  xmldir = "#{xsltdir}/xml"

  #
  # Regenerates the transcription HTML content
  #

	desc "Regenerate the HTML transcription content from the XML/XSL"
	task :regencontent => :environment do
		start_time = start_line("Regenerate the HTML transcription content from the XML/XSL.")

    transcripts = [ "SJA.xml", "SJC.xml", "SJD.xml", "SJE.xml", "SJEx.xml", "SJL.xml", "SJP.xml", "SJU.xml", "SJV.xml" ]
    views = [ "MS-alltags.html", "MS-critical.html", "MS-diplomatic.html", "MS-scribal.html" ]
    targetdir = "public"

    outputdir = "."
    xsl = "#{xsltdir}/SJEA-AllTags-XMLtoHTML.xsl"

    transcripts.each do |xmlfile|

      views.each do |view|
        delete_file( "#{outputdir}/#{view}" )
      end

      puts "processing #{xmlfile}..."

      cmd_line( "java -jar #{jarfile} -s:#{xmldir}/#{xmlfile} -xsl:#{xsl}" )

      basename = xmlfile.gsub(/^(.*).xml$/, '\1')
      views.each do |view|
        copy_file( "#{outputdir}/#{view}", "#{targetdir}/#{basename}-#{view}" )
      end

    end

    puts "copying stylesheet..."
    copy_file( "#{xsltdir}/stylesheets/manuscript.css", "#{targetdir}/stylesheets/manuscript.css" )

		finish_line(start_time)
	end

  #
  # Regenerates the description HTML content
  #

  desc "Regenerate the HTML description content from the XML/XSL"
  task :regendesc => :environment do
    start_time = start_line("Regenerate the HTML description content from the XML/XSL.")

    #descriptions = [ "A Description.xml", "C Description.xml", "D Description.xml", "E Description.xml", "Ex Description.xml", "L Description.xml", "P Description.xml", "U Description.xml", "V Description.xml" ]
    descriptions = [ "ADescription.xml", "LDescription.xml" ]

    targetdir = "public"

    outputfile = "./.html"
    xsl = "#{xsltdir}/SJEADescriptions-XMLtoHTML.xsl"

    descriptions.each do |xmlfile|

      targetname = xmlfile.gsub(/^(.*).xml$/, '\1') + ".html"
      puts "processing #{xmlfile}..."

      delete_file( "#{outputfile}" )

      cmd_line( "java -jar #{jarfile} -s:#{xmldir}/#{xmlfile} -xsl:#{xsl}" )
      copy_file( outputfile, "#{targetdir}/#{targetname}" )

    end

    finish_line(start_time)
  end

  #
  # Regenerates the comparison HTML content
  #

  desc "Regenerate the HTML comparison content from the XML/XSL"
  task :regencomp => :environment do
    start_time = start_line("Regenerate the HTML comparison content from the XML/XSL.")

    transcripts = [ "SJA.xml", "SJC.xml", "SJD.xml", "SJE.xml", "SJEx.xml", "SJL.xml", "SJP.xml", "SJU.xml", "SJV.xml" ]
    targetdir = "public/comparisons"
    delete_dir( targetdir )
    make_dir( targetdir )

    workdir = "tmp/comp"
    delete_dir( workdir )
    make_dir( workdir )

    transcripts.each do |xmlfile|

      basename = xmlfile.gsub(/^(.*).xml$/, '\1')
      puts "processing #{xmlfile}..."

      begin
        xmldoc = Nokogiri::XML( File.open( "XSLT/xml/#{xmlfile}" ) ) { |config| config.strict }
        rescue Nokogiri::XML::SyntaxError => e
        abort "caught exception processing #{xmlfile}: #{e}"
      end

      xml_lines = xmldoc.css('l')
      xml_lines.each do |xml_line|

        hl_number = xml_line.attribute('n')
        text_line = CGI::escapeHTML( xml_line.content.split.join(" ") )
        fname = "#{workdir}/#{hl_number}.xml"
        output = "<l attr=\'#{basename}\'>#{text_line}</l>\n"

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

       transcripts.each do |xmlfile|

         tname = xmlfile.gsub(/^(.*).xml$/, '\1')
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
