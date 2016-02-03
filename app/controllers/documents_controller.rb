require 'update_lock'

class DocumentsController < InheritedResources::Base
  load_and_authorize_resource
  include UpdateLock
  before_filter :add_base_breadcrumbs

  def show
    respond_to do |format|
      format.html do
        if params[:standalone]
          export
        else
          super
        end
      end

      format.all do
        export
      end
    end
  end

  private

  def export
    now = Time.now
    string_to_export = "% #{@document.name}\n% #{logged_in? ? current_user.name : 'Unknown'}\n% #{l now}\n\n"

    respond_to do |format|
      format.html do
        string_to_export += @document.content_with_referenced_images
        render text: PandocRuby.convert(string_to_export, :s, to: :html, c: '/assets/application.css')
      end

      [:docx, :odt, :epub].each do |format_name|
        format.send format_name do
          string_to_export += @document.content_with_embedded_images
          send_data PandocRuby.convert(string_to_export, to: format_name),
                                                         filename:    "#{@document.name} (#{l now, format: '%Y-%m-%d %H-%M'}).#{format_name}",
                                                         type:        "Mime::#{format_name.upcase}".constantize,
                                                         disposition: 'attachment'
        end
      end
    end
  end

  def document_params
    params.require(:document).permit( :name,
                                      :description,
                                      :content,
                                      :lock_version,
                                      images_attributes: [ :id,
                                                           :file,
                                                           :file_cache,
                                                           :identifier,
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
