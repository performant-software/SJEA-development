# encoding: UTF-8

require "#{Rails.root}/lib/tasks/task_utilities"

namespace :search do
	include TaskUtilities

	desc "Completely reindex everything with solr"
	task :recreate => :environment do
		start_time = start_line("Recreate solr index using all data in the database.")

    solr = Solr.factory({ testing: false, force: true })
    solr.clear_all(false)

    transcripts = %w{ SJA.xml SJC.xml SJD.xml SJE.xml SJEx.xml SJL.xml SJP.xml SJU.xml SJV.xml }

    transcripts.each do |xmlfile|

       begin
         puts "loading #{xmlfile}..."
         xmldoc = Nokogiri::XML( File.open( "XSLT/xml/#{xmlfile}" ) ) { |config| config.strict }
         rescue Nokogiri::XML::SyntaxError => e
         puts "caught exception: #{e}"
       end

       # get the div with the stuff we want
       div = xmldoc.at('div2')
       if !div.nil?
          nodes = div.element_children
       end

       # special case for one of the files
       if div.nil?
          nodes = xmldoc.at('div1').element_children
       end

       content = ""
       nodes.each do |xml_node|
          case xml_node.name
          when "l"
             content << " "
             content << xml_node.content.split.join(" ")

          when "milestone"
             imgurl = xml_node.attribute('entity')
             if !content.empty?
               solrdoc = { uri: "test-doc", url: '#{imgurl}', section: 'testing', content: '#{content}' }
               solr.add_object( solrdoc, 1, true )
               content = ""
             end
          end
       end
    end

		puts ""
		finish_line(start_time)
	end

end
