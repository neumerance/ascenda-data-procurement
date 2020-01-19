module DataProcurement
  class Merge
    def initialize(data:)
      @data = data
      @merged_data = []
      @rules = YAML.load_file(
        Rails.root.join(
          'config/procurement_rules/merge_attributes.yml'
        )
      )
    end

    def merge
      @data.each do |segments|
        segments.each do |segment|
          consolidated_segment = consolidated_segment_by_id(segment)
          @rules.each do |attr, rule|
            consolidated_segment[attr] ||= []
            value = rule.attributes.map { |rule_attr| segment[*rule_attr] }.compact.first
            consolidated_segment[attr] << value
          end
        end
      end
    end

    def consolidated_segment_by_id(segment)
      id = segment.dig(*@attributes.dig('id', 'attributes'))
      cons_seg = @merged_data.detect { |s| s.dig('id') == id }
      return cons_seg if cons_seg.present?
      @merged_data << { 'id' => id }
      consolidated_segment_by_id(segment)
    end
  end
end
