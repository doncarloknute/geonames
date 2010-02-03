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

Dir.foreach(feature_path) do |filename|
  if filename =~ /US.+\.tsv/
    yaml_file = File.open(feature_path + filename[0..-5] + ".yaml", "w")
    yaml_file << "dataset:\n"
    yaml_file << "  title: United States GeoNames by Feature Type\n"
    yaml_file << "  tags: [ maps,geonames,locations ]\n"
    yaml_file << "  categories: [ \"Geography::Geographical Names\" ]\n"
    yaml_file << "  description: >-\n    This dataset separates the GeoNames listed in the United States by feature type. Original data downloaded from GeoNames (http://www.geonames.org).\n"
    yaml_file << "  sources:\n"
    yaml_file << "    - title: GeoNames\n"
    yaml_file << "      url: \"http://www.geonames.org\"\n"
    yaml_file << "    - title: Carl Knutson\n"
    yaml_file << "      url: \"http://infochimps.org\"\n"
    yaml_file << "  tables:\n"
    yaml_file << "    title: \"#{filename[0..-5]}\"\n"
    record_count = 0
    File.open(feature_path + filename).each do |line|
      record_count += 1
    end
    yaml_file << "    records_count: #{record_count}\n"
    yaml_file << "    description: >-\n      #{features[filename[3..-5]][3]}\n"
    yaml_file << "    fields:\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: geo_name_id\n"
    yaml_file << "        title: \"GeoName ID\"\n"
    yaml_file << "        description: \"integer id of record in geonames database\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: name\n"
    yaml_file << "        title: \"Name\"\n"
    yaml_file << "        description: \"name of geographical point (utf8)\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: ascii_name\n"
    yaml_file << "        title: \"Ascii Name\"\n"
    yaml_file << "        description: \"name of geographical point in plain ascii characters\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: alternate_names\n"
    yaml_file << "        title: \"Alternate Names\"\n"
    yaml_file << "        description: \"alternate names, comma separated\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: latitude\n"
    yaml_file << "        title: \"Latitude\"\n"
    yaml_file << "        description: \"latitude in decimal degrees\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: longitude\n"
    yaml_file << "        title: \"Longitude\"\n"
    yaml_file << "        description: \"longitude in decimal degrees\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: feature_class\n"
    yaml_file << "        title: \"Feature Class\"\n"
    yaml_file << "        description: \"see http://www.geonames.org/export/codes.html\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: feature_code\n"
    yaml_file << "        title: \"Feature Code\"\n"
    yaml_file << "        description: \"see http://www.geonames.org/export/codes.html\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: country_code\n"
    yaml_file << "        title: \"Country Code\"\n"
    yaml_file << "        description: \"ISO-3166 2-letter country code, 2 characters\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: alt_country_code\n"
    yaml_file << "        title: \"Alternate Country Code\"\n"
    yaml_file << "        description: \"alternate country codes, comma separated, ISO-3166 2-letter country code\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: admin_1\n"
    yaml_file << "        title: \"Administrative Code 1\"\n"
    yaml_file << "        description: \"ISO codes\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: admin_2\n"
    yaml_file << "        title: \"Administrative Code 2\"\n"
    yaml_file << "        description: \"code for the second administrative division, a county in the US\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: admin_3\n"
    yaml_file << "        title: \"Administrative Code 3\"\n"
    yaml_file << "        description: \"code for third level administrative division\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: admin_4\n"
    yaml_file << "        title: \"Administrative Code 4\"\n"
    yaml_file << "        description: \"code for fourth level administrative division\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: population\n"
    yaml_file << "        title: \"Population\"\n"
    yaml_file << "        description: \"population\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: elevation\n"
    yaml_file << "        title: \"Elevation\"\n"
    yaml_file << "        description: \"elevation in meters, integer\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: gtopo30\n"
    yaml_file << "        title: \"Gtopo30\"\n"
    yaml_file << "        description: \"average elevation of 30'x30' (ca 900mx900m) area in meters, integer\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: timezone\n"
    yaml_file << "        title: \"Timezone\"\n"
    yaml_file << "        description: \"the timezone id (see file timeZone.txt)\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: modification_date\n"
    yaml_file << "        title: \"Modification Date\"\n"
    yaml_file << "        description: \"date of last modification in yyyy-MM-dd format\"\n"
    yaml_file << "license:\n"
    yaml_file << "  title: Open Database License (ODbL)\n"
    yaml_file << "  url: \"http://www.opendatacommons.org/licenses/odbl/\"\n"
  end
end

features.clear
