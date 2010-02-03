data_path = "../ripd/dump-20100201/"
feature_path = "../ripd/work/world_by_feature/"

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

#all_codes = features.keys.sort

File.open(data_path + "allCountries.txt").each do |line|
  row = line.dup.chomp.split("\t")
  feature_file = File.open(feature_path + "world_" + features[row[7]][-1] + ".tsv", "a")
  feature_file << line
  #puts row[7] + "\t" + features[row[7]][-1] if all_codes[50..150].include?(row[7])
end