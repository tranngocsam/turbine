require 'turbine'

module Turbine

  # This is a small Graph example, similar to the structure that is used
  # in ETEngine in households.
  #
  # Overview:
  # +------------------------------------------------------------------+
  # | ud_heat <- sh_coal <- fd_coal                                    |
  # |     \\\--- sh_oil  <- fd_oil                                     |
  # |      \\--- sh_gas  <- fd_gas                                     |
  # |       \--- sh_chp  <--/                                          |
  # | ud_elec <--/                                                     |
  # |       \--- sh_elec <- fd_elec <- lv <- mv <- hv <- coal plant    |
  # |                                               \--- elec_import   |
  # +------------------------------------------------------------------+
  #
  # Abbreviations used:
  #   ud   = useful_demand
  #   sh   = space_heater
  #   fd   = final_demand
  #   hv   = high voltage
  #   mv   = medium voltage
  #   lv   = low voltage
  #   elec = electricity
  #
  def self.energy_stub
    graph = Turbine::Graph.new

    # Nodes ------------------------------------------------------------------

    useful_demand_heat = graph.add(Turbine::Node.new(:useful_demand_heat))
    useful_demand_elec = graph.add(Turbine::Node.new(:useful_demand_elec))

    space_heater_coal  = graph.add(Turbine::Node.new(:space_heater_coal))
    space_heater_gas   = graph.add(Turbine::Node.new(:space_heater_gas))
    space_heater_oil   = graph.add(Turbine::Node.new(:space_heater_oil))
    space_heater_chp   = graph.add(Turbine::Node.new(:space_heater_chp))
    space_heater_elec  = graph.add(Turbine::Node.new(:space_heater_elec))

    final_demand_coal  = graph.add(Turbine::Node.new(:final_demand_coal))
    final_demand_gas   = graph.add(Turbine::Node.new(:final_demand_gas))
    final_demand_oil   = graph.add(Turbine::Node.new(:final_demand_oil))
    final_demand_elec  = graph.add(Turbine::Node.new(:final_demand_elec))

    lv_network         = graph.add(Turbine::Node.new(:lv_network))
    mv_network         = graph.add(Turbine::Node.new(:mv_network))
    hv_network         = graph.add(Turbine::Node.new(:hv_network))

    coal_plant         = graph.add(Turbine::Node.new(:coal_plant))
    elec_import        = graph.add(Turbine::Node.new(:elec_import))

    # Edges ------------------------------------------------------------------

    elec_import.connect_to(hv_network,               :electricity)
    coal_plant.connect_to(hv_network,                :electricity)

    hv_network.connect_to(mv_network,                :electricity)
    mv_network.connect_to(lv_network,                :electricity)
    lv_network.connect_to(final_demand_elec,         :electricity)

    final_demand_elec.connect_to(space_heater_elec,  :electricity)
    final_demand_coal.connect_to(space_heater_coal,  :coal)
    final_demand_gas.connect_to(space_heater_gas,    :gas)
    final_demand_gas.connect_to(space_heater_chp,    :gas)
    final_demand_oil.connect_to(space_heater_oil,    :oil)

    space_heater_coal.connect_to(useful_demand_heat, :heat)
    space_heater_gas.connect_to(useful_demand_heat,  :heat)
    space_heater_oil.connect_to(useful_demand_heat,  :heat)

    space_heater_chp.connect_to(useful_demand_heat,  :heat)
    space_heater_chp.connect_to(useful_demand_elec,  :electricity)

    space_heater_elec.connect_to(useful_demand_elec, :electricity)

    graph
  end #self.stub
end #Module Turbine
