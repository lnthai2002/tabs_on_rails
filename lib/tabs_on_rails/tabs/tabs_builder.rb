#--
# Tabs on Rails
#
# A simple Ruby on Rails plugin for creating and managing Tabs.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


module TabsOnRails
  class Tabs

    #
    # = Tabs Builder
    #
    # The TabsBuilder is and example of custom Builder.
    #
    class TabsBuilder < Builder

      # Returns a link_to +tab+ with +name+ and +options+ if +tab+ is not the current tab,
      # a simple tab name wrapped by a span tag otherwise.
      #
      #   current_tab? :foo   # => true
      #
      #   tab_for :foo, 'Foo', foo_path
      #   # => "<li class="current"><span>Foo</span></li>"
      #
      #   tab_for :bar, 'Bar', bar_path
      #   # => "<li><a href="/link/to/bar">Bar</a></li>"
      #
      # You can pass a hash of <tt>item_options</tt>
      # to customize the behavior and the style of the li element.
      #
      #   # Pass a custom class to the element
      #   tab_for :bar, 'Bar', bar_path, :class => "custom"
      #   # => "<li class="custom"><a href="/link/to/bar">Bar</a></li>"
      #
      # Implements Builder#tab_for.
      #
      def tab_for(tab, name, url_options, item_options = {})
        item_options[:class] = item_options[:class].to_s.split(' ')
        if current_tab?(tab)
          item_options[:class] = item_options[:class].push(@options[:active_class] || 'current')
          @tabs[:active] = @tabs[:list].size + 1 #mark location of the active tab
        end
        item_options[:class] = item_options[:class].join(' ')
        content = @context.link_to_unless(current_tab?(tab), name, url_options) do
          @context.content_tag(:span, name)
        end
        @tabs[:list] << @context.content_tag(:li, content, item_options)
     end

      def build_tabs(options)
        return @context.content_tag("ul", options[:open_tabs]) do
          @tabs[:list].join
        end
      end
    end
  end
end
