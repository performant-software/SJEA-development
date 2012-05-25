require "#{Rails.root}/lib/tasks/task_utilities"

namespace :sjea do
	include TaskUtilities

  #
  # Regenerates the image thumbnails
  #

  desc "Regenerate the image thumbnails from the full size jpegs"
  task :regenthumbs => :environment do
    start_time = start_line("Regenerate the image thumbnails from the full size jpegs.")

    srcdir = "public/images"
    dstdir = "public/images"

    thumb_x = 140
    thumb_y = 165

    files = Dir.glob( "#{srcdir}/*.jpg" )

    files.each do |fname|

      basename = fname.split( "/" )[ 2 ].gsub(/^(.*).jpg$/, '\1')

      # if this is not already a thumbnail...
      if not basename =~ /thumbnail/

        outfile = "#{dstdir}/#{basename}-thumbnail.jpg"
        delete_file( outfile )

        cmd = "sips -z #{thumb_y} #{thumb_x} #{fname} --out #{outfile}"
        cmd_line( cmd )

      end

    end

    finish_line(start_time)
  end

end
