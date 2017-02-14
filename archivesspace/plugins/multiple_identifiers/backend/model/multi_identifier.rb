class MultiIdentifier < Sequel::Model(:multi_identifier)
  include ASModel
  corresponds_to JSONModel(:multi_identifier)

  set_model_scope :global

end