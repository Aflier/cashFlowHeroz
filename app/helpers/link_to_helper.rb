module LinkToHelper
  def link_back_to(thing, options = {})
    if options[:path].present?
      link_to thing.name, options[:path], class: 'link-back'
    else
      link_to thing.name, thing, class: 'link-back'
    end
  end

  def btn_to_edit(thing, path)
    return unless can? :edit, thing

    link_to icons__edit, path, class: 'btn-edit float-right ml-1', data: { turbo_frame: :remote_modal }
  end
end
