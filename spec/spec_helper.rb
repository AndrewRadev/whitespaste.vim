require 'vimrunner'
require 'vimrunner/rspec'
require_relative './support/vim'
require_relative './support/files'

RSpec.configure do |config|
  config.include Support::Files
end

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  plugin_path = File.expand_path('.')

  config.start_vim do
    vim = Vimrunner.start

    vim.add_plugin(plugin_path, 'plugin/whitespaste.vim')
    Support::Vim.define_vim_methods(vim)

    vim
  end
end
