task :default do
  sh 'rspec spec'
end

desc "Prepare archive for deployment"
task :archive do
  sh 'zip -r ~/whitespaste.zip autoload/ doc/whitespaste.txt plugin/'
end
