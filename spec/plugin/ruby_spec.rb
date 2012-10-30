require 'spec_helper'

describe "ruby support" do
  let(:filename) { 'test.rb' }
  let(:vim) { @vim }

  specify "methods" do
    set_file_contents <<-EOF
      class Test
        def one
        end

        def two
        end
      end
    EOF

    vim.search 'def one'
    vim.normal 'Vjjd'
    vim.search 'def two'
    vim.normal 'j'
    vim.whitespaste_after

    assert_file_contents <<-EOF
      class Test
        def two
        end

        def one
        end
      end
    EOF
  end

  specify "if-clauses" do
    set_file_contents <<-EOF
      if foo?
        'bar'
      end

      if bar?
        'baz'
      end
    EOF

    vim.search 'if foo'
    vim.normal 'Vjjjd'
    vim.search 'if bar'
    vim.normal 'jj'
    vim.whitespaste_after

    assert_file_contents <<-EOF
      if bar?
        'baz'
      end

      if foo?
        'bar'
      end
    EOF
  end
end
