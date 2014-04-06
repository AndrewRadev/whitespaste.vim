require 'spec_helper'

describe "python support" do
  let(:filename) { 'test.py' }

  specify "two blank lines in the global scope" do
    set_file_contents <<-EOF
      def one():
          pass

      def two():
          pass
    EOF

    vim.search 'def one'
    vim.normal 'Vjjd'
    vim.search 'pass'
    vim.whitespaste_after

    assert_file_contents <<-EOF
      def two():
          pass


      def one():
          pass
    EOF
  end
end
