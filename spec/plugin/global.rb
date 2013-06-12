require 'spec_helper'

describe "global" do
  let(:filename) { 'test.js' }
  let(:vim) { @vim }

  specify "curly brackets" do
    set_file_contents <<-EOF
      if (one) {
        if (two) {
          three();
        }

        if (four) {
          five();
        }
      }
    EOF

    vim.search 'two'
    vim.normal 'Vjjjd'
    vim.search 'four'
    vim.normal '$%'
    vim.whitespaste_after

    assert_file_contents <<-EOF
      if (one) {
        if (four) {
          five();
        }

        if (two) {
          three();
        }
      }
    EOF
  end
end
