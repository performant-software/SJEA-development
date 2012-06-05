require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

	desc "Regenerate the solr index."
	task :regensearch => :environment do
		start_time = start_line("Regenerate the solr index.")

    solr = Solr.factory({ testing: false, force: true })
    solr.clear_all( false )

    # create a hash of names using the transcription file as a key
    docnames = Hash.new
    filenames = transcription_file_list( )
    titles = transcript_title_list( )
    filenames.size.times { |ix| docnames[filenames[ix]] = titles[ix] }

    puts "loading transcriptions..."
    # do each of the transcription files individually
    transcription_file_list( ).each do |fname|

       xmlfile = "XSLT/xml/#{fname}.xml"

       lines = load_transcription_from_file( xmlfile )
       #puts "#{fname}: #{lines.size} lines loaded"

       content = ""
       current_img_file_name = ""
       pageuri = ""
       imgurl = ""
       page_count = 0

       lines.each do |line|

          # a new page...
          if current_img_file_name != line[:pageimg]
            if content.empty? == false
              solrdoc = { uri: pageuri, url: imgurl, title: docnames[fname], section: "transcriptions", content: content }
              solr.add_object( solrdoc, 1, false )
              page_count += 1
            end

            current_img_file_name = line[:pageimg]
            pageuri = current_img_file_name
            imgurl = "/images/#{current_img_file_name}"
            content = line[:content]
          else
            content << " " << line[:content]
          end

       end

       if content.empty? == false
         solrdoc = { uri: pageuri, url: imgurl, title: docnames[fname], section: "transcriptions", content: content }
         solr.add_object( solrdoc, 1, false )
         page_count += 1
       end

       solr.commit( )
       #puts "#{fname}: #{page_count} pages loaded"
    end

    puts "loading annotations..."
    # do each of the transcription files individually
    transcription_file_list( ).each do |fname|

       xmlfile = "XSLT/xml/#{fname}.xml"

       pages = load_annotations_from_file( xmlfile )
       #puts "#{fname}: #{pages.size} pages loaded"

       pageuri = ""
       imgurl = ""
       page_count = 0

       pages.each do |page|

            current_img_file_name = page[:pageimg]
            pageuri = current_img_file_name
            imgurl = "/images/#{current_img_file_name}"
            content = page[:content]
            solrdoc = { uri: pageuri, url: imgurl, title: docnames[fname], section: "annotations", content: content }
            solr.add_object( solrdoc, 1, false )
            page_count += 1

       end

       solr.commit( )
       #puts "#{fname}: #{page_count} pages loaded"

    end

    puts "loading descriptions..."
    # create a hash of names using the description file as a key
    docnames = Hash.new
    filenames = description_file_list( )
    titles = transcript_title_list( )
    filenames.size.times { |ix| docnames[filenames[ix]] = titles[ix] }

    # do each of the description files individually
    description_file_list( ).each do |fname|

       xmlfile = "XSLT/xml/#{fname}.xml"

       lines = load_description_from_file( xmlfile )
       #puts "#{fname}: #{lines.size} lines loaded"

       content = ""
       pageuri = "#{fname}-description"
       page_count = 0

       lines.each do |line|
         content << " " << line
       end

       if content.empty? == false
         solrdoc = { uri: pageuri, url: "", title: docnames[fname], section: "descriptions", content: content }
         solr.add_object( solrdoc, 1, false )
         page_count += 1
       end

       solr.commit( )
       #puts "#{fname}: #{page_count} pages loaded"

    end

		puts ""
		finish_line(start_time)
	end

end
