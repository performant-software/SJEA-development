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

    xslfile = "XSLT/SJEADescriptions-XMLtoHTML.xsl"

    description_file_list( ).each do |fname|

      xmlfile = "XSLT/xml/#{fname}.xml"
      targetname = "public/#{fname}.html"

      puts "processing #{fname}..."

      delete_file( outputfile )
      cmd_line( xsl_transform_cmd( xmlfile, xslfile ) )
      copy_file( outputfile, targetname )
      delete_file( outputfile )

    end

    finish_line(start_time)
  end

end
