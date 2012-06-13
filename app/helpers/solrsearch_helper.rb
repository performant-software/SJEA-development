module SolrsearchHelper

  def makeTitleHTML( uri, title )

    # default case is to return the title undecorated...
    displayHTML = title

    # create the result link
    resultURL = makeResultURL( uri, title )

    case uri.split( "-" )[ 0 ]

      # annotation hit...
      when "an"
        # remove manuscript designator and any leading zeros
        folio = uri.split( "-" )[ 1 ].gsub(/^.*(\d{3}[a-z])$/, '\1').sub(/^[0]*/,"")
        displayHTML = "#{title} : annotation <a href=\"#{resultURL}\">[folio #{folio}]</a>"

      # description hit...
      when "de"
        displayHTML = "#{title} : <a href=\"#{resultURL}\">description</a>"

      # transcription hit...
      when "tx"
        # remove manuscript designator and any leading zeros
        folio = uri.split( "-" )[ 1 ].gsub(/^.*(\d{3}[a-z])$/, '\1').sub(/^[0]*/,"")
        displayHTML = "#{title} : transcription body <a href=\"#{resultURL}\">[folio #{folio}]</a>"

    end

    return displayHTML

  end

  def makeResultURL( uri, title )

    # default case is to return to a new search page...
    resultURL = "/search.html"

    # extract the manuscript identifier from the title...
    manuscript = "SJ#{title.gsub(/^.*\((.*)\)$/, '\1')}"

    case uri.split( "-" )[ 0 ]

      # description hit...
      when "de"
        resultURL = "/manuscript.html?description=#{manuscript}"

      # transcription or annotation hit...
      when "tx", "an"
        folio = uri.split( "-" )[ 1 ]
        resultURL = "/manuscript.html?manuscript=#{manuscript}&view=alltags&folio=#{folio}"

    end

    return resultURL

  end

end
