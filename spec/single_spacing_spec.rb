require 'spec_helper'

describe "Single spacing" do
  let(:filename) { 'test.txt' }
  let(:vim) { @vim }

  it "compresses multiple blank lines before the pasted text into a single one" do
    set_file_contents <<-EOF
      one


      two
    EOF

    vim.normal 'jy3y'
    vim.whitespaste
    vim.write

    assert_file_contents <<-EOF
      one

      two

      two
    EOF
  end

  it "compresses multiple blank lines after the pasted text into a single one" do
    set_file_contents <<-EOF
      one


      two
    EOF

    vim.normal 'yy'
    vim.whitespaste
    vim.write

    assert_file_contents <<-EOF
      one
      one

      two
    EOF
  end

  it "works when pasted on a blank line" do
    set_file_contents <<-EOF
      one


      two
    EOF

    vim.normal 'y2yj'
    vim.whitespaste
    vim.write

    assert_file_contents <<-EOF
      one

      one

      two
    EOF
  end
end
