class BasicSection::Admin < Structure::AdminConcept

  FIELDS = proc do |f|
    f.input :title
    f.input :description
  end

end
