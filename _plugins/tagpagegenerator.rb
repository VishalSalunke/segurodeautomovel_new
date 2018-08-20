module Jekyll
  class CategoryPage < Page
    def initialize(site, base, dir, name, pageType)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tagLayout.html')
      self.data[pageType] = name
      self.data['title'] = "#{name.to_s.capitalize} - #{Jekyll.configuration({})['webName']}"
      self.data['postType'] = name
      self.data['pagination'] = {}
      self.data['pagination']["enabled"] = true
      self.data['pagination'][pageType] = name 
      self.data['description'] = "Artigos relacionados à - #{name.to_s.capitalize}"
     
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tagLayout'
          dir = site.config['tag'] || 'tag'
          skipTags = Jekyll.configuration({})['blacklistedTags'] 
          site.tags.each_key do |tag|
            next if skipTags.to_s.downcase.include? tag.to_s.downcase
            slugTag = tag.to_s.downcase.gsub(" ","-")
            site.pages << CategoryPage.new(site, site.source, File.join(dir, slugTag), tag,'tag')
          end
      end
    end
  end


  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tagLayout'
        site.categories.each_key do |category|
          case category
          when "Cidades","Modelos de carro"
            slugTag = "artigos/"+category.to_s.downcase.gsub(" ","-") 
          when "Diretório"
            slugTag = "diretorio"
          when "Avaliações"
            slugTag = "diretório"  
          else
             slugTag = category.to_s.downcase.gsub(" ","-") 
          end
          site.pages << CategoryPage.new(site, site.source, File.join(slugTag), category,'category')
        end
      end
    end
  end
end