module IronNails

  module View
  
    # encapsulates what IronNails sees as a view.
    # That is the xaml proxy and some meta data for
    # IronNails.
    class View
    
      include IronNails::Logging::ClassLogger      
      include IronNails::Core::Observable   
      extend Forwardable
      
      def_delegators :@proxy, :add_control, :add_command, :add_timer, :invoke, :get_property
    
      # gets or sets the name of this view
      attr_accessor :name
      
      # gets or sets the element name on the canvas for this view
      attr_accessor :element_name
      
      # gets or sets the xaml proxy that is associated with this view
      attr_accessor :proxy
      
      # gets or sets the parent of this view
      attr_accessor :parent
      
      # gets or sets the name of the component that will contain this view
      attr_accessor :container
      
      # gets or sets the name of the controller this view is associated with
      attr_accessor :controller
      
      # gets the flag that indicates if this view needs to be initialized or not
      attr_reader :loaded
      
      # gets the collection of children for this view
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
      
      def added?
        @added
      end
      
      # indicates whether we initialized this view already or not
      def loaded?
        @loaded
      end
      
      # indicates whether this view has to be rendered inside a component
      def has_container?
        !container.nil?
      end
      
      # indicates whether this view has to set its datacontext in order to function
      def sets_datacontext?
        !has_parent? || !!@sets_datacontext
      end
      
      # indicates whether this view has a parent
      def has_parent?
        !parent.nil?
      end
      
      # adds this view to a component in an existing view
      def add_control(target, control_proxy)
        puts "Adding control #{proxy.view_name} to: #{name} in #{target} "
        proxy.add_control(target, control_proxy)
        self
      end
      
      # loads this view into memory and adds the children if needed
      def load(mode = :complete)
        unless @loaded || mode == :reload
          self.proxy = XamlProxy.load(name)
          proxy.instance.name = element_name.to_s.to_clr_string if has_parent?
          @loaded = true
          #notify_observers :loaded, self
        end
        if has_container? && has_parent? && mode == :complete && !added?
          parent.add_control(container, proxy) 
          @added = true
        end
        children.each { |cv| cv.load } 
        logger.debug("loaded view #{name}", IRONNAILS_FRAMEWORKNAME)                          
        self
      end
      
      # sets the data context of this view
      def data_context=(value)
        self.proxy.data_context = value
      end 
      
      # configures and then shows the window
      def show
        configure
        self.proxy.show
      end
      
      # configures and then returns an instance of the loaded view
      def instance
        configure
        proxy.instance
      end
      
      # configures the view, it loads it and then triggers the observers for further configuration
      def configure
        load
        notify_observers :configuring, self
      end
      
      # adds a child view definition to this view.
      def add_child(options)
        child = children.find { |vw| vw.name == options[:name] }
        children.delete(child) unless child.nil?
        children << View.new(options.merge(:parent => self, :controller => controller))
        logger.debug("added child view (#{options[:name]} to #{name})", IRONNAILS_FRAMEWORKNAME)
        self
      end
      
      # returns whether this child view is alread contained by this view or not
      def has_child?(view)
        children.any? { |vw| vw == view }
      end
      
#      # adds a command to this view
#      def add_command(cmd)
#        proxy.add_command cmd
#      end
#      
#      # adds a timer to this view
#      def add_timer(cmd)
#        proxy.add_timer cmd
#      end
      
      # executes the code block on the view
      def on_proxy(&b)
        load 
        proxy.instance_eval(&b)
      end
      
#      def invoke(target, method)
#        proxy.invoke target, method
#      end
      
      # indicates whether this view has a data context set already or not
      def has_datacontext?
        !proxy.nil? && !proxy.instance.data_context.nil?
      end
      
      def find(view_name)
        return self if name == view_name || view_name.nil?
        children.find { |cv| cv.name == view_name }
      end
      
      # equality comparer for easier selection
      def ==(view)
        view.respond_to?(:name) ? self.name == view.name : self.name = view.to_sym
      end
      alias_method :===, :==
      alias_method :equals, :==
      
      # sorting comparer for ordering lists
      def <=>(view)
        self.name <=> command.view.name
      end
      alias_method :compare_to, :<=>
     
    end
    
  end
  
end