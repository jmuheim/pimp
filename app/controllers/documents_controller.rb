require 'update_lock'

class DocumentsController < InheritedResources::Base
  load_and_authorize_resource
  include UpdateLock
  before_filter :add_base_breadcrumbs
  before_filter :prepare_empty_image, only: [:new, :edit]

  private

  def prepare_empty_image
    resource.images.new unless resource.images.any?
  end

  def document_params
    params.require(:document).permit( :name,
                                      :description,
                                      :content,
                                      :lock_version,
                                      images_attributes: [ :id,
                                                           :file,
                                                           :_destroy
                                                         ]
                                    )
  end

  def add_base_breadcrumbs
    add_breadcrumb Document.model_name.human(count: :other), documents_path unless action_name == 'index'

    if ['edit', 'update'].include? action_name
      add_breadcrumb @document.name, document_path(@document)
      @last_breadcrumb = t 'actions.edit'
    end
  end
end
