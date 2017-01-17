{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {

      "identifier_type" => {"type" => "string", "dynamic_enum" => "identifier_type"},
      "identifier_value" => {"type" => "string", "maxLength" => 255}

    },
  },
}