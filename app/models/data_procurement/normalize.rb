# Usage:
# segment: <Hash>
# DataProcurement::Sanitize.normalize(segment: <segment>)
module DataProcurement
  class Normalize
    RULES = YAML.load_file(Rails.root.join('config/procurement_rules/hotel_attribute_rules.yml'))

    class << self
      def normalize(segment:)
        return segment unless segment.is_a? Hash
        normalized_segment = {}
        RULES.each do |attr, rule|
          value = get_value(rule.dig('attributes'), segment)
          value = value.first unless rule.dig('is_array')
          next unless value.present?
          normalized_segment[attr] = if value.is_a? Array
                                      value.map { |seg| normalize(segment: seg) }.compact.flatten
                                     elsif value.is_a? Hash
                                      normalize(segment: value)
                                     else
                                      value
                                     end
        end
        normalized_segment.keys.any? ? normalized_segment : nil
      end

      def get_value(rules, segment)
        rules.map do |rule|
          begin
            segment.dig(*rule)
          rescue
            nil
          end
        end.compact.flatten.uniq
      end
    end
  end
end
