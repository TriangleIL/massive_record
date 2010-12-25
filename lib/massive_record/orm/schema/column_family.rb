module MassiveRecord
  module ORM
    module Schema
      class ColumnFamily
        include ActiveModel::Validations

        attr_accessor :column_families
        attr_reader :name, :fields


        validates_presence_of :name
        validate { errors.add(:column_families, :blank) if column_families.nil? }


        delegate :add, :add?, :<<, :to_hash, :attribute_names, :to => :fields


        def initialize(*args)
          options = args.extract_options!
          options.symbolize_keys!

          @fields = Fields.new

          self.name = options[:name]
          self.column_families = options[:column_families]
        end

        def ==(other)
          other.instance_of?(self.class) && other.hash == hash
        end
        alias_method :eql?, :==

        def hash
          name.hash
        end

        private
        
        def name=(name)
          @name = name.to_s
        end
      end
    end
  end
end
