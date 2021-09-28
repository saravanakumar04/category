class Category < ApplicationRecord
  acts_as_tree order:"name"
  @@the_array = []

  # with n+1 query
  def all_children()
    all_children = []
    all_children+= children
    all_children.collect do |child|
      all_children+=child.all_children
    end
    all_children
  end



  # without n+1 query
  def children_details
    @@the_array = []
    children= Category.where(:id => self.id).includes(children: { children: [:children]}).map(&:all_children_new)
    return children.flatten
  end

  def all_children_new
    if children.empty?
      self
    else
      children.each do |c|
        @@the_array << c
      end
      children.map(&:all_children_new)
    end
    @@the_array
  end
end
