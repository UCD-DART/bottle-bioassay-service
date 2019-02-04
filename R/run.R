

setwd('./R')
args = commandArgs(trailingOnly=TRUE)
data = read.csv(args[1])

alive.1 =data$alive
time.1 = data$time
i = 0
l = 0
for (row in alive.1) {
    if (row > l) {
        alive.1[i] = row
    }
    l = row
    i = i + 1
}
mortality.control = 0 # as a proportion
source('bottle.calc.R')

data = bottle.calc(alive.1,alive.1,time.1)

# which will allow you to call the results of the function, for example:
output = data.frame(
    "kd50" = data$kd.1$kd50.1,
    "kd50cil" = data$kd.1$kd50.ci.1[1],
    "kd50ciu" = data$kd.1$kd50.ci.1[2],
    "kd90" = data$kd.1$kd90.1,
    "kd90cil" = data$kd.1$kd90.ci.1[1],
    "kd90ciu" = data$kd.1$kd90.ci.1[2],
    "kd95" = data$kd.1$kd95.1,
    "kd95cil" = data$kd.1$kd95.ci.1[1],
    "kd95ciu" = data$kd.1$kd95.ci.1[2]
)
write.csv(output, args[2])
