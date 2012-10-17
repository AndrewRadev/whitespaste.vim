require 'spec_helper'

describe "Linewise: single spacing" do
  let(:filename) { 'test.txt' }
  let(:vim) { @vim }

  context "(pasting before)" do
    it "compresses multiple blank lines before the pasted text into a single one" do
      set_file_contents <<-EOF
        one


        two
      EOF

      vim.normal 'jy3y'
      vim.search 'two'
      vim.whitespaste_before

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

      vim.normal 'y3y'
      vim.search 'two'
      vim.whitespaste_before

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

      vim.normal 'y2yjj'
      vim.whitespaste_after

      assert_file_contents <<-EOF
        one

        one

        two
      EOF
    end
  end

  context "(pasting after)" do
    it "compresses multiple blank lines before the pasted text into a single one" do
      set_file_contents <<-EOF
        one


        two
      EOF

      vim.normal 'jy3y'
      vim.whitespaste_after

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
      vim.whitespaste_after

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
      vim.whitespaste_after

      assert_file_contents <<-EOF
        one

        one

        two
      EOF
    end
  end
end
