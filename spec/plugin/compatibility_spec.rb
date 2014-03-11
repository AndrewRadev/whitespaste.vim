require 'spec_helper'

describe "compatibility with normal pasting" do
  let(:filename) { 'test.txt' }

  it "respects pasting after with a count" do
    set_file_contents <<-EOF
      one
      two
    EOF

    vim.command("call feedkeys('yj2p')")
    vim.write

    assert_file_contents <<-EOF
      one
      one
      two
      one
      two
      two
    EOF
  end

  it "respects pasting before with a count" do
    set_file_contents <<-EOF
      one
      two
    EOF

    vim.command("call feedkeys('yj2P')")
    vim.write

    assert_file_contents <<-EOF
      one
      two
      one
      two
      one
      two
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
