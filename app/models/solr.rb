# encoding: UTF-8

# 'rsolr' documentation at: http://github.com/mwmitchell/rsolr

class Solr
	@@solr = nil
	def self.factory(options = nil)
		@@solr = nil if !options.blank? && options[:force]
		return @@solr if @@solr
		@@solr = Solr.new(options)
		return @@solr
	end

	def initialize(options)
		@verbose = true
		core = options[:core]
		testing = options[:testing]
		if testing == true
			core = "sjea_test"
			@shards = nil
			@verbose = false
		elsif core.kind_of?(Array)
			base_url = SOLR_URL.gsub("http://", "")
			@shards = core.collect { |shard| base_url + '/' + shard }

			core = core[0]
		else
			core = SOLR_CORE if core == nil
			@shards = nil
		end
		@core = "#{SOLR_CORE_PREFIX}/#{core}"
		@solr = RSolr.connect( :url=>"#{SOLR_URL}/#{core}" )
		@field_list = [ "uri", "url", "title", "section" ]
		@highlight_field_list = [ "content" ]
		@facet_fields = ['section']
	end

	def add_highlighting(options)
		return options.merge({ 'hl.fl' => @highlight_field_list, 'hl.fragsize' => 300, 'hl.maxAnalyzedChars' => 512000, 'hl' => true, 'hl.useFastVectorHighlighter' => true })
	end

	def massage_params(options, overrides)
		#fields = overrides[:field_list] ? overrides[:field_list] : @field_list
		#options = add_field_list_param(options, fields)
		##options[:q] = "(#{options[:q]}) OR ((#{options[:q]}) AND status:expert)^10"
		if options[:q].blank?
		   options[:q] = "*:*"
		#	options[:q] = "section:#{overrides[:section]}" if !overrides[:section].blank?
		else
			#options[:q] += " AND section:#{options[:f]}" if !options[:f].blank?
      #options[:q] += " AND title:#{options[:t]}" if !options[:t].blank?
    end
		options = add_highlighting(options)
		return options
	end

	def massage_highlighting(highlighting, docs, key_field)
		# highlighting is returned as a hash of uri to a hash that is either empty or contains 'text' => Array of one string element.
		# We simplify this to return either nil or a string.
		if highlighting
			docs.each { |hit|
				highlight = highlighting[hit[key_field]]
				if highlight
					text = []
					highlight.each {|key,val|
						val.each {|hl|
							text.push(correct_charset(hl))
						}
					}
					hit['highlighting'] = text
				end
			}
		end
	end

	#def group_search(options, overrides = {})
	#	# &group=true&group.field=section&group.limit=5
	#	key_field = overrides[:key_field] ? overrides[:key_field] : 'uri'
	#	options = options.merge({ group: true, 'group.field' => 'section', 'group.limit' => options[:rows]})
	#	options.delete(:rows)
	#	options = massage_params(options, overrides)
	#	ret = select(options)
	#	groups = ret['grouped']['section']['groups']
	#	results = {}
	#	groups.each { |group|
	#		key = group['groupValue']
	#		massage_highlighting(ret['highlighting'], group['doclist']['docs'], key_field)
	#		facets = facets_to_hash(ret) #TODO-PER: This might not be passing the correct data
	#		results[key] = { :total => group['doclist']['numFound'], :hits => group['doclist']['docs'], :facets => facets }
	#	}
	#	return results
	#end

	def search(options, overrides = {})
		key_field = overrides[:key_field] ? overrides[:key_field] : 'uri'
		options = massage_params(options, overrides)
		ret = select(options)

		#massage_hits(ret)
		massage_highlighting(ret['highlighting'], ret['response']['docs'], key_field) if ret

		facets = facets_to_hash(ret)

		return { :total => ret['response']['numFound'], :hits => ret['response']['docs'], :facets => facets }
	end

	def quotify(str)
		return str.include?(' ') && !str.include?('"') ? "\"#{str}\"" : str
	end

	def empty_response()
		return {}
		#return { :total => 0, :hits => [], :facets => {} }
	end

	def facet_search(facet_name, query, rows)
		query = quotify(query)
		return group_search({fq: "+#{facet_name}:#{query}", rows: rows})
	end

	#def match_tags(tag_list, skip_docs, rows, match_all, section = nil)
	#	return empty_response() if tag_list.length == 0
	#	q = tag_list.map { |el|
	#		str = el.to_s
	#		str = quotify(str)
	#		"#{'+' if match_all}tags:#{str}"
	#	}
	#	q.delete_if { |el| el.blank? }
	#	q.push("+section:#{section}") if section
	#	q = q.join(" ")
	#	skips = skip_docs.map { |doc| "NOT uri:#{doc}" }
	#	skips = skips.join(" AND ")
	#	q = "(#{q}) AND #{skips}"
  #
	#	ret = group_search({ q: q, rows: rows })
	#	# TODO-PER: I can't figure out how to get both the tags to count as relevant, but not have them return highlighting, so just suppress the highlighting.
	#	ret.each { |key, value|
	#		value[:hits].each { |hit|
	#			hit.delete('highlighting') if !hit['highlighting'].blank?
	#		}
	#	}
	#	return ret
	#end

	# this is the version that will match as many of the tags as it can, but also return results where not all the tags are matched
	#def match_tags_or(tag_list, skip_doc, rows)
	#	return empty_response() if tag_list.length == 0
	#	q = tag_list.map { |el|
	#		str = el.to_s
	#		str = quotify(str)
	#		"tags:#{str}"
	#	}
	#	q.delete_if { |el| el.blank? }
	#	q = q.join(" ")
	#	q = "(#{q}) AND NOT uri:#{skip_doc}"
	#
	#	ret = group_search({ q: q, rows: rows })
	#	# TODO-PER: I can't figure out how to get both the tags to count as relevant, but not have them return highlighting, so just suppress the highlighting.
	#	ret.each { |key, value|
	#		value[:hits].each { |hit|
	#			hit.delete('highlighting') if !hit['highlighting'].blank?
	#		}
	#	}
	#	return ret
	#end

	def correct_charset(v)
		# TODO:PER: Shouldn't have to do this, I think.
		return v.force_encoding("UTF-8")
	end

	def auto_complete(fragment, max)
		field = "content"
		options = { :q => '*:*' }
		options[:start] = 0
		options[:rows] = 0
		options = add_facet_param(options, [field], fragment)
		response = select(options)
		words = facets_to_hash(response)[field]

		words.sort! { |a,b| b[:count] <=> a[:count] }
		words = words[0..(max-1)]
		results = words.map { |word|
			{ :item => word[:name], :occurrences => word[:count] }
		}

		return results
	end

	def remove_objects(query, commit_now)
		begin
			@solr.delete_by_query(query)
			if commit_now
				commit()
			end
		rescue Exception => e
			raise SolrException.new(e.to_s)
		end
	end

	def clear_all(commit_now=true)
		remove_objects("*:*", commit_now)
	end

	def commit()
		@solr.commit() # :wait_searcher => false, :wait_flush => false, :shards => @cores)
	end

	def optimize()
		@solr.optimize() #(:wait_searcher => true, :wait_flush => true)
	end

	def add_object(fields, relevancy, commit_now, is_retry = false)
		# this takes a hash that contains a set of fields expressed as symbols, i.e. { :uri => 'something' }
		begin
			if relevancy
				@solr.add(fields) do |doc|
					doc.attrs[:boost] = relevancy # boost the document
				end
				add_xml = @solr.xml.add(fields, {}) do |doc|
					doc.attrs[:boost] = relevancy
				end
				@solr.update(:data => add_xml)
			else
				@solr.add(fields)
			end
		rescue Exception => e
			puts("ADD OBJECT: Continuing after exception: #{e}")
			puts("URI: #{fields['uri']}")
			puts("#{fields.to_s}")
			if is_retry == false
				add_object(fields, relevancy, commit_now, true)
			else
				raise SolrException.new(e.to_s)
			end
		end
		begin
			if commit_now
				@solr.commit()
			end
		rescue Exception => e
			raise SolrException.new(e.to_s)
		end
	end

	private
	def select(options)
		options['version'] = '2.2'
		options['defType'] = 'edismax'
		if @shards
			options[:shards] = @shards.join(',')
		end
		begin
			ret = @solr.post( 'select', :data => options )
		rescue Errno::ECONNREFUSED => e
			raise SolrException.new("Cannot connect to the search engine at this time.")
		rescue RSolr::Error::Http => e
			raise SolrException.new(e.to_s)
		end
		uri = ret.request[:uri].to_s
		arr = uri.split('/')
		index = arr[arr.length-2]
		puts "SOLR: [#{index}] #{ret.request[:data]}" if @verbose

		return ret
	end

	def add_facet_param(options, fields, prefix = nil)
		# the three ways to call this are, regular search, where the prefix is nil,
		# name search, where the prefix is "", and autocomplete, where the prefix is passed in.
		options[:facet] = true
		options["facet.field"] = fields
		options["facet.mincount"] = 1
		options["facet.limit"] = -1
		if prefix
			if prefix != ""
				options["facet.method"] = 'enum'
				options["facet.prefix"] = prefix
			end
			options["facet.missing"] = false
		else
			options["facet.missing"] = true
		end
		return options
	end

	def add_field_list_param(options, fields)
		options[:fl] = fields.join(' ')
		return options
	end

	def facets_to_hash(ret)
		# make the facets more convenient. They are returned as a hash, with each key being the facet type.
		# Then the value is an array. The values of the array alternate between the name of the facet and the
		# count of the number of objects that match it. There is also a nil value that needs to be ignored.
		facets = {}
		if ret && ret['facet_counts'] && ret['facet_counts']['facet_fields']
			ret['facet_counts']['facet_fields'].each { |key,raw_list|
				facet = []
				name = ''
				raw_list.each { |item|
					if name == ''
						name = item
					else
						if name != nil
							facet.push({ :name => name, :count => item })
						end
						name = ''
					end
				}
				facets[key] = facet
			}
		end
		return facets
	end
end
