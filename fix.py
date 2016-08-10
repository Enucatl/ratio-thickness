#!/usr/bin/env python
# -*- coding: utf-8 -*-

import json
import csv
import numpy as np

filename = "aggregated.json"
outputname = "aggregated.csv"
with open(filename) as input_file:
    with open(outputname, "w") as output_file:
        data = json.load(input_file)
        writer = csv.writer(output_file)
        writer.writerow(["A", "B", "R", "v", "name", "simulated"])
        for dataset in data:
            for value in dataset["values"]:
                a, b, _ = value
                b = b / a ** 2
                writer.writerow(
                    [a, b, np.log(b) / np.log(a), 0.1, dataset["name"],
                     dataset["simulated"]]
                    )
