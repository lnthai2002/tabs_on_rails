#--
# Tabs on Rails
#
# A simple Ruby on Rails plugin for creating and managing Tabs.
#
# Copyright (c) 2009-2013 Simone Carletti <weppos@weppos.net>
#++


require 'tabs_on_rails/tabs/builder'
require 'tabs_on_rails/tabs/tabs_builder'


module TabsOnRails

  class Tabs

    mattr_accessor :default_builder
    @@default_builder = TabsBuilder

    def initialize(context, options = {})
      @context = context
      @builder = (options.delete(:builder) || self.class.default_builder).new(@context, options)
      @options = options
    end

    %w(open_tabs close_tabs).each do |name|
      define_method(name) do |*args|                      # def open_tabs(*args)
        method = @builder.method(name)                    #   method = @builder.method(:open_tabs)
        if method.arity.zero?                             #   if method.arity.zero?
          method.call                                     #     method.call
        else                                              #   else
          method.call(*args)                              #     method.call(*args)
        end                                               #   end
      end                                                 # end
    end

    def method_missing(*args, &block)
      @builder.tab_for(*args, &block)
    end

    def raw(string)
      @builder.add_raw(string)
    end

    # Renders the tab stack using the current builder.
    #
    # Returns the String HTML content.
    def render(&block)
      raise LocalJumpError, "no block given" unless block_given?
      @builder.parse(self, &block)#execute the tab declaration blocks to records links
      @builder.build_tabs(@options).html_safe
    end
  end

end
