module Sails

  module Wpf
	  module Builders
		  def name_collector
			  @___name_collector_ 
		  end
  		
		  def [](name)
			  name_collector[name]
		  end
  		
		  def inject_names(obj)
			  name_collector.each_pair { |k, v| obj.instance_variable_set("@#{k}".to_sym, v) }
		  end
  		
		  def evaluate_properties(obj, args, &b) 
			  obj.instance_variable_set(:@___name_collector_, name_collector)
  			
			  args.each_pair do |k, v| 
				  if k == :name 
					  name_collector[v] = obj
				  end
				  if k == :binding
				    binding = Binding.new
            binding.path = PropertyPath.new v[:property_name]
            binding.source = v[:target]||self;
            binding.mode = v[:mode]
            obj.set_binding(v[:property], binding);
            obj.owner = v[:target]||self
				  else
				    obj.send :"#{k.to_s}=", v
				  end
			  end
  			
			  if obj.respond_to? :name
				  name_collector[obj.name] = obj unless obj.name.nil?
			  end
  			
			  obj
		  end
  		
		  def add_object_to_name_collector(collection, obj, args = {}, &b)
			  obj = evaluate_properties(obj, args, &b)
			  obj.instance_eval(&b) unless b.nil?
			  collection.add obj
			  obj
		  end
  		
		  def add_class_to_name_collector(collection, klass, args = {}, &b)
			  obj = evaluate_properties(klass.new, args, &b)
			  obj.instance_eval(&b) unless b.nil?
			  collection.add obj
			  obj
		  end
  		
		  def assign_to_name_collector(property, klass, args = {}, &b) 
			  obj = evaluate_properties(klass.new, args, &b)
			  obj.instance_eval(&b) unless b.nil?
			  self.send property, obj
			  obj
		  end
	  end
  	
	  def self.build(klass, args = {}, &b)
		  obj = klass.new
		  obj.instance_variable_set(:@___name_collector_, {})
  		
		  args.each_pair do |k, v| 
			  if k == :name 
				  obj.name_collector[v] = obj 
			  end
			  obj.send :"#{k.to_s}=", v
		  end
  		
		  obj.instance_eval(&b) if b != nil
		  obj
	  end
  end
end

class System::Windows::Data::Binding
  alias_method :old_mode=, :mode=
  def mode=(value)
    self.old_mode = value.to_binding_mode
  end 
end


class Panel
  include Sails::Wpf::Builders
  
  def add(klass, args = {}, &b)
    add_class_to_name_collector(children, klass, args, &b)
  end
  
  def add_name(name, obj)
    name_collector[name] = obj
  end
  
  def add_obj(obj)
    add_object_to_name_collector(children, obj)
  end
  
  alias_method :old_background=, :background=
  def background=(color)
    self.old_background = color.to_brush
  end
end


