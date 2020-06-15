# frozen_string_literal: true

require 'json/ld'
require "byebug"

module Ratatouille
  module Importers
    class EmbedJsonSchema
      attr_reader :page

      def initialize(page)
        @page = page
      end

      def valid?
        page.xpath("//* [@itemtype='http://schema.org/Recipe']").any?
      end

      def name
        find_element_by_itemprop("name").first.text
      end

      def description
        ""
      end

      def ingredients
        find_element_by_itemprop("ingredients").map(&:text)
      end

      def directions
        find_element_by_itemprop("recipeInstructions").map(&:text)
      end

      def servings
        find_element_by_itemprop("recipeYield").first.text rescue nil
      end

      def prep_time
        time = find_element_by_itemprop("prepTime").first
        return unless time

        convert_duration(time["datetime"])
      end

      def cook_time
        time = find_element_by_itemprop("cookTime").first
        return unless time

        convert_duration(time["datetime"])
      end

      def total_time
        time = find_element_by_itemprop("totalTime").first
        return unless time

        convert_duration(time["datetime"])
      end

      def nutrition
        []
      end

      def url
        page.url
      end

      def images
        []
      end

      private

      def find_element_by_itemprop(itemprop)
        Array(page.xpath("//* [@itemprop='#{itemprop}']")).compact
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

