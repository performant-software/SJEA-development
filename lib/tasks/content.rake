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

    xslfile = "#{xsltdir}/SJEA-AllTags-XMLtoHTML.xsl"
    manifest = "#{xsltdir}/SJEAListforHTML.xml"

    puts "generating html..."

    cmd_line( xsl_transform_cmd( manifest, xslfile ) )

    puts "copying generated html..."
    transcription_file_list( ).each do |fname|

      prefix = fname.gsub( "SJ", "MS" )

      manuscript_view_list( ).each do |vname|
        viewfile = "#{prefix}-#{vname}.html"
        copy_file( viewfile, "#{targetdir}/#{viewfile}" )
        delete_file( viewfile )
      end

    end

    make_dir( "#{targetdir}/xml")

    puts "copying raw xml..."
    transcription_file_list( ).each do |fname|
       srcname = "#{xsltdir}/xml/#{fname}.xml"
       dstname = "#{targetdir}/xml/#{fname}.xml"
       copy_file( srcname, dstname )
    end

    description_file_list( ).each do |fname|
       srcname = "#{xsltdir}/xml/#{fname}.xml"
       dstname = "#{targetdir}/xml/#{fname}.xml"
       copy_file( srcname, dstname )
    end

    puts "copying stylesheet..."
    copy_file( "#{xsltdir}/stylesheets/manuscript.css", "#{targetdir}/stylesheets/manuscript.css" )

		finish_line(start_time)
	end

end
