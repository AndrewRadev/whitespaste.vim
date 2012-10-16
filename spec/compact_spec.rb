require 'spec_helper'

describe "whitespaste#Compact" do
  let(:filename) { 'test.txt' }
  let(:vim) { @vim }

  context "(in the beginning of the file)" do
    before :each do
      set_file_contents <<-EOF


        one
        two
      EOF
    end

    it "can reduce the whitespace to 0" do
      vim.command 'call whitespaste#Compact(0, 3, 0)'
      vim.write
      assert_file_contents <<-EOF
        one
        two
      EOF
    end

    it "can reduce the whitespace to 1" do
      vim.command 'call whitespaste#Compact(0, 3, 1)'
      vim.write
      assert_file_contents <<-EOF

        one
        two
      EOF
    end

    it "does nothing if the given number is >= the amount of whitespace" do
      vim.command 'call whitespaste#Compact(0, 3, 2)'
      vim.write
      assert_file_contents <<-EOF


        one
        two
      EOF

      vim.command 'call whitespaste#Compact(0, 3, 3)'
      vim.write
      assert_file_contents <<-EOF


        one
        two
      EOF
    end
  end

  context "(at the end of the file)" do
    before :each do
      set_file_contents <<-EOF
        one
        two


      EOF
    end

    it "can reduce the whitespace to 0" do
      vim.command 'call whitespaste#Compact(2, 4, 0)'
      vim.write
      assert_file_contents <<-EOF
        one
        two
      EOF

      vim.command 'call whitespaste#Compact(2, 5, 0)'
      vim.write
      assert_file_contents <<-EOF
        one
        two
      EOF
    end

    it "can reduce the whitespace to 1" do
      vim.command 'call whitespaste#Compact(2, 4, 1)'
      vim.write
      assert_file_contents <<-EOF
        one
        two

      EOF
    end

    it "does nothing if the given number is >= the amount of whitespace" do
      vim.command 'call whitespaste#Compact(2, 4, 2)'
      vim.write
      assert_file_contents <<-EOF
        one
        two


      EOF

      vim.command 'call whitespaste#Compact(2, 4, 3)'
      vim.write
      assert_file_contents <<-EOF
        one
        two


      EOF
    end
  end

  context "(in the middle of the file)" do
    before :each do
      set_file_contents <<-EOF
        one


        two
      EOF
    end

    it "can reduce the whitespace to 0" do
      vim.command 'call whitespaste#Compact(1, 4, 0)'
      vim.write
      assert_file_contents <<-EOF
        one
        two
      EOF
    end

    it "can reduce the whitespace to 1" do
      vim.command 'call whitespaste#Compact(1, 4, 1)'
      vim.write
      assert_file_contents <<-EOF
        one

        two
      EOF
    end

    it "does nothing if the given number is >= the amount of whitespace" do
      vim.command 'call whitespaste#Compact(1, 4, 2)'
      vim.write
      assert_file_contents <<-EOF
        one


        two
      EOF

      vim.command 'call whitespaste#Compact(1, 4, 3)'
      vim.write
      assert_file_contents <<-EOF
        one


        two
      EOF
    end
  end
end
