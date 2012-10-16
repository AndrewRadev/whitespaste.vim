module Support
  module Vim
    def set_file_contents(string)
      string = normalize_string(string)
      File.open(filename, 'w') { |f| f.write(string) }
      @vim.edit! filename
    end

    def file_contents
      IO.read(filename).chomp
    end

    def assert_file_contents(string)
      file_contents.should eq normalize_string(string)
    end

    private

    def normalize_string(string)
      lines      = string.split("\n")
      whitespace = lines.grep(/\S/).first.scan(/^\s*/).first

      lines.map do |line|
        line.gsub(/^#{whitespace}/, '') if line =~ /\S/
      end.join("\n")
    end
  end
end
