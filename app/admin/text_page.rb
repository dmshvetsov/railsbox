ActiveAdmin.register TextPage do

  permit_params :title,
    :body,
    page_attributes: [:id, :title, :slug, :parent_id, :visible, :published_at, :language]

  form do |f|
    f.semantic_errors

    f.inputs f.object.model_name.human do
      f.input :title
      f.input :body
    end

    # TODO: get rid of this
    f.object.build_page unless f.object.page
    f.inputs Structure::Page.model_name.human do
      f.semantic_fields_for :page do |page|
        page.input :title
        page.input :slug
        page.input :visible
        page.input :published_at
      end
    end

    f.actions
  end

end
