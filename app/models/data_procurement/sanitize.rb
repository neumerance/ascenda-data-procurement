# Usage:
# segment: <Hash>
# DataProcurement::Sanitize.sanitize(segment: <segment>)
module DataProcurement
  class Sanitize
    RULES = YAML.load_file(Rails.root.join('config/procurement_rules/hotel_attribute_rules.yml'))

    class << self
      def sanitize(segment:)
      end
    end
  end
end
