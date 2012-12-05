module Support
  module Vim
    def self.define_vim_methods(vim)
      def vim.whitespaste_before
        command 'normal P'
        write
        self
      end

      def vim.whitespaste_after
        command 'normal p'
        write
        self
      end

      def vim.whitespaste_visual
        command 'normal Vp'
        write
        self
      end
    end
  end
end
