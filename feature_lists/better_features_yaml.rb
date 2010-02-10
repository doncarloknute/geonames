#!/usr/bin/env ruby
require 'yaml'

data_path = "../ripd/dump-20100201/"
feature_path = "../ripd/work/us_by_feature/"
#feature_path = "../ripd/work/world_by_feature/"

features = Hash.new

File.open(data_path + "featureCodes_en.txt").each do |line|
  line.chomp!
  row = line.dup.split("\t")
  row[2] = "" if row[2] == nil
  code = row[0].dup.split(".")
  code[1] = "" if code[1] == nil
  filename = row[1].dup.rstrip
  filename.gsub!(/\s?\(.+\)/, "")
  filename.gsub!(/\s/, "_")
  #p filename
  p code if features.key?(code[1])
  features[filename] = code + row[1..2] + [filename]
  #p code[1], features[code[1]]
end

features['other'] = []
features['other'][3] = 'all feature types in the United States with a small number of entries (less than 75) combined into one file. see featureCodes_en.txt for individual feature codes.'

sources = [{'source'=>{'title'=>'GeoNames','main_link'=>'http://www.geonames.org','description'=>'The GeoNames geographical database covers all countries and contains over eight million placenames that are available for download free of charge.'}}]

collection = [{'collection'=>{'title'=>'Geolocation','description'=>'A collection of datasets concerning the names, locations, and other information about places in the world.'}}]

base_yaml = [{'dataset'=>{
  'title'=>'',
  'subtitle'=>'United States GeoNames by Feature Type',
  'description'=>'This dataset separates the GeoNames listed in the United States by feature type. Original data downloaded from GeoNames (http://www.geonames.org).',
  'collection'=>'',
  'tags'=>['maps','geonames','locations'],
  'categories'=>['Geography::Geographical Names'],
  'sources'=>['GeoNames','Monkeywrench Consultancy'],
  'payloads'=>[{
    'schema_fields'=>[{'handle'=>'geo_name_id','title'=>'GeoName ID','description'=>'integer id of record in geonames database'},
      {'handle'=>'name','title'=>'Name','description'=>'name of geographical point (utf8)'},
      {'handle'=>'ascii_name','title'=>'Ascii Name','description'=>'name of geographical point in plain ascii characters'},
      {'handle'=>'alternate_names','title'=>'Alternate Names','description'=>'alternate names, comma separated'},
      {'handle'=>'latitude','title'=>'Latitude','description'=>'latitude in decimal degrees'},
      {'handle'=>'longitude','title'=>'Longitude','description'=>'longitude in decimal degrees'},
      {'handle'=>'feature_class','title'=>'Feature Class','description'=>'see http://www.geonames.org/export/codes.html'},
      {'handle'=>'feature_code','title'=>'Feature Code','description'=>'see http://www.geonames.org/export/codes.html'},
      {'handle'=>'country_code','title'=>'Country Code','description'=>'ISO-3166 2-letter country code, 2 characters'},
      {'handle'=>'alt_country_code','title'=>'Alternate Country Code','description'=>'alternate country codes, comma separated, ISO-3166 2-letter country code'},
      {'handle'=>'admin_1','title'=>'Administrative Code 1','description'=>'ISO codes'},
      {'handle'=>'admin_2','title'=>'Administrative Code 2','description'=>'code for the second administrative division, a county in the US'},
      {'handle'=>'admin_3','title'=>'Administrative Code 3','description'=>'code for third level administrative division'},
      {'handle'=>'admin_4','title'=>'Administrative Code 4','description'=>'code for fourth level administrative division'},
      {'handle'=>'population','title'=>'Population','description'=>'population'},
      {'handle'=>'elevation','title'=>'Elevation','description'=>'elevation in meters, integer'},
      {'handle'=>'gtopo30','title'=>'Gtopo30','description'=>'average elevation of 30\'x30\' (ca 900mx900m) area in meters, integer'},
      {'handle'=>'timezone','title'=>'Timezone','description'=>'the timezone id (see file timeZone.txt)'},
      {'handle'=>'modification_date','title'=>'Modification Date','description'=>'date of last modification in yyyy-MM-dd format'},
    ],
    'title'=>'',
    'fmt'=>'tsv',
    'protected'=>'true',
    'records_count'=>'',
    'description'=>'',
    'license'=>'Open Database License (ODbL)',
    'owner'=>'MonkeywrenchConsultancy',
    'files_for_upload'=>[],
  }]
  
}}]

puts sources.to_yaml

puts collection.to_yaml

Dir.foreach(feature_path) do |filename|
  if filename =~ /US.+\.tsv/
    current_yaml = base_yaml.dup
    yaml_file = File.open(feature_path + filename[0..-5] + ".yaml", "w")
    current_yaml[0]['dataset']['title'] = 'United States GeoNames: ' + filename[3..-5].split("_").each{|word| word.capitalize!}.join(" ")
    current_yaml[0]['dataset']['payloads'][0]['title'] = filename[0..-5]
    record_count = 0
    File.open(feature_path + filename).each do |line|
      record_count += 1
    end
    current_yaml[0]['dataset']['payloads'][0]['title'] = filename[0..-5]
    current_yaml[0]['dataset']['payloads'][0]['records_count'] = record_count
    current_yaml[0]['dataset']['payloads'][0]['description'] = features[filename[3..-5]][3] 
    current_yaml[0]['dataset']['payloads'][0]['files_for_upload'] = ['featureCodes_en.txt',filename]
  end
  puts current_yaml.to_yaml
end