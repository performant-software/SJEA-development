# encoding: UTF-8

require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

	desc "Regenerate the solr index."
	task :regensearch => :environment do
		start_time = start_line("Regenerate the solr index.")

    solr = Solr.factory({ testing: false, force: true })
    solr.clear_all(false)

    docname_ix = 0
    docnames = transcript_title_list( )

    transcription_file_list( ).each do |fname|

       puts "processing #{fname}..."
       page_count = 0

       xmlfile = "XSLT/xml/#{fname}.xml"

       begin
         xmldoc = Nokogiri::XML( File.open( xmlfile ) ) { |config| config.strict }
         rescue Nokogiri::XML::SyntaxError => e
         puts "caught exception processing #{xmlfile}: #{e}"
       end

       # get the div with the stuff we want
       div = xmldoc.at('div2')
       if !div.nil?
          nodes = div.element_children
          #puts "standard: #{nodes.size} nodes"
       end

       # special case for one of the files
       if div.nil?
          nodes = xmldoc.at('div1').element_children
         #puts "special: #{nodes.size} nodes"
       end

       content = ""

       nodes.each do |xml_node|
         #puts xml_node.name
          case xml_node.name
          when "l"
             content << xml_node.content.split.join(" ") << "\n"

          when "milestone"
             if !content.empty?

               entity = xml_node.attribute('entity')
               pageuri = "#{fname}-#{entity}"
               imgurl = "/images/#{entity}"

               solrdoc = { uri: pageuri, url: imgurl, title: docnames[docname_ix], section: "transcriptions", content: content }
               solr.add_object( solrdoc, 1, false )
               #puts "Added: [#{imgurl}]: [#{content}]"
               #puts "***********************************************************************"
               content = ""
               page_count += 1
             end
          end
       end

       solr.commit( )
       puts "loaded #{page_count} pages."
       docname_ix += 1

    end

		puts ""
		finish_line(start_time)
	end

end
