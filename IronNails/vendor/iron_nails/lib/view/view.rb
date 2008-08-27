module IronNails

  module View
  
    # encapsulates what IronNails sees as a view.
    # That is the xaml proxy and some meta data for
    # IronNails.
    class View
    
      include IronNails::Logging::ClassLogger      
      include IronNails::Core::Observable   
    
      attr_accessor :name
      
      attr_accessor :element_name
      
      attr_accessor :proxy
      
      attr_accessor :parent
      
      attr_accessor :container
      
      attr_accessor :controller
      
      attr_reader :loaded
      
      attr_reader :children
      
      def initialize(options)
        options.each do |k, v|
          if k == :view_name
            @name = v
          else
            instance_variable_set "@#{k}", v
          end
        end
        @element_name ||= name
        @children = []
      end
      
      def loaded?
        @loaded
      end
      
      def has_container?
        !container.nil?
      end
      
      def sets_datacontext?
        !has_parent? || !!@sets_datacontext
      end
      
      def has_parent?
        !parent.nil?
      end
      
      def add_control(target, proxy)
        proxy.add_control(target, proxy)
        self
      end
      
      def load(mode = :complete)
        unless @loaded || mode == :reload
          self.proxy = XamlProxy.load(name)
          proxy.instance.name = element_name if has_parent?
          parent.add_control(container, proxy) if has_container? && has_parent? && mode == :complete
          children.each { |cv| cv.load } 
          logger.debug("loaded view #{name}", IRONNAILS_FRAMEWORKNAME)        
          @loaded = true
          notify_observers :loaded, self
        end
        self
      end
      
      def data_context=(value)
        self.proxy.data_context = value
      end 
      
      def show
        configure
        self.proxy.show
      end
      
      def instance
        configure
        proxy.instance
      end
      
      def configure
        load
        notify_observers :configuring, self
      end
      
      def add_child(options)
        child = children.find { |vw| vw.name == options[:name] }
        children.delete(child) unless child.nil?
        children << View.new(options.merge(:parent => self, :controller => controller))
        logger.debug("added child view (#{options[:name]} to #{name}", IRONNAILS_FRAMEWORKNAME)
        self
      end
      
      def has_child?(view)
        children.any? { |vw| vw == view }
      end
      
      def add_command(cmd)
        proxy.add_command cmd
      end
      
      def add_timer(cmd)
        proxy.add_timer cmd
      end
      
      def on_proxy(&b)
        proxy.instance_eval(&b)
      end
      
      def has_datacontext?
        !proxy.nil? && !proxy.instance.data_context.nil?
      end
      
      def ==(view)
        view.respond_to?(:name) ? self.name == view.name : self.name = view.to_sym
      end
      alias_method :===, :==
      alias_method :equals, :==
      
      def <=>(view)
        self.name <=> command.view
      end
      alias_method :compare_to, :<=>
     
    end
    
  end
  
end