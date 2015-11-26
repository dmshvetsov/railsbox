class BasicPage::Admin < Structure::AdminConcept

  FIELDS = proc do |f|
    f.input :title
    f.input :body
  end

end
