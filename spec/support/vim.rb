module Support
  module Vim
    def self.define_vim_methods(vim)
      def vim.whitespaste_before
        command 'WhitespastePasteBefore'
        write
        self
      end

      def vim.whitespaste_after
        command 'WhitespastePasteAfter'
        write
        self
      end
    end
  end
end
