class SolrsearchController < ApplicationController

  def dosearch

    @inparams = params

    # pagination stuff
    page = 1
    page = @inparams[:page].to_i unless @inparams[:page].nil?

    # generate our search interface and issue the query
    solr = Solr.factory({ testing: false })
    @results = solr.search( { :q => @inparams[:searchfor], :t => @inparams[:transcription], :f => @inparams[:facet], :page => page, :rows => 10 } )

  end

end
