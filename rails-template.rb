# by Ben Aldred


# blanc.rb
# -----------------------
# Extra features
# - adds a custom css framework cloned from github

# testing gems
gem "rspec", :lib => false, :env => :test 
gem "rspec-rails", :lib => false, :env => :test
gem 'thoughtbot-shoulda', :lib => 'shoulda', :source => 'http://gems.github.com', :env => :test
gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com', :env => :test
gem 'cucumber', :env => :test 
rake("gems:install", :env => "test")

# useful gems
gem 'rubyist-aasm', :lib => 'aasm', :source => 'http://gems.github.com' 

# Authentication?
@auth = false
if yes?("Do you want user authentication?")
  @auth = true
  gem "authlogic"
  gem 'ruby-openid', :lib => 'openid'
end

#install all the gems
rake("gems:install")


# File manipulation

# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"
run "rm -f public/images/*"

#no test we use rspec
run "rm -rf test"

# clone custom css framework
inside('public/stylesheets') do
  run 'git clone git://github.com/benaldred/blui.git'
  #clean up blui clone 
  run "cp -R blui/stylesheets/* ."
  run "rm -rf blui"
  run "rm -rf .git"
end

# Download JQuery
if yes?("Do you want to use JQuery?")
  run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery-1.3.2.min.js"
end
  
# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"
  
# Set up .gitignore files
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}

# checkout the templates we want to use
run 'git clone git://github.com/benaldred/blanc-rails.git'

# copy template files
run "cp -f blanc-rails/templates/gitignore .gitignore"
run "cp -f blanc-rails/templates/app/helpers/application_helper.rb app/helpers/application_helper.rb"   

#delete the templates
run "rm -rf blanc-rails"
  
# Capify
capify!


# generate and migrate
generate("rspec")
generate("cucumber")
generate("authlogic", "user session") if @auth
rake "db:migrate" 

# Set up git repository
git :init
git :add => '.'
  
# Commit all work so far to the repository
git :add => '.'
git :commit => "-a -m 'Initial commit'"   

# Success!
puts "Done!"