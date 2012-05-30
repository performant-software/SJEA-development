class SolrsearchController < ApplicationController

  def dosearch

    @inparams = params
    solr = Solr.factory({ testing: false })
    @results = solr.search( { :q => @inparams[:searchfor], :t => @inparams[:transcription], :f => @inparams[:facet], :rows => 9999 } )

  end

end
