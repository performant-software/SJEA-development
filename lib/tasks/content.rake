require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

  #
  # Regenerates the transcription HTML content
  #

	desc "Regenerate the HTML transcription content from the XML/XSL"
	task :regencontent => :environment do
		start_time = start_line("Regenerate the HTML transcription content from the XML/XSL.")

    xsltdir = "XSLT"
    xmldir = "#{xsltdir}/xml"
    targetdir = "public"

    xslfile = "XSLT/SJEA-AllTags-XMLtoHTML.xsl"

    transcription_file_list( ).each do |fname|

      xmlfile = "XSLT/xml/#{fname}.xml"

      manuscript_view_list( ).each do |vname|
        viewfile = vname + ".html"
        delete_file( viewfile )
      end

      puts "processing #{fname}..."

      cmd_line( xsl_transform_cmd( xmlfile, xslfile ) )

      manuscript_view_list( ).each do |vname|
        viewfile = vname + ".html"
        copy_file( viewfile, "#{targetdir}/#{fname}-#{viewfile}" )
        delete_file( viewfile )
      end

    end

    puts "copying stylesheet..."
    copy_file( "#{xsltdir}/stylesheets/manuscript.css", "#{targetdir}/stylesheets/manuscript.css" )

		finish_line(start_time)
	end

end
