module StructureHelper

  def reset_structure_menu_state
    if Structure.instance_variable_defined?('@m_configuration')
      Structure.remove_instance_variable('@m_configuration')
    end
  end

end
