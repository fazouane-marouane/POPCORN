dnl include all the dishonest actors
dnl N.b. The dispute resolver and the payment handler are unique and cannot be dishonest, by definition
include(`DishonestActors/EnergyProvider.m4')dnl
include(`DishonestActors/ChargingStation.m4')dnl
include(`DishonestActors/MobilityOperator.m4')dnl
include(`DishonestActors/ElectricVehicle.m4')dnl
