# frozen_string_literal: true

module Ratatouille
  class OpenGraph
    attr_reader :page, :article

    def initialize(page)
      @page = page
    end

    def get(property_name)
      page.content.xpath("//meta").find {|e| e["property"] == "og:#{property_name}" }["content"]
    end
  end
end
