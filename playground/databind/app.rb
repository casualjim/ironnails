require 'System'
require 'WindowsBase'
require 'PresentationCore'
require 'PresentationFramework'
require 'System.Windows.Forms'

include System
include System::Windows
include System::Collections::ObjectModel

class System::Windows::Markup::XamlReader

  def self.load_from_path(path)
	f = System::IO::FileStream.new(path, System::IO::FileMode.Open, System::IO::FileAccess.Read)
	begin
	  element = Markup::XamlReader::Load(f)
	ensure
	  f.close
	end
	element
  end 
end

module WpfBehavior

  module Databinding

	module ClassMethods
				
	  # defines a write-only attribute on an object
	  # this would map to a property setter in different languages
	  def attr_writer(*names)
		names.each do |nm|
		  mn = nm
		  self.send :define_method, "#{nm}=".to_sym do |arg| 
			__vr__ =  instance_variable_get :"@#{mn}"
			return __vr__ if __vr__ == arg
			instance_variable_set :"@#{mn}", arg
			raise_property_changed mn
		  end
		end
	  end

	  # defines a read/write attribute on an object.
	  # this would map to a property with a getter and a setter in different langauages
	  def attr_accessor(*names)
		attr_reader *names
		attr_writer *names
	  end
	
	
	end
	
	# extend the class with the class methods defined in this module
	def self.included(base)
	  base.send :include, System::ComponentModel::INotifyPropertyChanged unless base.ancestors.include? System::ComponentModel::INotifyPropertyChanged
	  base.extend ClassMethods
	end
	
	def add_PropertyChanged(handler=nil)
	  @__handlers__ ||= []
	  @__handlers__ << handler
	end

	def remove_PropertyChanged(handler=nil)
	  @__handlers__ ||= []
	  @__handlers__.delete handler
	end

	private 
	  def raise_property_changed(name)
	    return unless @__handlers__
	    @__handlers__.each do |ev| 
		  ev.invoke self, System::ComponentModel::PropertyChangedEventArgs.new(name) if ev.respond_to? :invoke
		  ev.call self, System::ComponentModel::PropertyChangedEventArgs.new(name) if ev.respond_to? :call
	    end
	  end
	
end

end

class Person

  include WpfBehavior::Databinding

  attr_accessor :name, :age
	
	
  def	to_s
	"<Person name=#{self.name}, age=#{age} />"
  end

  def	initialize(attrs={})
	attrs.each do |k, v|
	  self.send :"#{k}=", v
	end
  end
	
end

if $0 == __FILE__
	view_path = File.expand_path(File.join(File.dirname(__FILE__), 'main.xaml'))
	window = Markup::XamlReader.load_from_path view_path if File.exists? view_path

	people_list = window.find_name("people_list")
	lst =  ObservableCollection.of(Person).new
	[Person.new( :name => "Ivan", :age => 32), Person.new(:name => "Adam", :age => 27), Person.new(:name => "Maurits", :age => 31)].each { |p| lst.add p }
	people_list.items_source = lst
	
	btn = window.find_name("change_name")
	btn.click do |s, a|
	lst.first.name = "New name"
	end
	

	Application.new.run window
end