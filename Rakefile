#https://github.com/avillafiorita/jekyll-rakefile
# coding: utf-8
task :default => :preview

#
# Tasks start here
#

desc 'Clean up generated site'
task :clean do
  cleanup
end


desc 'Preview on local machine (server with --auto)'
task :preview => :clean do
  generate_mapping_json_files
  generate_service_md_files
  compass('compile') # so that we are sure sass has been compiled before we run the server
  compass('watch &')
  jekyll('serve --watch')
end
task :serve => :preview

desc 'Build for deployment (execute by build engine)'
task :build do
  cleanup
  run_tests
  generate_data
  compass('compile')
  jekyll("build")
end


desc 'Check links for site already running on localhost:4000'
task :check_links do
  begin
    require 'anemone'

    root = 'http://localhost:4000/'
    puts "Checking links with anemone ... "
    # check-links --no-warnings http://localhost:4000
    Anemone.crawl(root, :discard_page_bodies => true) do |anemone|
      anemone.after_crawl do |pagestore|
        broken_links = Hash.new { |h, k| h[k] = [] }
        pagestore.each_value do |page|
          if page.code != 200
            referrers = pagestore.pages_linking_to(page.url)
            referrers.each do |referrer|
              broken_links[referrer] << page
            end
          else
            puts "OK #{page.url}"
          end
        end
        puts "\n\nLinks with issues: "
        broken_links.each do |referrer, pages|
          puts "#{referrer.url} contains the following broken links:"
          pages.each do |page|
            puts "  HTTP #{page.code} #{page.url}"
          end
        end
      end
    end
    puts "... done!"

  rescue LoadError
    abort 'Install anemone gem: gem install anemone'
  end
end

desc 'Check links for site already running on localhost:4000'
task :rebuild_sources do
  begin
    generate_data

  end
end
#
# General support functions
#

# remove generated site
def cleanup
  sh 'rm -rf _site'
  sh 'rm -rf _data/services'
  sh 'rm -rf _services'
  compass('clean')
end

# launch jekyll
def jekyll(directives = '')
  sh 'jekyll ' + directives
end

# launch compass
def compass(command = 'compile')
  (sh 'compass ' + command) if $compass
end


# Transforming data json files

def run_tests
  validate_db_json_files
end

def validate_db_json_files
  puts "Validating db json files"
end

def generate_data
  generate_mapping_json_files
  generate_service_md_files
end

def generate_mapping_json_files
  #https://stackoverflow.com/questions/18103113/merge-two-json-with-a-matching-id-in-rails
  #jbuilder
  sh 'rm -rf _data/services'
  sh 'mkdir _data/services'

  require 'json'
  services_json_file = File.read('db/services.json')
  services_json_parsed = JSON.parse(services_json_file)
  mappings_json_file = File.read('db/mappings.json')
  mappings_json_parsed = JSON.parse(mappings_json_file)

  services_json_parsed.each do |service|
    new_content = {
      "service_id" => service["id"],
      "description" => service["description"],
      "name" => service["name"],
      "urls" => service["urls"],
      "last_updated" => service["last_updated"],
      "mappings" => [
      ]    
    }

    mappings_json_parsed.each do |mapping|
      if mapping["parent_service_id"] == service["id"] 
        new_content["mappings"].push({
            "child_service_id" => mapping["child_service_id"],
            "details" => mapping["details"], 
            "status" => mapping["status"],
            "mapping_ulrs" => mapping["urls"],
            "last_updated" => mapping["last_updated"]
          })
      elsif mapping["child_service_id"] == service["id"]
        new_content["mappings"].push({
            "child_service_id" => mapping["parent_service_id"],
            "details" => mapping["details"], 
            "status" => mapping["status"],
            "mapping_ulrs" => mapping["urls"],
            "last_updated" => mapping["last_updated"]
          })
      end
      
    end 
    array_holder = []
    array_holder.push(new_content);
    File.open("_data/services/" + service['id']+".json", "w") {|file| file.write(array_holder.to_json) }
  end
end

def generate_service_md_files
  sh 'rm -rf _services'
  sh 'mkdir _services'
  require 'json'
  service_template_file = File.read('_layouts/service_template.md')
  services_json_file = File.read('db/services.json')
  services_json_parsed = JSON.parse(services_json_file)
  services_json_parsed.each do |service|
     new_content = service_template_file.dup
     new_content["service_id"] = service['id'] 
     new_content["service_category"] = service['category']
     new_content["service_name"] = service['name']
     File.open("_services/" + service['id']+".md", "w") {|file| file.puts new_content }
  end

end




