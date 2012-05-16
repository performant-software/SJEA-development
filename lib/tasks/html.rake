# encoding: UTF-8

require "#{Rails.root}/lib/tasks/task_utilities"

namespace :html do
	include TaskUtilities

	desc "Completely recreate the content HTML from the XML/XSL"
	task :regen => :environment do
		start_time = start_line("Recreate the content HTML from the XML/XSL.")

    transcripts = %w{ SJA.xml SJC.xml SJD.xml SJE.xml SJEx.xml SJL.xml SJP.xml SJU.xml SJV.xml }
    views = %w{ MS-alltags.html MS-critical.html MS-diplomatic.html MS-scribal.html }

    tooldir = "tools/saxonhe-9-4-0-3j"
    jarfile = "#{tooldir}/saxon9he.jar"
    outputdir = "."
    xsltdir = "XSLT"
    xsl = "#{xsltdir}/SJEA-AllTags-XMLtoHTML.xsl"
    xmldir = "#{xsltdir}/xml"
    targetdir = "public"

    transcripts.each do |xmlfile|

      output = ""

      views.each do |view|
        output << `rm -fr #{outputdir}/#{view}`
      end

      basename = xmlfile.gsub(/^(.*).xml$/, '\1')
      puts "processing #{xmlfile}..."

      output << `java -jar #{jarfile} -s:#{xmldir}/#{xmlfile} -xsl:#{xsl}`
      views.each do |view|
        output << `cp #{outputdir}/#{view} #{targetdir}/#{basename}-#{view}`
      end

      puts output.chomp
    end

    puts "copying stylesheet..."
    output = `cp #{xsltdir}/stylesheets/manuscript.css #{targetdir}/stylesheets/manuscript.css`
    puts output.chomp

		finish_line(start_time)
	end

end
