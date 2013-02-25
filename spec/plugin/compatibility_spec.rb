require 'spec_helper'

describe "compatibility with normal pasting" do
  let(:filename) { 'test.txt' }
  let(:vim) { @vim }

  it "respects pasting with a count" do
    set_file_contents <<-EOF
      one
    EOF

    vim.command("call feedkeys('yy2p')")
    vim.write

    assert_file_contents <<-EOF
      one
      one
      one
    EOF
  end

  it "can use a register other than the default one" do
    set_file_contents <<-EOF
      one
      two
    EOF

    vim.search('one').normal('V"ay')
    vim.search('two').normal('V"by')

    vim.command("call feedkeys('\"ap')")
    vim.write
    assert_file_contents <<-EOF
      one
      two
      one
    EOF

    vim.command("call feedkeys('\"bp')")
    vim.write
    assert_file_contents <<-EOF
      one
      two
      one
      two
    EOF
  end
end
