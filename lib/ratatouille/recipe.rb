# frozen_string_literal: true

require "base64"
require "open-uri"
require "sanitize"
require "uri"
require "yaml"

module Ratatouille
  class Recipe
    attr_reader :importer

    def initialize(importer)
      @importer = importer
    end

    def valid?
      [
        :name,
        :ingredients,
        :directions
      ].all? do |attribute|
        send(attribute).to_s != ""
      end
    end

    def to_yaml
      unless valid?
        puts "Incomplete recipe, can't save."
        return
      end

      content = {
        "name" => name,
        "description" => description,
        "servings" => servings,
        "source_url" => source_url,
        "source" => source,
        "prep_time" => prep_time,
        "cook_time" => cook_time,
        "total_time" => total_time,
        "on_favorites" => "no",
        "categories" => ["Imported"],
        "nutritional_info" => nutrition,
        "notes" => notes,
        "photo" => images.first,
        "ingredients" => ingredients,
        "directions" => directions
      }.to_yaml

      path = "recipes/#{name.downcase.gsub(' ', '-')}.yml"

      File.open(path, "w") do |file|
        file.write(content)
      end

      puts "Recipe saved to #{path}"
      true
    end

    def name
      importer.name.strip.gsub(/[^\-\wÀ-ÖØ-öø-ÿ]/, ' ').gsub('  ', ' ')
    end

    def description
      join(importer.description)
    end

    def ingredients
      join(importer.ingredients, "\n")
    end

    def directions
      join(importer.directions)
    end

    def images
      importer.images.map do |url|
        next if url.start_with?('data:image')
        url = url.split("?").first

        image = open(url).read
        Base64.encode64(image)
      rescue OpenURI::HTTPError, URI::InvalidURIError
        nil
      end.compact
    end

    def servings
      return "" unless importer.respond_to?(:servings)

      importer.servings
    end

    def prep_time
      return "" unless importer.respond_to?(:prep_time)

      importer.prep_time
    end

    def cook_time
      return "" unless importer.respond_to?(:cook_time)

      importer.cook_time
    end

    def total_time
      return "" unless importer.respond_to?(:total_time)

      importer.total_time
    end

    def source_url
      importer.url
    end

    def source
      URI.parse(source_url).hostname rescue nil
    end

    def notes
      return "" unless importer.respond_to?(:notes)

      join(importer.notes)
    end

    def nutrition
      return "" unless importer.respond_to?(:nutrition)

      join(importer.nutrition)
    end

    private

    def join(text, spacing = "\n\n")
      Array(text).reject do |element|
        element.to_s == "" || element.to_s == "\n"
      end.map do |element|
        Sanitize.clean(element).strip
      end.join(spacing).gsub("&#039;", "'").gsub("&nbsp;", " ")
    end
  end
end
