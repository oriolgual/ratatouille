# frozen_string_literal: true

module Ratatouille
  module Importers
    class EasyRecipe
      attr_reader :page, :json_schema

      def initialize(page)
        @page = page
        @json_schema = EmbedJsonSchema.new(page.css(".easyrecipe").first)
      end

      def valid?
        page.css(".easyrecipe").any? && json_schema.valid?
      end

      def name
        page.text_of('.ERSName')
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
        page.url
      end

      def nutrition
        json_schema.nutrition
      end

      def description
        page.text_of('.ERSNotes')
      end

      def images
        page.css('article .entry-content img').map{|i| i['src']}.reject{|url| url.match?('gravatar') }
      end

      def notes
        page.css('.tasty-recipes-notes ul li').map(&:text)
      end
    end
  end
end

