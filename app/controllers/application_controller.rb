class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, except: Proc.new { |c| c.request.format.json? }
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }

  private

  def paginate(query, defaults = {})
    load_pagination(defaults)
    query = query.order("#{@sort_column} #{@sort_direction}")
                 .offset((@page - 1) * @limit)
    if @limit > 0
        query = query.limit(@limit)
    end
    query
  end

  def load_pagination(defaults = {})
    @page = params.fetch(:page, defaults.fetch(:page, 1)).to_i
    @limit = params.fetch(:limit, defaults.fetch(:limit, 10)).to_i
    @sort_column = params.fetch(:sort_column, defaults.fetch(:sort_column, :created_at))
    @sort_direction = params.fetch(:sort_direction, defaults.fetch(:sort_direction, :ASC))
  end
end
