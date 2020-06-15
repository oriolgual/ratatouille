# frozen_string_literal: true

module Ratatouille
  module Importers
    class TastyRecipes
      attr_reader :page, :json_schema

      def initialize(page)
        @page = page
        @json_schema = JsonSchema.new(page)
      end

      def valid?
        page.content.css(".tasy-recipes-title").any?
      end

      def name
        json_schema.name
      end

      def ingredients
        json_schema.ingredients
      end

      def directions
        json_schema.directions
      end

      def servings
        json_schema.servings
      end

      def prep_time
        json_schema.prep_time
      end

      def cook_time
        json_schema.cook_time
      end

      def total_time
        json_schema.total_time
      end

      def url
        json_schema.url
      end

      def nutrition
        json_schema.nutrition
      end

      def description
        page.content.css('.tasty-recipes-description').first.text
      end

      def images
        page.content.css('article .entry-content img').map{|i| i['src']}.reject{|url| url.match?('gravatar') }
      end

      def notes
        page.content.css('.tasty-recipes-notes ul li').map(&:text)
      end
    end
  end
end
