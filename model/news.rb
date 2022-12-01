class NewsModel
    attr_accessor :title, :description, :link, :pubDate

    def to_map(title, description, link, pubDate)
        return JSON.generate({ 
            :title => title, 
            :description => description, 
            :link => link, 
            :pubDate => pubDate
        })
    end 
end