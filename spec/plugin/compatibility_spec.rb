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
end
