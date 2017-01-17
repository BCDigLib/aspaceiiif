require_relative 'utils'
Sequel.migration do
	up do
		create_table(:multi_identifier) do
			primary_key :id

			Integer :lock_version, :default => 0, :null => false
			Integer :json_schema_version, :null => false

			Integer :resource_id
			Integer :archival_object_id

			DynamicEnum :identifier_type_id
			String :identifier_value

			apply_mtime_columns
		end

		alter_table(:multi_identifier) do
			add_foreign_key([:resource_id], :resource, :key => :id)
			add_foreign_key([:archival_object_id], :archival_object, :key => :id)
		end

	    create_editable_enum('identifier_type', ['local_call', 'local_mss_av', 'local_mss_er', 'local_b'])
	end

	down do
		drop_table(:multi_identifier)
	end
end
