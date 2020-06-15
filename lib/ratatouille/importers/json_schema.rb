# frozen_string_literal: true

require 'json/ld'
require "byebug"

module Ratatouille
  module Importers
    class JsonSchema
      attr_reader :page

      def initialize(page)
        @page = page
      end

      def name
        recipe["name"]
      end

      def description
        recipe["description"]
      end

      def ingredients
        recipe["recipeIngredient"].map do |recipe_ingredient|
          ingredient, amount = recipe_ingredient.split(":")
          "#{amount.to_s.strip} #{ingredient.to_s.strip.downcase}".strip
        end
      end

      def directions
        directions = recipe["recipeInstructions"]

        if directions.is_a?(String)
          directions.split("\n")
        elsif directions.is_a?(Array)
          directions.flat_map do |step|
            if step.is_a?(String)
              step.split("\n")
            else
              step["text"]
            end
          end
        else
          nil
        end
      end

      def servings
        Array(recipe["recipeYield"]).first
      end

      def prep_time
        convert_duration recipe["prepTime"]
      end

      def cook_time
        convert_duration recipe["cookTime"]
      end

      def total_time
        convert_duration recipe["totalTime"]
      end

      def nutrition
        return [] if !recipe["nutrition"] || !recipe["nutrition"].is_a?(Hash)

        [
          "Fat: #{recipe["nutrition"]["fatContent"]}",
          "Carbs: #{recipe["nutrition"]["carbohydrateContent"]}",
          "Fiber: #{recipe["nutrition"]["fiberContent"]}",
          "Sugar: #{recipe["nutrition"]["sugarContent"]}",
          "Protein: #{recipe["nutrition"]["proteinContent"]}",
          "Calories: #{recipe["nutrition"]["calories"]}",
          "Serving size: #{recipe["nutrition"]["servingSize"]}"
        ]
      end

      def url
        recipe["url"] || page.url
      end

      def images
        Array(recipe["image"])
      end

      def valid?
        recipe != nil
      end

      private

      def recipe
        return @recipe if defined?(@recipe)

        recipe = nil

        page.xpath("//script [@type='application/ld+json']").each do |json|
          begin
            ld_data = JSON.parse(json.text)
            ld_data = ld_data.first if ld_data.is_a?(Array)

            recipe = if ld_data["@type"].to_s == "Recipe"
                       ld_data
                     elsif ld_data["@graph"]
                       ld_data["@graph"].find{|element| element["@type"] == "Recipe"}
                     end
          rescue JSON::ParserError
            nil
          end
        end

        return unless recipe
        @recipe = recipe
      end

      def convert_duration(raw_duration)
        regex = /^P(?!$)(\d+(?:\.\d+)?Y)?(\d+(?:\.\d+)?M)?(\d+(?:\.\d+)?W)?(\d+(?:\.\d+)?D)?(T(?=\d)(\d+(?:\.\d+)?H)?(\d+(?:\.\d+)?M)?(\d+(?:\.\d+)?S)?)?$/

        match = raw_duration.to_s.match(regex)
        return unless match

        hours   = match[6].to_i
        minutes = match[7].to_i
        "#{minutes + (60 * hours)} minutes"
      end
    end
  end
end
