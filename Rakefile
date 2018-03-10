#https://github.com/avillafiorita/jekyll-rakefile
# coding: utf-8
require 'json'
require 'csv'

$db_services_path = 'db/services.json'
$db_integrations_path = 'db/integrations.json'
$service_detailed_template_path = '_data/service_detailed.md'
$generated_service_details_path = '_data/service_details/'
$generated_service_comparison_path = '_data/service_comparison/'
$services_md_path = '_services/'

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
  generate_data
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
  jekyll('build')
end


desc 'Check links for site already running on localhost:4000'
task :check_links do
  begin
    require 'anemone'

    root = "http://localhost:4000/"
    puts 'Checking links with anemone ... '
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
        puts '\n\nLinks with issues: '
        broken_links.each do |referrer, pages|
          puts "#{referrer.url} contains the following broken links:"
          pages.each do |page|
            puts "  HTTP #{page.code} #{page.url}"
          end
        end
      end
    end
    puts '... done!'

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

  #placeholder for service comparing csv table data
  sh 'rm -rf ' + $generated_service_comparison_path
  sh 'mkdir ' + $generated_service_comparison_path

  #placeholder for service specific json data
  sh 'rm -rf ' + $generated_service_details_path
  sh 'mkdir ' + $generated_service_details_path

  #placeholder for generated service pages
  sh 'rm -rf ' + $services_md_path
  sh 'mkdir ' + $services_md_path
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
  puts 'Validating db json files - TO BE IMPLEMENTED'
end

def generate_data
  cleanup
  generate_integrations_json_files
  generate_service_comparison_files
  generate_service_details_md_files
end

def generate_integrations_json_files
  #https://stackoverflow.com/questions/18103113/merge-two-json-with-a-matching-id-in-rails
  #jbuilder
  
  services_json_file = File.read($db_services_path)
  services_json_parsed = JSON.parse(services_json_file)
  integrations_json_file = File.read($db_integrations_path)
  integrations_json_parsed = JSON.parse(integrations_json_file)

  services_json_parsed.each do |service|
    new_content = {
      'service_id' => service['id'],
      'description' => service['description'],
      'name' => service['name'],
      'urls' => service['urls'],
      'status' => service['status'],
      'last_updated' => service['last_updated'],
      'integrations' => [
      ]    
    }

    integrations_json_parsed.each do |integration|
      if integration['parent_service_id'] == service['id'] 
        new_content['integrations'].push({
            'child_service_id' => integration['child_service_id'],
            'details' => integration['details'], 
            'status' => integration['status'],
            'ulrs' => integration['urls'],
            'last_updated' => integration['last_updated']
          })
      elsif integration['child_service_id'] == service['id']
        new_content['integrations'].push({
            'child_service_id' => integration['parent_service_id'],
            'details' => integration['details'], 
            'status' => integration['status'],
            'ulrs' => integration['urls'],
            'last_updated' => integration['last_updated']
          })
      end
      
    end 
    array_holder = []
    array_holder.push(new_content);
    File.open($generated_service_details_path + service['id']+'.json', 'w') {|file| file.write(array_holder.to_json) }
  end
end

def generate_service_comparison_files
  services_json_file = File.read($db_services_path)
  services_json_parsed = JSON.parse(services_json_file)

  categories = services_json_parsed.uniq{ |s| s['category'] }.map{|s| s['category']}
#  categories.push('all')

  categories.each do |category|
    generate_service_csv_file(category, services_json_parsed)
  end
  
end

def generate_service_csv_file(filter, data_json)
  services_comparison = []
  service_spcific = []
  header = Array.new(4, '')
  header[0] = 'Category'
  header[1] = 'Subcategory'
  header[2] = 'Azure'
  header[3] = 'AWS'
  services_comparison.push(header) 
  service_spcific.push(header)


  if filter != 'all'
    data_json = data_json.select{ |s| s['category'] == filter}
  end
  
  cleaned_services = data_json
            .reject{|s| s['provider'] == 'Other'}
            .sort_by {|s| [s['category'], s['subcategory'], s['provider']]}
            .group_by{|g| [g['category'], g['subcategory']] }

  previous_category = ''            
  cleaned_services.each do |service|
    
    line = Array.new(4, '')

    curr_category = service[0][0]
    if previous_category != curr_category
      line[0] = curr_category
      previous_category = curr_category
      services_comparison.push(line);
      line = Array.new(4, '')
    end
    curr_subcategory = service[0][1]
    line[1] = curr_subcategory

    service[1].each do |child|
      record = '<a href="/services/'+ curr_category +'/' + child['id'] +'/' +'">' + child['name'] + '</a><hr>'

      if child['provider'] == 'Azure'
        line[2] += record
      elsif child['provider'] == 'AWS'
        line[3] += record
      end
    end 
    services_comparison.push(line);   
  end
  
  csv_str = services_comparison.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join('')
  File.open($generated_service_comparison_path + filter +'.csv', 'w') {|f| f.puts csv_str}
end

def generate_service_details_md_files
  
  service_template_file = File.read($service_detailed_template_path)
  services_json_file = File.read($db_services_path)
  services_json_parsed = JSON.parse(services_json_file)
  services_json_parsed.each do |service|
     new_content = service_template_file.dup
     new_content['service_id'] = service['id'] 
     new_content['service_category'] = service['category']
     new_content['service_name'] = service['name']
     File.open($services_md_path + service['id']+'.md', 'w') {|file| file.puts new_content }
  end

end




