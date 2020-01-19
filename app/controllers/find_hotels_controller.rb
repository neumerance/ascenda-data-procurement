class FindHotelsController < ApplicationController
  rescue_from Exceptions::ApiServiceError, with: :service_error
  before_action :resources
  before_action :resource

  def index
    render json: DataProcurement::Search.search(
      resource: @resource,
      filter: params
    )
  end

  private

  def resource
    @resource = DataProcurement::Merge.new.merge(segment_groups: @resources)
  end

  def resources
    service = HotelServiceApis.new
    @resources = [
      service.hotel_a,
      service.hotel_b,
      service.hotel_c
    ]
  end

  def service_error
    render json: { error: ['API service failure'], status: 503 }
  end
end
