import json
import numpy as np
import math


def _format(input_json_path, input_joint_order, target_joint):
    preproc_data = json.load(open(input_json_path))
    input_data = []
    target_data = []

    for frame in preproc_data:
        frame_array = []

        for joint in input_joint_order:
            frame_array.extend(frame[joint]["coordinate"])

        input_data.append(np.array(frame_array))

        target_data.append(np.array(frame[target_joint]["coordinate"]))

    return np.array(input_data), np.array(target_data)


def get_data(input_json_path, input_joint_order, target_joint):
    input_data, output_data = _format(input_json_path, input_joint_order, target_joint)
    frame_count = len(input_data)

    # a very rough way of ensuring that training and testing data uses different mocaps
    cutoff = math.floor(0.7 * frame_count)
    x_train = input_data[:cutoff]
    x_test = input_data[cutoff:]
    y_train = output_data[:cutoff]
    y_test = output_data[cutoff:]

    for data_set in [x_train, x_test, y_train, y_test]:
        np.random.shuffle(data_set)

    return x_train, y_train, x_test, y_test

