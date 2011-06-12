namespace :sass do

  task :sass_environment => :environment do
    Sass::Plugin.on_updating_stylesheet { |template, css| puts "Building #{css} from #{template}" }
    Sass::Plugin.on_not_updating_stylesheet { |template, css| puts "Skipping #{css}" }
  end

  desc "Forcefully updates the stylesheets generated by SASS."
  task :build => :sass_environment do
    Sass::Plugin.force_update_stylesheets
  end

  desc "Updates the out of date stylesheets generated by SASS."
  task :update => :sass_environment do
    Sass::Plugin.update_stylesheets
  end
end
