data_path = "../ripd/dump-20100201/"
feature_path = "../ripd/work/us_by_feature/"

features = Hash.new

File.open(data_path + "featureCodes_en.txt").each do |line|
  line.chomp!
  row = line.dup.split("\t")
  row[2] = "" if row[2] == nil
  code = row[0].dup.split(".")
  p code
end