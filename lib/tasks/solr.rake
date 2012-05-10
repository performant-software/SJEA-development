namespace :solr do
	def cmd_line(str)
		puts str
		puts `#{str}`
	end

	def get_solr_port
		arr = SOLR_URL.split('/')
		arr.each { |str|
			if str.index('localhost:')
				arr2 = str.split(':')
				return arr2[1]
			end
		}
		return '0000'
	end

	desc "Start the solr java app (Prerequisite for running AES) [param: size=big if indexing something large]"
	task :start  => :environment do
		sz = ENV["size"]
		if sz && sz == 'big'
			sz = "5120"
		else
			sz = "1280"
		end
		port = get_solr_port()
		puts "~~~~~~~~~~~ Starting solr on #{port}..."
		cmd_line("cd #{SOLR_PATH} && java -Djetty.port=#{port} -DSTOP.PORT=8079 -DSTOP.KEY=AES -Xmx#{sz}m -jar start.jar 2> #{Rails.root}/log/solr.log &")
	end

	desc "Stop the solr java app"
	task :stop  => :environment do
		puts "~~~~~~~~~~~ Stopping solr..."
		port = get_solr_port()
		cmd_line("cd #{SOLR_PATH} && java -Djetty.port=#{port} -DSTOP.PORT=8079 -DSTOP.KEY=AES -jar start.jar --stop")
		puts "Finished."
	end

	desc "Optimize the index passed in [core=XXX]"
	task :optimize => :environment do
		core = ENV['core']
		if core == nil
			puts "Usage: pass in core=XXX"
		else
			puts "~~~~~~~~~~~ Optimize #{core}..."
			start_time = Time.now
			index = Solr.new({ :core => core })
			index.optimize()
			puts "Finished in #{(Time.now-start_time)/60} minutes."
		end
	end
end
