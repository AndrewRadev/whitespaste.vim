require 'spec_helper'

describe "Charwise" do
  let(:filename) { 'test.txt' }
  let(:vim) { @vim }

  context "(pasting before)" do
    it "doesn't interfere with characterwise pasting" do
      set_file_contents 'one two three'
      vim.search('two').normal('yw')

      vim.whitespaste_before

      assert_file_contents 'one two two three'
    end
  end

  context "(pasting after)" do
    it "doesn't interfere with characterwise pasting" do
      set_file_contents 'one two three'
      vim.search('two').normal('ywh')

      vim.whitespaste_after

      assert_file_contents 'one two two three'
    end
  end
end
