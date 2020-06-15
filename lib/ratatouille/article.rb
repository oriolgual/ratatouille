# frozen_string_literal: true

require 'byebug'

module Ratatouille
  class Article
    attr_reader :page, :recipe_container, :title_container

    def initialize(page, recipe_container, title_container)
      @page = page
      @recipe_container = recipe_container
      @title_container = title_container
    end

    def title
      page.text_of(title_container)
    end

    def images
      article.css('img').map{|i| i['src'] }.reject{|url| url.match?('gravatar') }
    end

    def text_between(this, that, allowed_tags = ["ul", "ol", "li", "p", "h1", "h2", "h3", "h4", "h5"])
      this_start = -1 if this.to_s == ""
      this_start ||= article_text_elements.index do |element|
        element.text.downcase.strip.start_with? this.downcase
      end

      return unless this_start

      that_start = article_text_elements.length if that.to_s == ""
      that_start ||= article_text_elements.index do |element|
        element.text.downcase.strip.start_with? that.downcase
      end

      return unless that_start

      article_text_elements[this_start + 1, that_start - 1 - this_start].select do |element|
        allowed_tags.include?(element.name)
      end.flat_map do |element|
        if element.children.any?
          element.children.map(&:text)
        else
          element.text
        end
      end.reject do |text|
        text == "" || text.include?("adsbygoogle")
      end
    end

    def article
      @article ||= page.css(recipe_container).first
    end

    def article_text_elements
      return [] unless article

      @children ||= article.children.reject do |element|
        ["img", "script", "style"].include?(element.name)
      end.flat_map do |element|
        flatten(element)
      end.reject do |element|
        element.text.strip == ""
      end
    end

    def flatten(element)
      return element unless element.children.any? do |element|
        ["div", "ul", "li", "p", "ol"].include?(element.name)
      end

      element.children.flat_map do |element|
        flatten(element)
      end
    end
  end
end
