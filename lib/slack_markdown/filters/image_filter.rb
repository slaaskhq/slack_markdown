# encoding: utf-8

require 'html/pipeline'
require 'slack_markdown/filters/ignorable_ancestor_tags'

module SlackMarkdown
  module Filters
    class ImageFilter < ::HTML::Pipeline::Filter
      include IgnorableAncestorTags

      def call
        doc.search('.//text()').each do |node|
          content = node.to_html
          next if has_ancestor?(node, ignored_ancestor_tags)
          html = image_filter(content)
          next if html == content
          node.replace(html)
        end
        doc
      end

      def image_filter(text)
        text.gsub(IMAGE_PATTERN) do
          "<a href=\"#{$4}\" title=\"#{$2}\">#{$2}</a>"
        end
      end

      IMAGE_PATTERN = /(!\[)(.*?)(\]\()(https?:\/\/(.*?)+)(\))/
    end
  end
end
