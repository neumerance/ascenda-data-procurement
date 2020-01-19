# DataProcurement::Search.search(resource: <Array>, filter: <Hash>)
# Merges resource based on attributes rules
# @param {Array} of {Hash} resource
# @param {Hash} filter
# filter { hotel_id: <String||Number>, destination_id: <String||Number> }
module DataProcurement
  class Search
    class << self
      def search(resource:, filter:)
        return resource unless filter[:hotel_id].present? ||
                               filter[:destination_id].present?
        filter[:hotel_id] ||= ''
        filter[:destination_id] ||= ''
        resource.select do |x|
          x['id'].to_s == filter[:hotel_id] ||
          x['destination_id'].to_s == filter[:destination_id]
        end
      end
    end
  end
end
