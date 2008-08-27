module IronNails::Models

  class BindableCollection 
  
    def initialize(list)
      list.map { |item| self.add item }
    end
    
    def merge!(list)
      parish!
      added = []
      list.reverse.each do |item| 
        unless self.include? item
          item.is_new = true
          item.index = self.count
          self.insert 0, item
          added << item
        end
      end    
      added
    end
    
    def set_indexes!
      self.each_with_index { |item, index| item.index = index }
    end
    
    def parish!
      self.each do |item| 
        item.is_new = false 
      end
    end
    
    def truncate_after(max)
      self.to_a[0...max]
    end
    
  end

end