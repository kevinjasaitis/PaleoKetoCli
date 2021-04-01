class PaleoKetoCli::CLI

    attr_accessor :exit, :recipe, :month
  
    SEPARATOR = "---------------------------------------------------"
  
    def initialize
      @exit = false
    end
  
    def call
      self.user_interface
    end
  
    def user_interface
      inner_menu_flag = false
      puts SEPARATOR
      self.greeting
      puts SEPARATOR
      self.list_month_recipes
      puts SEPARATOR
      self.select_recipe
      self.show_recipe_summary
      while !self.exit
        puts SEPARATOR
        inner_menu_flag ? self.inner_menu : self.menu
        print "> ".colorize(:red)
        case input = gets.chomp.downcase
        when "main"
          inner_menu_flag = false
          puts SEPARATOR
          self.list_month_recipes
          puts SEPARATOR
          self.recipe = nil
          self.select_recipe unless exit
          self.show_recipe_summary unless exit
        when "prep"
          if !PaleoKetoCli::Recipe.all.empty?
            puts SEPARATOR
            self.show_ingredients_call
            inner_menu_flag = true
          end
        when "exit"
          self.exit = true
        end
      end
      puts SEPARATOR
      puts "Thank you for using PaleoKetoCli, have a great day!"
      puts SEPARATOR
    end
  
    def greeting
      puts "Welcome to PaleoKetoCli. An excellent source of wonderful paleo and keto recipes."
      puts "Information from: veganricha.com!"
    end
  
    def menu
      puts "Type 'prep' to get cooking!"
      puts "Type 'main' to go back to the beginning."
      puts "Type 'exit' to quit the program."
    end
  
    def inner_menu
      puts "Type main to go back to the beginning."
      puts "Type exit to quit the program."
    end

    def list_month_recipes
        self.month = nil
        puts "Please select a month between 2020/01 and 2021/03 or type exit. (months are 01 - 12, if you put above 13 they will still be December)."
        bad_month = true
        while bad_month && !self.exit
          print "> ".colorize(:red)
          input = gets.chomp
          if input.match?(/202[0-1]\/\d/)
            self.month = input
            puts "Recipes for this month are:"
            puts SEPARATOR
            self.get_month_recipes
            bad_month = false
          elsif input == "exit"
           self.exit = true
          else
            puts "Please enter a valid month"
          end
        end
      end

      def get_month_recipes
        PaleoKetoCli::Recipe.reset_all
        PaleoKetoCli::Scraper.create_by_month(self.month).create_recipes
        PaleoKetoCli::Recipe.all.each.with_index(1) do |recipe, index|
          puts "#{index}. #{recipe.name}"
        end
      end

      def select_recipe  #sets recipe to an instance
        if !PaleoKetoCli::Recipe.all.empty?
          selection = nil
          puts "Please enter the number of the recipe you wish to get more details: (or type exit)"
          bad_number = true
          while bad_number && !self.exit
            print "> ".colorize(:red)
            selection = gets.chomp
            puts SEPARATOR
            if selection.to_i > 0 && selection.to_i <= PaleoKetoCli::Recipe.all.length
              bad_number = false
              self.recipe = PaleoKetoCli::Recipe.all[selection.to_i - 1]
            elsif selection == "exit"
              self.exit = true
            else
              puts "Please enter a valid selection:"
            end
          end
        end
      end

      def show_recipe_summary
        if !self.recipe.nil?
          self.get_description
          puts "Name:"
          puts self.recipe.name
          puts "Description:"
          puts self.recipe.description
        end
      end

       def get_description
      self.recipe.description = PaleoKetoCli::Scraper.scrape_by_recipe(self.recipe).add_description
    end

    def show_ingredients_call
        self.get_ingredients
        self.show_ingredients
      end
  
    def get_ingredients
      scrape = PaleoKetoCli::Scraper.scrape_by_recipe(self.recipe)
      scrape.add_ingredients
    end
  
 
  
    def show_ingredients
      puts "Ingredients:"
      puts SEPARATOR
      self.recipe.ingredients.each.with_index(1) do |ing, i|
        print "#{i}. "
        ing.each do |k, v|
          print "#{v} " unless v == ""
        end
        puts ""
      end
      puts SEPARATOR
    end
  
    
  
  
  
    
  
   
  
   
  
  
  
  end
  