module IronNails
  
  module Core
    
    module FeedParser
      
      module ClassMethods
        
        def build_from(element, include_children = true)
          return nil if element.nil?
          
          item = self.new      
          item.populate_properties_from element
          item.populate_children_from element if include_children
          item
        end
        
        def timestamps
          %w(created_at updated_at)
        end
        
        def properties
          raise "You need to override properties in child classes: #{self}"
        end
        
        def children
          raise "You need to override children in child classes: #{self}"
        end
        
        
        def collection
          BindableCollection
        end
        
        
        def internal_request(options, &callback)
          wc = WebClient.new options[:url], options[:credentials]
          options[:root_path] ||= self.demodulize.downcase 
          if options[:entity]
            wc.get_and_return lambda { |reader| parse_element(reader, options[:root_path])}, &callback   
          else
            wc.get_and_return lambda { |reader| parse_elements(reader, options[:root_path])}, &callback 
          end                    
        end
        
        def parse_element(reader, root_path)
          item = nil
          IronXml.parse(reader, :stream) do |doc|
            item = self.build_from(doc.element(root_path)) 
          end
          item
        end
        
        def parse_elements(reader, root_path)
          elements = []
          IronXml.parse(reader, :stream) do |doc|
            doc.elements(root_path) do |item|
              elements << self.build_from(item)
            end
          end
          collection.new elements.compact
        end  
        
      end # end of class methods
      
      def populate_properties_from(element)
        self.class.properties.each do |p|
          if element.has_element?(p)
            val = element.element(p).value
            unless val.nil?                
              val = val.to_s.to_created_time if self.class.timestamps.include? p
              val = val.to_s.strip_html if p.to_s == 'source' && !val.to_s.empty?
              unless block_given? && p.to_s == 'text'
                val = HttpUtility.html_decode val if p.to_s == 'text'
                self.send("#{p}=".to_sym, val) 
              else
                yield val
              end
            end
          end
        end
      end
      
      def populate_children_from(element)
        self.class.children.each do |c|
          element.element(c) do |cn|
            kn = (c == 'sender' || c == 'recipient') ? 'user' : c
            self.send("#{c}=".to_sym, kn.classify.build_from(cn, false)) 
          end          
        end 
      end
      
    end
    
  end
  
end