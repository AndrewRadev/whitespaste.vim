require 'spec_helper'

describe "vimscript support" do
  let(:filename) { 'test.vim' }
  let(:vim) { @vim }

  specify "functions" do
    set_file_contents <<-EOF
      function! One()
      endfunction

      function! Two()
      endfunction
    EOF

    vim.search 'One'
    vim.normal 'Vjjd'
    vim.search 'Two'
    vim.normal 'j'
    vim.whitespaste_after

    assert_file_contents <<-EOF
      function! Two()
      endfunction

      function! One()
      endfunction
    EOF
  end

  specify "if-clauses" do
    set_file_contents <<-EOF
      if foo
        echo 'bar'
      endif

      if bar
        echo 'baz'
      endif
    EOF

    vim.search 'if foo'
    vim.normal 'Vjjjd'
    vim.search 'if bar'
    vim.normal 'jj'
    vim.whitespaste_after

    assert_file_contents <<-EOF
      if bar
        echo 'baz'
      endif

      if foo
        echo 'bar'
      endif
    EOF
  end
end
