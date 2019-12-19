# Consumes messages in Unix timestamp and converts them to current date

import datetime as d
import sys

timeStamp = 1576708981

isoDate = d.datetime.fromtimestamp(timeStamp)
print(isoDate)
