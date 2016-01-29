require 'update_lock'

class PadsController < InheritedResources::Base
  load_and_authorize_resource
  include UpdateLock
  before_filter :add_base_breadcrumbs

  private

  def pad_params
    params.require(:pad).permit(:name,
                                :description,
                                :content,
                                :lock_version)
  end

  def add_base_breadcrumbs
    add_breadcrumb Pad.model_name.human(count: :other), pads_path unless action_name == 'index'

    if ['edit', 'update'].include? action_name
      add_breadcrumb @pad.name, pad_path(@pad)
      @last_breadcrumb = t 'actions.edit'
    end
  end
end
