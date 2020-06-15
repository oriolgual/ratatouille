# frozen_string_literal: true
require 'byebug'

require 'json/ld'

module Ratatouille
  module Importers
    class Wprm
      attr_reader :page, :json_schema

      def initialize(page)
        @page = page
        @json_schema = JsonSchema.new(page)
      end

      def valid?
        page.has_css?(".wprm-recipe-container")
      end

      def name
        page.text_of('.wprm-recipe-name') || json_schema.name
      end

      def ingredients
        if page.has_css?('.wprm-recipe-ingredient-group')
          page.css('.wprm-recipe-ingredient-group').flat_map do |group|
            header = group.css('.wprm-recipe-group-name').first
            header_text = (header ? "**#{header.text}**" : nil)
            instructions = group.css('.wprm-recipe-ingredient').map(&:text)
            [header_text] + instructions
          end
        elsif page.has_css?('.wprm-recipe-ingredient')
          page.css('.wprm-recipe-ingredient').map(&:text)
        else
          json_schema.ingredients
        end.compact
      end

      def directions
        if page.has_css?('.wprm-recipe-instruction-group')
          page.css('.wprm-recipe-instruction-group').flat_map do |group|
            header = group.css('.wprm-recipe-group-name').first
            header_text = (header ? "**#{header.text}**" : nil)
            instructions = group.css('.wprm-recipe-instruction').map(&:text)
            [header_text] + instructions
          end
        elsif page.has_css?('.wprm-recipe-instruction')
          page.css('.wprm-recipe-instruction').map(&:text)
        else
          json_schema.directions
        end.compact
      end

      def servings
        page.text_of('.wprm-recipe-servings') || json_schema.servings
      end

      def prep_time
        page.text_of('.wprm-recipe-prep-time-container .wprm-recipe-time') || json_schema.prep_time
      end

      def cook_time
        page.text_of('.wprm-recipe-cook-time-container .wprm-recipe-time') || json_schema.prep_time
      end

      def total_time
        page.text_of('.wprm-recipe-total-time-container .wprm-recipe-time') || json_schema.prep_time
      end

      def url
        json_schema.url
      end

      def nutrition
        json_schema.nutrition
      end

      def description
        page.text_of('.wprm-recipe-summary') || json_schema.description
      end

      def images
        json_schema.images
      end

      def notes
        page.css('.wprm-recipe-notes').flat_map do |element|
          if element.children.any?
            element.children.map(&:text)
          else
            element.text
          end
        end.reject do |text|
          text == "" || text == "\n"
        end
      end
    end
  end
end

