# encoding: UTF-8

require "#{Rails.root}/lib/tasks/task_utilities"

namespace :html do
	include TaskUtilities

  tooldir = "tools/saxonhe-9-4-0-3j"
  jarfile = "#{tooldir}/saxon9he.jar"
  xsltdir = "XSLT"
  xmldir = "#{xsltdir}/xml"
  targetdir = "public"

	desc "Regenerate the HTML transcription content from the XML/XSL"
	task :regencontent => :environment do
		start_time = start_line("Regenerate the HTML transcription content from the XML/XSL.")

    transcripts = [ "SJA.xml", "SJC.xml", "SJD.xml", "SJE.xml", "SJEx.xml", "SJL.xml", "SJP.xml", "SJU.xml", "SJV.xml" ]
    views = [ "MS-alltags.html", "MS-critical.html", "MS-diplomatic.html", "MS-scribal.html" ]

    outputdir = "."
    xsl = "#{xsltdir}/SJEA-AllTags-XMLtoHTML.xsl"

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

  desc "Regenerate the HTML description content from the XML/XSL"
  task :regendesc => :environment do
    start_time = start_line("Regenerate the HTML description content from the XML/XSL.")

    descriptions = [ "A Description.xml", "C Description.xml", "D Description.xml", "E Description.xml", "Ex Description.xml", "L Description.xml", "P Description.xml", "U Description.xml", "V Description.xml" ]

    descriptions.each do |xmlfile|

      basename = xmlfile.gsub(/^(.*).xml$/, '\1')
      puts "processing #{xmlfile}..."

    end

    finish_line(start_time)
  end

  desc "Regenerate the HTML comparison content from the XML/XSL"
  task :regencomp => :environment do
    start_time = start_line("Regenerate the HTML comparison content from the XML/XSL.")

    finish_line(start_time)
  end

end
