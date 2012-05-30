require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

template = "<!DOCTYPE html>
<html>

  <head>
    <title> Siege of Jerusalem Electronic Archive</title>

    <link href=\"stylesheets/sjea-common.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />
    <link href=\"stylesheets/sjea-manuscripts.css\" media=\"screen\" rel=\"stylesheet\" type=\"text/css\" />

    <script src=\"javascripts/jquery-1.7.2.min.js\" type=\"text/javascript\"></script>
    <script src=\"javascripts/manuscripts.js\" type=\"text/javascript\"></script>
    <script src=\"javascripts/ZoomifyImageViewer.js\" type=\"text/javascript\"></script>

    <style type=\"text/css\"> #zoom-div { width:800px; height:950px; margin:auto; border:1px; border-style:solid; border-color:#696969;} </style>
    <script type=\"text/javascript\"> Z.showImage(\"zoom-div\", \"images/zoom/XXX\", \"\"); </script>

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

              <div id=\"zoom-div\"></div>

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

  #
  # Regenerates the zoom image pages...
  #

  desc "Regenerate the zoom pages for each image."
  task :regenzoom => :environment do
    start_time = start_line("Regenerate the zoom pages for each image.")

    srcdir = "public/images"
    dstdir = "public"

    files = Dir.glob( "#{srcdir}/*.jpg" )

    files.each do |fname|

      basename = fname.split( "/" )[ 2 ].gsub(/^(.*).jpg$/, '\1')

      # if this is a manuscript image...
      if basename =~ /^[A-Z]\d{3}[a-z]$/

         outfile = "#{dstdir}/#{basename}-image.html"
         delete_file( outfile )
         append_to_file( outfile, template.gsub( "XXX", basename ) )

      end

    end

    finish_line(start_time)
  end

end