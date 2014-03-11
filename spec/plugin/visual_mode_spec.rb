require 'spec_helper'

describe "Visual mode" do
  let(:filename) { 'test.txt' }

  xit "compresses multiple blank lines" do
    set_file_contents <<-EOF
      one


      two
    EOF

    vim.normal 'V2jy'
    vim.search 'two'
    vim.whitespaste_visual

    assert_file_contents <<-EOF
      one

      one
    EOF
  end
end
