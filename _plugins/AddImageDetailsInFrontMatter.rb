require 'fastimage'

module Jekyll
  # Defines the base class of AMP posts
  require_relative 'slugify_url'
  class ImagePost < Page
    
    def initialize(site, base, dir, post)
      @site = site
      @base = base
      @dir = dir
      # Needed for posts with permalink
      @url = dir
      @name = 'index.html'
      image_path = nil
      [".png",".jpg", ".jpeg",".gif"].each do |f|
        next if !image_path.nil?
        image_path = string_between_markers(post.to_s,'(/uploads/' , f)  rescue nil
        image_path += f if !image_path.nil?        
      end
    
     # image_path += '.png' if !image_path.nil?
    
     # image_path = (string_between_markers(post.to_s,'[](/uploads/' , '.jpg') rescue nil) if image_path.nil?
     # image_path += '.jpg' if !image_path.nil?
     
     # image_path = (string_between_markers(post.to_s,'[](/uploads/' , '.jpeg') rescue nil) if image_path.nil?
     # image_path += '.jpeg' if !image_path.nil?
     
     # image_path = (string_between_markers(post.to_s,'[](/uploads/' , '.gif') rescue nil) if image_path.nil?
     # image_path += '.gif' if !image_path.nil?
     
     return if image_path.nil?
     post.data["image_file_name"] = image_path
     
      begin
            image_path = 'uploads/' + image_path
            size = FastImage.size(image_path)
            post.data["og_image_width"]  = size[0]
            post.data["og_image_height"] = size[1]
          rescue Exception => e
            puts 'Unable to get image dimensions for "' + image_path + '". For local files, build the site with \'--skip-initial-build\' for better results. [Error: ' + e.to_s + ']'
          end
           

    end

    def string_between_markers str, marker1, marker2
          str[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1] 
    end

  end

  class UrlGeneratorV1 < Page
      def initialize(post) 
            post.data["permalink"] = post.data["title"].urlize if post.data["permalink"].nil?
      end
  end 

  # Generates a new AMP post for each existing post
  class ImageProcessor < Generator
    priority :low
    def generate(site)
      dir = 'uploads'
      site.posts.docs.each do |post|
         ImagePost.new(site, site.source, dir, post)
         UrlGeneratorV1.new(post)
      end
    end
  end
end
