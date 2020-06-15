# frozen_string_literal: true

require 'byebug'

module Ratatouille
  module Importers
    class SpanishGuess
      attr_reader :article, :open_graph

      def initialize(page)
        @article = Article.new(page, 'article', 'h1')
        @article = Article.new(page, '.entry-content', '.entry-title') unless @article.article
        @open_graph = OpenGraph.new(page)
      end

      def valid?
        ingredients.to_s != "" && directions.to_s != ""
      end

      def url
        open_graph.get("url")
      end

      def name
        open_graph.get("title")
      end

      def images
        return Array(open_graph.get("image")) unless article.images.any?

        article.images
      end

      def description
        open_graph.get("description")
      end

      def ingredients
        article.text_between("ingredientes", "preparación") ||
          article.text_between("ingredientes", "instrucciones") ||
          article.text_between("ingredientes", "elaboración") ||
          article.text_between("ingredientes", "receta")
      end

      def directions
        article.text_between("preparación", "") ||
          article.text_between("instrucciones", "") ||
          article.text_between("elaboración", "") ||
          article.text_between("receta", "")
      end
    end
  end
end
