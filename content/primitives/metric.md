+++
title = "Metric"

[menu.main]
identifier = "metric"
parent = "primitives"
+++

A metric is a data point sampled from the application or infrastructure. A default set of metrics for the infrastructure are provided by default. The application can be instrumented with additional custom metrics.

## Actions

### Write

Record a datapoint for a specific metric.

### Min

Fetch the minimum value of a specific metric over a given range.

### Max

Fetch the maximum value of a specific metric over a given range.

### Average

Fetch the average (mean) value of a specific metric over a given range.

### Median

Fetch the median (middle of distribution) value of a specific metric over a given range.

### Perc95

Fetch the 95th percentile value of a specific metric over a given range.

### Perc99

Fetch the 99th percentile value of a specific metric over a given range.

### Sum

Fetch the sum of values of a specific metric over a given range.

### Count

Fetch the count of values of a specific metric over a given range.
