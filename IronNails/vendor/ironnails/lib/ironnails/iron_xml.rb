module IronNails

  module Core

    class IronXml

      attr_reader :xml_node, :parent

      def initialize(xml_doc, parent=nil)
        @xml_node = xml_doc
        @parent = parent
      end

      # selects multiple child nodes from the tree
      def elements(name, &b)
        if has_element? name
          ele = @xml_node.select_nodes xp_pref(name)
          ele.each do |el|
            raise "Expected a block for multiple elements" unless block_given?
            b.call IronXml.new(el, self) unless el.nil?
          end
        else
          []
        end
      end

      # selects a single child node from the tree
      def element(name)
        if has_element? name
          ele = @xml_node.select_single_node xp_pref(name)
          xml = IronXml.new(ele, self)
          yield xml if block_given?
          xml
        end
      end

      # indicates whether the element is present in the selected nodes.
      def has_element?(name)
        !@xml_node.nil? && @xml_node.select_nodes("#{name}").count > 0
      end

      # the XPath prefix (rooted or not?)
      def xp_pref(name)
        @parent.nil? ? "//#{name}" : name
      end

      # the value of the selected node
      def value
        @xml_node.inner_text
      end

      # parses an xml document. +content+ can be either 
      # a string containing xml, a path to an xml document
      # or a System::IO::Reader. You tell IronXml which type of 
      # content you have by passing in a +content_type+. 
      # +content_type+ is a symbol that defaults to :string
      # it expects a block to traverse the xml provided. 
      def self.parse(content, content_type = :string, &b)
        xdoc = XmlDocument.new

        if content_type == :string
          xdoc.load_xml(content)
        else
          xdoc.load(content)
        end
        b.call(IronXml.new(xdoc))
      end

      def method_missing(sym, *args, &b)
        # this is what gives us the syntactic sugar over the 
        # Xlinq like syntax
        if block_given?
          self.elements(sym.to_s, &b)
        else
          self.element(sym.to_s).value
        end

      end
    end

  end

end