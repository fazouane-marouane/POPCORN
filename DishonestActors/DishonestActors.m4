# include all the dishonest actors
# N.b. The dispute resolver and the payment handler are unique and cannot be dishonest, by definition
include(`EnergyProvider.m4')dnl
include(`ChargingStation.m4')dnl
include(`MobilityOperator.m4')dnl
include(`ElectricVehicle.m4')dnl
