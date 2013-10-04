puts "\#\#\# this module uses program apriori by Christian Borgelt\#\#\#"
puts "More info on http://www.borgelt.net/doc/apriori/apriori.html"

def collaborators_as_transactions(db, mapping)
  
  s = Tire.search db do
    query { term :_type, mapping}
  end
  nr = s.results.total
  
  s = Tire.search db do
    query { term :_type, mapping}
    fields [:collaborators]
    size nr    
  end
  
  collaborators = s.results.results.map { |item| item.collaborators }
  
end

module Apriori
  extend Apriori
  
  # Transactions are just array of arrays
  # inner arrays are groups of collaborants
  class Transactions < Array
    
    def write_file(filename, minsize=1)
      
      f = File.open(filename, 'w')
      
      self.each { |arr| f << (arr.uniq.join(' ')+"\n") if arr.size >= minsize }
      
    ensure
      f.close
      
    end
    
  end
  
  # options passed to apriori program
  class Options
    
    attr_accessor :target_type, :min_size, :max_size, :min_supp, :min_conf, :add_eval,
                  :min_add_eval, :output_format
                  
    # accepts hash of values
    def initialize(params={})
      
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params
      
    end
    
    # makes string with parameters
    def to_s
      
      options = ""
      options << " -t" << self.target_type                   unless self.target_type.nil?
      options << " -m" << self.min_size.to_s                 unless self.min_size.nil?
      options << " -n" << self.max_size.to_s                 unless self.max_size.nil?
      options << " -s" << self.min_supp.to_s                 unless self.min_supp.nil?
      options << " -c" << self.min_conf.to_s                 unless self.min_conf.nil?
      options << " -e" << self.add_eval.to_s                 unless self.add_eval.nil?
      options << " -d" << self.min_add_eval.to_s             unless self.min_add_eval.nil?
      options << " -v" << "\";" << self.output_format << "\"" unless self.output_format.nil?
      
      options
      
    end
    
  end
  
  # class to store itemset with its measures
  class ItemSet < Hash
    
    attr_accessor :itemset, :measures
    
    def initialize(itemset, measures)
      self[:itemset] = itemset
      self[:measures] = measures
    end
    
  end
  
  # array of objects of class ItemSet
  class Itemsets < Array
    
    # get all items (possibility to get only unique items)
    def all_items(uniq=false)
      
      arr = []
      self.each do |h|
        arr << h[:itemset]
      end
      
      arr.flatten!
      
      uniq ? arr.uniq : arr 
    end
    
    # get frequency table of items in itemsets
    def frequency_of_items(sorted=true)
      
      items = self.all_items(uniq=false)
      table = {}
      
      items.each do |item|
        table.has_key?(item) ? table[item] += 1 : table[item] = 1
      end
      
      # sort descending : minus sign of value
      sorted ? table.sort_by{ |key, value| -value} : table
    end
    
  end
  
  def call_apriori(input_file, output_file, options)
    
    request = "apriori " << input_file << ' ' << output_file << options.to_s
    system(request)
    
    item_sets = Apriori::Itemsets.new()
    begin
      File.open(output_file).each do |line|
        parts = line.split(';')
        items = parts[0].split(' ')
        measures = parts[1].split(' ')
        item_sets << Apriori::ItemSet.new(itemset = items, measures = measures)
      end
    rescue
      puts "Computation failed"
    end
    
    item_sets
  end
  
end