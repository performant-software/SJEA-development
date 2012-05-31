require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

  #
  # Regenerates the description HTML content
  #

  desc "Regenerate the HTML description content from the XML/XSL"
  task :regendesc => :environment do
    start_time = start_line("Regenerate the HTML description content from the XML/XSL.")

    targetdir = "public"
    xsltdir = "XSLT"
    xslfile = "#{xsltdir}/SJEADescriptions-XMLtoHTML.xsl"
    manifest = "#{xsltdir}/SJEADescrListforHTML.xml"

    puts "generating html..."
    cmd_line( xsl_transform_cmd( manifest, xslfile ) )

    puts "copying generated html..."
    transcription_file_list( ).each do |fname|

      srcname = "#{fname}-description.html"
      dstname = "#{targetdir}/#{srcname}"

      copy_file( srcname, dstname )
      delete_file( srcname )

    end

    # just in case it does not already exist
    make_dir( "#{targetdir}/xml")

    puts "copying raw xml..."
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
