class Catalog::Car::Admin < Structure::AdminConcept

  FIELDS = proc do |f|
    f.input :external_key, input_html: { disabled: true }
    f.input :make
    f.input :model
    f.input :year
  end

end
