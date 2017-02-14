module MultiIdentifiers

  def self.included(base)
    base.one_to_many :multi_identifier

    base.def_nested_record(:the_property => :multi_identifiers,
                           :contains_records_of_type => :multi_identifier,
                           :corresponding_to_association  => :multi_identifier)
  end

end