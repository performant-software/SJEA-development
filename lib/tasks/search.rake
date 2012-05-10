# encoding: UTF-8

require "#{Rails.root}/lib/tasks/task_utilities"

namespace :search do
	include TaskUtilities

	desc "Completely reindex everything with solr"
	task :recreate => :environment do
		start_time = start_line("Recreate solr index using all data in the database.")

    solr = Solr.factory({ testing: false, force: true })
    solr.clear_all(false)

    doc = { uri: "test-doc", url: 'http:google.com', section: 'testing', content: 'Now is the time'  }
    solr.add_object(doc, 1, true)
    solr.commit()

		puts ""
		finish_line(start_time)
	end

end
