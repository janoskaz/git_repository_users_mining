require_relative 'lib/gexf/gexf'
require_relative 'apriori'

require 'tire'

# code to generate pair of users, who collaborate with each other
# uses program apriori
# http://www.borgelt.net/doc/apriori/apriori.html
colab = collaborators_as_transactions('github', 'repo')

trans = Apriori::Transactions.new(colab)

input_file_path = '/tmp/input'
output_file_path = '/tmp/output'

trans.write_file(input_file_path, limit=2)

opt = Apriori::Options.new({:target_type => 'm', :min_size =>2, :max_size => 2, :min_supp => -15, :min_conf => 80, :add_eval => "l", :output_format => " %a"})
item_set = Apriori::call_apriori(input_file_path, output_file_path, opt, keep_files=false)
puts "DONE" if item_set

# how many times is user in the database
freq_table = item_set.frequency_of_items

# empty graph
g = GEXF::Graph.new()

# add all nodes to graph
counter = 0
freq_table.each do |user|
  node = GEXF::Node.new({:id=>counter, :label=>user[0], :viz_size=>user[1]})
  g.add_node(node)
  counter += 1
end

# add all edges to graph
counter = 0
item_set.each do |itemset|

  size = itemset[:measures][0]
  from = itemset[:itemset][0]
  to = itemset[:itemset][1]
  
  id_from = g.nodes.select {|h| h.label==from}[0].id
  id_to = g.nodes.select {|h| h.label==to}[0].id
  
  edge = GEXF::Edge.new({:id=>counter, :source=>id_from, :target=>id_to, :attributes=>{:size=>size}})
  g.add_edge(edge)
  counter += 1 
end

g.write('examples/sigma_js/collaborators.gexf')
