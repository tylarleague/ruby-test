require 'pdf-reader'

pdf_paths = [
  "./pdfs/17423_2019-07-08_N11.pdf",
  "./pdfs/S17003_2020-11-04_N11.pdf",
  "./pdfs/S17004_2020-11-04_N1.pdf",
  "./pdfs/S17525_2020-03-05_N1.pdf",
  "./pdfs/S18007_2021-11-04_N1.pdf",
  "./pdfs/S18008_2022-02-18_N1.pdf",
  "./pdfs/S18009_2021-05-03_N1.pdf",
  "./pdfs/S18019_2021-09-13_N11.pdf",
  "./pdfs/S18027_2021-08-05_N1.pdf",
  "./pdfs/S18030_2021-04-28_O1.pdf",
  "./pdfs/S18032_2021-03-31_N11.pdf",
  "./pdfs/S18033_2021-11-10_N1.pdf",
  "./pdfs/S18040_2022-01-05_O1.pdf",
  "./pdfs/S18041_2021-11-29_N1.pdf",
  "./pdfs/S18042_2021-12-08_O11.pdf",
  "./pdfs/S18043_2021-04-09_O1.pdf",
  "./pdfs/S18052_2022-03-30_N1.pdf",
  "./pdfs/S18053_2021-06-29_O1.pdf",
  "./pdfs/S18173_2021-12-08_N1.pdf"
]

for index in 0 ... pdf_paths.size
  reader  = PDF::Reader.new(pdf_paths[index])
  reader.pages.each do |page|
    #find pdf file contains "Judgment for Costs of Appointed Attorney"
    if page.text.gsub(/\s+/, " ").strip.include? "Judgment for Costs of Appointed Attorney"
      # puts page.text
      lines = page.text.split("\n")
      is_set = false
      for i in 0...lines.size
        #find "Petitioner" and set
        if (lines[i].gsub(/\s+/, " ").strip.include? "Petitioner,") && is_set == false
          petitioner = lines[i-1].split(",")[0].strip
          is_set = true
        end
        #find "State of" and set
        if lines[i].gsub(/\s+/, " ").strip.include? "In the Supreme Court of the "
          str_pattern = "In the Supreme Court of the "
          start_idx = lines[i].index(str_pattern) + str_pattern.size
          state = lines[i][start_idx..lines[i].size]
        end
        #find "amount" and set
        if lines[i].gsub(/\s+/, " ").strip.include? "$"
          start_idx = lines[i].index("$")
          end_idx = lines[i].index("the amount")
          
          if (start_idx != nil) && (end_idx != nil) && (start_idx < end_idx) 
            amount = lines[i][start_idx..end_idx-5]
          else 
            amount = 0
          end
        end
        #find "date" and set
        if lines[i].gsub(/\s+/, " ").strip.include? "Date of Notice:"
          start_idx = lines[i].index("Date of Notice:")
          date = lines[i][start_idx+16..lines[i].size]
        end
    end
    puts result = {
      ":petitioner" => petitioner,
      ":state" => state,
      ":amount" => amount,
      ":date" => date
    }
    end
  end
end

