data_path = "../ripd/dump-20100201/"
feature_path = "../ripd/work/us_by_feature/"

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
  features[code[1]] = code + row[1..2] + [filename]
  #p code[1], features[code[1]]
end

Dir.foreach(feature_path) do |filename|
  if filename =~ /US.+\.tsv/
    yaml_file = File.open(data_path + filename[0..-4] + ".yaml", "w")
    yaml_file << "dataset:\n"
    yaml_file << "  title: \n"
    yaml_file << "  description: >-\n    \n"
    yaml_file << "  sources:\n"
    yaml_file << "    - title: GeoNames\n"
    yaml_file << "      url: \"http://download.geonames.org/export/dump/\"\n"
    yaml_file << "    - title: Carl Knutson\n"
    yaml_file << "      url: \"http://infochimps.org\"\n"
    yaml_file << "  tables:\n"
    yaml_file << "    title: \"#{filename[0..-4]}\"\n"
    yaml_file << "    records_count: 19\n"
    yaml_file << "    description: >-\n      #{features[][3]}"
    yaml_file << "    fields:\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: GeoNameId\n"
    yaml_file << "        title: \"integer id of record in geonames database\"\n"
    yaml_file << "      - id:\n"
    yaml_file << "        handle: Name\n"
    yaml_file << "        title: \"name of geographical point (utf8), varchar(200)\"\n"
    yaml_file << "license:\n"
    yaml_file << "  title: Open Database License (ODbL)\n"
    yaml_file << "  url: \"http://www.opendatacommons.org/licenses/odbl/\"\n"
  end
end

title_hash.clear
