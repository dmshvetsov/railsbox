class Catalog::Car < ActiveRecord::Base

  def title
    "#{make} #{model} #{year}"
  end

end
