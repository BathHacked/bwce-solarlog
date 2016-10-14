require 'csv'

#SCHOOLS = ["271096109","1344890667","1076738551","539780016","1882044826","2997345","1345174470","1345186820","1613593593","808303126"]

ARGV.each do |id|
  CSV.open("data/#{id}.csv", "w") do |archive|
    archive << ["ID", "Location ID", "Timestamp", "Inverter", "Power output", "Cumulative daily yield", "Status", "Error", "Pdc1", "Udc", "Uac"]

    Dir.glob( File.join( "data", id, "min*.csv") ).sort.each do |file|

      index = 0
      CSV.read( file, { :col_sep=>";", :return_headers=>false } ).each do |line|
        index += 1
        if index != 1
          date, time = line.shift(2)     
          timestamp = DateTime.strptime("#{date} #{time}", "%d/%m/%y %H:%M:%S").iso8601 
          inverters = line.length / 8
          inverters.times do |count|
            archive << ["#{id}-#{count+1}-#{DateTime.strptime("#{date} #{time}", "%d/%m/%y %H:%M:%S").strftime("%s")}", id, timestamp] + line.shift(8)
          end
        end

      end   
    end
  end
end

