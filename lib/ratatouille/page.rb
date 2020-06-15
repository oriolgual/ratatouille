# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module Ratatouille
  class Page
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def content
      @content ||= Nokogiri::HTML(html)
    end

    def html
      @html ||= open(url)
    end

    def text_of(selector, engine = :css)
      return css(selector).first.text if engine == :css && has_css?(selector)
      return xpath(selector).first.text if engine == :xpath && has_xpath?(_selector)
      nil
    end

    def css(selector)
      content.css(selector)
    end

    def has_css?(selector)
      css(selector).any?
    end

    def has_xpath?(selector)
      xpath(selector).any?
    end

    def xpath(selector)
      content.xpath(selector)
    end
  end
end
