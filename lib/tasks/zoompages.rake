require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

fs_template = "<!DOCTYPE html>
<html>

  <head>
    <title> Siege of Jerusalem Electronic Archive</title>

    <link href=\"/stylesheets/sjea-common.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />
    <link href=\"/stylesheets/sjea-manuscripts.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />

    <script src=\"/javascripts/jquery-1.7.2.min.js\" type=\"text/javascript\"></script>
    <script src=\"/javascripts/ZoomifyImageViewer.js\" type=\"text/javascript\"></script>

    <link href=\"http://fonts.googleapis.com/css?family=Signika+Negative\" rel=\"stylesheet\" type=\"text/css\">

    <script type=\"text/javascript\">
       $(document).ready(function() {
          Z.showImage(\"fs-zoom-image-div\", \"images/zoom/_FILENAME_\", \"\");
       });
    </script>

  </head>

  <body>

    <div id=\"page\">

      <div id=\"page-header\">
          <div id=\"background-graphic\"></div>
          <div id=\"logo-graphic\"></div>
          <div id=\"title-graphic\"></div>
          <div id=\"title-support\">ELECTRONIC ARCHIVE</div>
          <div id=\"editor-name\">Timothy L. Stinson, editor</div>
      </div> <!-- page-header -->

      <div id=\"fs-zoom-image-div\"></div>
      <div id=\"copyright-div\">
         <a>_COPYRIGHT_</a>
      </div>

    </div>  <!-- page -->

    <div id=\"main-footer\">
        <p>&copy;The Society for Early English and Norse Electronic Texts, 2012. Use of this site is subject to the following <a id=\"terms\" href=\"/index.html?page=terms\">terms and conditions</a>.</p>
    </div> <!-- main-footer -->

  </body>

</html>
"

  lb_template = "<!DOCTYPE html>
  <html>

    <head>
      <title> Siege of Jerusalem Electronic Archive</title>

      <link href=\"/stylesheets/sjea-common.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />
      <link href=\"/stylesheets/sjea-manuscripts.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />

      <script src=\"/javascripts/jquery-1.7.2.min.js\" type=\"text/javascript\"></script>
      <script src=\"/javascripts/ZoomifyImageViewer.js\" type=\"text/javascript\"></script>

      <link href=\"http://fonts.googleapis.com/css?family=Signika+Negative\" rel=\"stylesheet\" type=\"text/css\">

      <script type=\"text/javascript\">
         $(document).ready(function() {
            Z.showImage(\"lb-zoom-image-div\", \"images/zoom/_FILENAME_\", \"\");
         });
      </script>

    </head>

    <body>

        <div id=\"lb-zoom-image-div\"></div>
        <div id=\"copyright-div\">
           <span>_COPYRIGHT_</span>
        </div>
        <div id=\"open-new-zoom-window\">
           <a href=\"/_FILENAME_-fs.html\" target=\"_blank\">New window</a>
        </div>
    </body>

  </html>
  "

  #
  # Regenerates the zoom image pages...
  #

  desc "Regenerate the zoom pages for each image."
  task :regenzoom => :environment do
    start_time = start_line("Regenerate the zoom pages for each image.")

    srcdir = "public/images"
    dstdir = "public"

    copyrightlist = Hash.new
    filenames = transcription_file_list( )
    copyrights = copyright_text_list( )
    filenames.size.times { |ix| copyrightlist[filenames[ix].gsub(/^SJ(.*)$/, '\1')] = copyrights[ix] }

    files = Dir.glob( "#{srcdir}/*.jpg" )

    files.each do |fname|

      basename = fname.split( "/" )[ 2 ].gsub(/^(.*).jpg$/, '\1')

      # if this is a manuscript image...
      if basename =~ /^[A-Z]{1}[a-z]?\d{3}[a-z]$/

         prefix = basename.gsub(/^(.*)\d{3}[a-z]$/, '\1')
         folio = basename.gsub(/^.*(\d{3}[a-z])$/, '\1').sub(/^[0]*/,"")

         outfile = "#{dstdir}/#{basename}-fs.html"
         delete_file( outfile )
         content = fs_template.gsub( "_COPYRIGHT_", copyrightlist[ prefix ] )
         content = content.gsub( "_FILENAME_", basename )
         content = content.gsub( "_FOLIONAME_", folio )
         append_to_file( outfile, content )

         outfile = "#{dstdir}/#{basename}-lb.html"
         delete_file( outfile )
         content = lb_template.gsub( "_COPYRIGHT_", copyrightlist[ prefix ] )
         content = content.gsub( "_FILENAME_", basename )
         content = content.gsub( "_FOLIONAME_", folio )
         append_to_file( outfile, content )

      end

    end

    finish_line(start_time)
  end

end
