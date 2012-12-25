module Support
  # Note the juggling of the final newline. Writing a string to a file through
  # ruby needs to be the same as writing it through Vim.
  #
  module Files
    def set_file_contents(string)
      write_file(filename, string)
      @vim.edit!(filename)
    end

    def file_contents
      IO.read(filename).chop # remove trailing newline
    end

    def assert_file_contents(string)
      file_contents.should eq normalize_string_indent(string)
    end
  end
end
