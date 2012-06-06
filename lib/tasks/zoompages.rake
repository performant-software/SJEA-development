require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

fs_template = "<!DOCTYPE html>
<html>

  <head>
    <title> Siege of Jerusalem Electronic Archive</title>

    <link href=\"/stylesheets/sjea-common.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />

    <script src=\"/javascripts/jquery-1.7.2.min.js\" type=\"text/javascript\"></script>
    <script src=\"/javascripts/ZoomifyImageViewer.js\" type=\"text/javascript\"></script>

    <script type=\"text/javascript\">
       $(document).ready(function() {
          Z.showImage(\"zoom-image-div\", \"images/zoom/_FOLIONAME_\", \"\");
       });
    </script>

  </head>

  <body>

    <div id=\"page\">

      <div id=\"main-header\">
          <h1>The Siege of Jerusalem Electronic Archive</h1>
      </div> <!-- main-header -->

      <div id=\"main-title\">
      </div>  <!-- main-title -->

      <div id=\"sidebar\">
      </div>  <!-- sidebar -->

      <div id=\"content\">

          <div id=\"content-display\">

              <div id=\"zoom-image-div\"></div>
              <div id=\"copyright-div\">
                 <span>_COPYRIGHT_</span>
              </div>

          </div>  <!-- content-display -->

          <div id=\"footer-spacer\">
          </div>  <!-- footer-spacer -->

      </div>  <!-- content -->

    </div>  <!-- page -->

    <div id=\"main-footer\">
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis posuere ultrices laoreet. Maecenas lacus sapien, tristique ultrices ultrices eu, vestibulum et sem. Nunc eu augue neque, eu congue turpis. Cras vulputate lacus iaculis eros vehicula tincidunt. Suspendisse viverra accumsan ipsum et suscipit. Cras eu tellus nunc. Nam blandit congue lorem vitae faucibus. Nunc at congue libero. Nam et lorem nisl. In laoreet sodales nunc. Quisque egestas, urna et commodo posuere, turpis diam ultricies mauris, id condimentum dui tortor fermentum ante.</p>
    </div> <!-- main-footer -->

  </body>

</html>
"

  lb_template = "<!DOCTYPE html>
  <html>

    <head>
      <title> Siege of Jerusalem Electronic Archive</title>

      <link href=\"/stylesheets/sjea-common.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />

      <script src=\"/javascripts/jquery-1.7.2.min.js\" type=\"text/javascript\"></script>
      <script src=\"/javascripts/ZoomifyImageViewer.js\" type=\"text/javascript\"></script>

      <script type=\"text/javascript\">
         $(document).ready(function() {
            Z.showImage(\"zoom-image-div\", \"images/zoom/_FOLIONAME_\", \"\");
         });
      </script>

    </head>

    <body>

        <div id=\"zoom-image-div\"></div>
        <div id=\"copyright-div\">
           <span>_COPYRIGHT_</span>
        </div>
        <div id=\"open-new-zoom-window\">
           <a href=\"/_FOLIONAME_-fs.html\" target=\"_blank\">New window</a>
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

         outfile = "#{dstdir}/#{basename}-fs.html"
         delete_file( outfile )
         content = fs_template.gsub( "_COPYRIGHT_", copyrightlist[ basename.gsub(/^(.*)\d{3}[a-z]$/, '\1') ] )
         content = content.gsub( "_FOLIONAME_", basename )
         append_to_file( outfile, content )

         outfile = "#{dstdir}/#{basename}-lb.html"
         delete_file( outfile )
         content = lb_template.gsub( "_COPYRIGHT_", copyrightlist[ basename.gsub(/^(.*)\d{3}[a-z]$/, '\1') ] )
         content = content.gsub( "_FOLIONAME_", basename )
         append_to_file( outfile, content )

      end

    end

    finish_line(start_time)
  end

end
