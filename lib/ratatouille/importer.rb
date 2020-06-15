# frozen_string_literal: true

require "yaml"

module Ratatouille
  class Importer
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def to_yaml
      return recipe.to_yaml if recipe && recipe.valid?

      puts "No importer found for #{url}"
      nil
    end

    def recipe
      @recipe ||= recipe_from_config || guessed_recipe
    end

    private

    def recipe_from_config
      return unless url_config

      importer_klass = Object.const_get("Ratatouille::Importers::#{url_config["importer"]}")
      importer = importer_klass.new(page, url_config["options"])
      Recipe.new(importer)
    end

    def guessed_recipe
      importers.each do |klass|
        importer = klass.new(page)
        next unless importer.valid?

        recipe = Recipe.new(importer)
        next unless recipe.valid?

        return recipe
      end

      nil
    end

    def importers
      [
        "TastyRecipes",
        "Wprm",
        "EasyRecipe",
        "JsonSchema",
        "EmbedJsonSchema",
        "SpanishGuess"
      ].map do |klass|
        Object.const_get("Ratatouille::Importers::#{klass}")
      end
    end

    def url_config
      @url_config ||= config.find do |config|
        url.match? config["url"]
      end
    end

    def config
      @config ||= YAML.load(File.read("config.yml"))["importers"]
    end

    def page
      @page ||= Page.new(url)
    end
  end
end
