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
    outputfile = "SJ-description.html"  # temp breakage of XSLT...
    xsltdir = "XSLT"
    xslfile = "#{xsltdir}/SJEADescriptions-XMLtoHTML.xsl"

    description_file_list( ).each do |fname|

      xmlfile = "#{xsltdir}/xml/#{fname}.xml"
      targetname = "#{targetdir}/#{fname}.html"

      puts "processing #{fname}..."

      delete_file( outputfile )
      cmd_line( xsl_transform_cmd( xmlfile, xslfile ) )
      copy_file( outputfile, targetname )
      delete_file( outputfile )

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
