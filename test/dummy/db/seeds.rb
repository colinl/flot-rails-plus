# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

PlotValue.delete_all
PlotValue.create(timestamp: "2015-09-15 09:27:53", x: 0, v1: 0, v2: -0.5)
PlotValue.create(timestamp: "2015-09-16 09:27:53", x: 1, v1: 0.4, v2: -0.4)
PlotValue.create(timestamp: "2015-09-17 09:27:53", x: 2, v1: -0.5, v2: -0.3)
PlotValue.create(timestamp: "2015-09-18 09:27:53", x: 3, v1: 1.0, v2: -0.2)

Plot2Value.delete_all
Plot2Value.create( x2: 7,v1_2: 735, v2_2: 27)
Plot2Value.create( x2: 25,v1_2: 800, v2_2: 30)
Plot2Value.create( x2: 50,v1_2: 900, v2_2: 35)

