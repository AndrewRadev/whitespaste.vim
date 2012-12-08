require 'spec_helper'

describe "Different registers" do
  let(:filename) { 'test.txt' }
  let(:vim) { @vim }

  it "can use a register other than the default one" do
    set_file_contents <<-EOF
      one
      two
    EOF

    vim.search('one').normal('V"ay')
    vim.search('two').normal('V"by')

    vim.normal('"ap').write
    assert_file_contents <<-EOF
      one
      two
      one
    EOF

    vim.normal('"bp').write
    assert_file_contents <<-EOF
      one
      two
      one
      two
    EOF
  end
end
