
class PaleoKetoCli::Recipe
    attr_accessor :name, :description, :link, :ingredients
  
    @@all = []
  
    def initialize(name, link)
      @name = name
      @link = link
      @ingredients = []
      @@all << self
    end
  
    def self.all
      @@all
    end
  
    def self.reset_all
      self.all.clear
    end
  
  end
  