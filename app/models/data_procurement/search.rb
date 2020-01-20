# DataProcurement::Search.search(resource: <Array>, filter: <Hash>)
# Merges resource based on attributes rules
# @param {Array} of {Hash} resource
# @param {Hash} filter
# filter { id: <String||Number>, destination_id: <String||Number> }
module DataProcurement
  class Search
    class << self
      def search(resource:, filter:)
        filter[:hotel_id] ||= ''
        filter[:destination_id] ||= ''
        return resource unless filter[:id].present? ||
                               filter[:destination_id].present?
        resource = search_by(filter, :id, resource)
        search_by(filter, :destination_id, resource)
      end

      def search_by(filter, attr, resource)
        return resource unless filter[attr].present?
        resource.select { |x| x[attr.to_s].to_s == filter[attr].to_s }
      end
    end
  end
end
