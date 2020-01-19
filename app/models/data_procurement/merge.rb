# DataProcurement::Merge.new.merge(segment_group: <Array>)
# Merges segment_groups based on attributes rules
# @param {Array} of {Hash} segment_groups
module DataProcurement
  class Merge
    RULES = YAML.load_file(Rails.root.join('config/procurement_rules/hotel_attribute_rules.yml'))

    def initialize
      @merged_segments = []
    end

    def merge(segment_groups:)
      normalized_segment_groups(segment_groups).each do |segment_group|
        segment_group.each do |segment|
          existing_segment = find_existing_segment(segment)
          RULES.each do |attr, rule|
            next if existing_segment[attr] == segment[attr]
            existing_segment[attr] ||= nil
            if rule.dig('mergeable')
              merge_segment_attr(existing_segment, segment, rule, attr)
            else
              assign_segment_attr(existing_segment, segment, rule, attr)
            end
          end
        end
      end
      @merged_segments
    end

    private

    def find_existing_segment(segment)
      existing_segment = @merged_segments.detect { |x| x['id'] == segment['id'] }
      return existing_segment if existing_segment.present?
      @merged_segments << segment
      find_existing_segment(segment)
    end

    def normalized_segment_groups(segment_groups)
      segment_groups.map do |segment_group|
        segment_group.map do |segment|
          DataProcurement::Normalize.normalize(segment: segment)
        end
      end
    end

    def assign_segment_attr(existing_segment, segment, rule, attr)
      return unless rule.dig('type') == 'string' &&
                    segment[attr].present?
      return if seg_string_included(existing_segment, segment, attr)
      return if segment[attr].length < (existing_segment[attr].try(:length) || 0)
      existing_segment[attr] = segment[attr]
    end

    def merge_segment_attr(existing_segment, segment, rule, attr)
      if rule.dig('type') == 'array'
        existing_segment[attr] ||= []
        existing_segment[attr] << segment[attr]
        existing_segment[attr] = existing_segment[attr].flatten.compact.uniq
      elsif rule.dig('type') == 'string'
        return if seg_string_included(existing_segment, segment, attr)
        existing_segment[attr] = "#{existing_segment[attr]}, #{segment[attr]}"
      else
        existing_segment[attr] = segment[attr] if segment[attr].present?
      end
    end

    def seg_string_included(existing_segment, segment, attr)
      return false unless existing_segment[attr].present? &&
                          segment[attr].present?
      existing_segment[attr].include?(segment[attr]) ||
      segment[attr].include?(existing_segment[attr])
    end
  end
end
