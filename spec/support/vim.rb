module Support
  module Vim
    def self.define_vim_methods(vim)
      def vim.whitespaste_before
        command 'WhitespasteBefore'
        write
        self
      end

      def vim.whitespaste_after
        command 'WhitespasteAfter'
        write
        self
      end
    end
  end
end
