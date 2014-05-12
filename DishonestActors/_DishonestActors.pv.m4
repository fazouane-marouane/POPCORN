dnl include all the dishonest actors
dnl N.b. The dispute resolver and the payment handler are unique and cannot be dishonest, by definition
include(`DishonestActors/EnergyProvider.pv.m4')dnl
include(`DishonestActors/ChargingStation.pv.m4')dnl
include(`DishonestActors/MobilityOperator.pv.m4')dnl
include(`DishonestActors/ElectricVehicle.pv.m4')dnl
