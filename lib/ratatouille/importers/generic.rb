# frozen_string_literal: true

require 'byebug'

module Ratatouille
  module Importers
    class Generic
      attr_reader :article, :open_graph, :config

      def initialize(page, config)
        @article = Article.new(page, config['recipe_container'], config["title_container"])
        @open_graph = OpenGraph.new(page)
        @config = config
      end

      def url
        open_graph.get("url")
      end

      def name
        return open_graph.get("title") unless config["title_container"]

        article.title
      end

      def images
        return Array(open_graph.get("image")) unless article.images.any?

        article.images
      end

      def description
        return open_graph.get("description") unless config["description_from_text"] && config["description_until_text"]

        article.text_between(
          option_value("description_from_text"),
          option_value("description_until_text")
        )
      end

      def ingredients
        article.text_between(
          option_value("ingredients_from_text"),
          option_value("ingredients_until_text")
        )
      end

      def directions
        article.text_between(
          option_value("directions_from_text"),
          option_value("directions_until_text")
        )
      end

      private

      def option_value(option)
        value = config.fetch(option)

        if value.start_with?("###")
          value = value.split("###").last
          return send(value) if respond_to?(value)
        end

        value
      end
    end
  end
end
