import random
import os
import json
import math
from typing import List
import numpy as np

"""
Initial input json
{
    "1": {
        "lfemur": {
            "coordinate": [x,y,z],
            "matrix": [ [a,b,c], [e,f,g], [h,i,j] ]
        },
        ...
    },
    ...
}
"""

"""
Non-time series form
[
    {
        "lfemur": {
            "coordinate": [x,y,z],
            "matrix": [ [a,b,c], [e,f,g], [h,i,j] ]
        },
        "lclavicle": {
            "coordinate": [x,y,z],
            "matrix": [ [a,b,c], [e,f,g], [h,i,j] ]
        },
        ...
    },
    ...
]

list of frames
 frame = list of joints
"""


class NTSData:
    data = []

    def __init__(self, folder_list: List[str], joints_of_interest=None):
        # for testing w/ fake data
        if folder_list != None:
            self._read_folder(folder_list[0])

        self.joints_of_interest = joints_of_interest

    def do_all_processing(self, outfile):
        self.normalize_rotation()
        self.normalize_position()
        self.normalize_for_bounding_box()
        self.filter_to_labels(self.joints_of_interest)
        self._prepare_for_serialization()
        self._write_file(outfile)

    def shuffle(self):
        random.shuffle(self.data)

    @staticmethod
    def get_frame_shoulder_center(frame: dict):
        assert "lclavicle" in frame.keys() and "rclavicle" in frame.keys()
        lshoulder_coord = frame["lclavicle"]["coordinate"]
        rshoulder_coord = frame["rclavicle"]["coordinate"]

        assert len(lshoulder_coord) == len(rshoulder_coord)

        midpoint = (lshoulder_coord + rshoulder_coord) / 2
        return midpoint

    def normalize_position(self, body_data=None):
        """
            Translates every frame to have its shoulder center 
            be centered at 0, 0, 0. All other joints are translated
            the same amount
        """
        print("Normalizing Position", flush=True)

        # cannot do this as a default parameter since it is evaluated at runtime or something
        if body_data is None:
            body_data = self.data

        # translate to
        shoulder_center_target = np.array([0.0, 0, 0])

        frame: dict
        for frame in body_data:
            frame_center_actual = NTSData.get_frame_shoulder_center(frame)
            offset = shoulder_center_target - frame_center_actual

            for joint in frame.values():
                joint["coordinate"] += offset

    @staticmethod
    def get_unit_vector(vector):
        return vector / np.linalg.norm(vector)

    @staticmethod
    def _get_forward_dir(frame):
        """
            Gets 3D forward direction for a frame.
            Forward is defined at between the shoulders, facing forward
            Returns 3D ndarray.
        """
        # thor + thor_to_clav = clav
        # thor_to_clav = clav - thor
        thor = frame["thorax"]["coordinate"]
        lclav = frame["lclavicle"]["coordinate"]
        rclav = frame["rclavicle"]["coordinate"]

        assert isinstance(lclav, np.ndarray)

        thorax_to_lclav = lclav - thor
        thorax_to_rclav = rclav - thor

        forward = np.cross(thorax_to_lclav, thorax_to_rclav)

        forward_hat = NTSData.get_unit_vector(forward)
        return forward_hat

    @staticmethod
    def _get_angle_between(a, b):
        """
                       /  a dot b  \
        theta = cos^-1 | --------- |
                       \ |a| * |b| /
        """
        assert a.shape == (3,)
        assert b.shape == (3,)
        dot_prod = np.dot(a, b)
        mag_prod = np.linalg.norm(a) * np.linalg.norm(b)

        # resolves a floating point error issue on dot_prod
        if math.isclose(dot_prod, mag_prod):
            dot_prod = mag_prod
        elif math.isclose(-1 * dot_prod, mag_prod):
            dot_prod = -1 * mag_prod

        theta = math.acos(dot_prod / mag_prod)

        return theta

    def normalize_rotation(self, body_data=None):
        """
        define desired forward
        define frame rotation calculation method
         perpindicular vector to shoulders vector
        for each frame
         calc req rotation
         for each joint's coords (and mat?)
          rotate point about origin the calc'ed amount
        """
        print("Normalizing Rotation", flush=True)

        if body_data == None:
            body_data = self.data

        desired_forward = np.array([0.0, 0, 1])

        for frame in body_data:
            shoulder_center = NTSData.get_frame_shoulder_center(frame)

            frame_forward = NTSData._get_forward_dir(frame)
            shoulder_center_down = NTSData.get_unit_vector(
                frame["thorax"]["coordinate"] - shoulder_center
            )
            left_vec = np.cross(frame_forward, shoulder_center_down)

            transform = np.array([left_vec, -shoulder_center_down, frame_forward])

            determ = np.linalg.det(transform)
            assert math.isclose(determ, 1.0)

            if np.all(frame["rclavicle"]["coordinate"] == np.array([2, 3, 1.2])):
                print(frame)
                print(transform)

            for joint_key in frame.keys():
                point_vec = frame[joint_key]["coordinate"]

                rotated_point = np.matmul(transform, point_vec)

                assert rotated_point.shape == (3,)
                frame[joint_key]["coordinate"] = rotated_point

    def normalize_for_bounding_box(self, body_data=None):
        """
        All frame data is scaled and shifted to be entirely contained
        within the space of [0, 1]^3
        """
        print("Normalizing Scaling", flush=True)
        if body_data == None:
            body_data = self.data

        bounds = {"x": (0, 0), "y": (0, 0), "z": (0, 0)}

        for idx in range(len(bounds)):
            bounds[idx] = NTSData._get_bounds_of_axis(
                idx, body_data, self.joints_of_interest
            )

        bound_magnitudes_list = []
        for bound_pair in bounds.values():
            for bound in bound_pair:
                bound_magnitudes_list.append(abs(bound))
        max_bound = max(bound_magnitudes_list)

        for frame in body_data:
            for key in frame.keys():
                # scale limiting_joints within [-0.5, 0.5]
                frame[key]["coordinate"] = frame[key]["coordinate"] / max_bound / 2
                # translate limiting_joints to [0, 1]
                frame[key]["coordinate"] = frame[key]["coordinate"] + 0.5

    @staticmethod
    def _get_bounds_of_axis(axis, body_data, joints):
        """
        Gets the min and max bound from the joint labels in joints
        """
        points = []
        for frame in body_data:
            for joint_label in joints:
                points.append(frame[joint_label]["coordinate"][axis])

        return min(points), max(points)

    def filter_to_labels(self, labels):
        for idx in range(len(self.data)):
            self.data[idx] = {label: self.data[idx][label] for label in labels}

    def get_testing_training(
        self, percent_training, x_feature_labels, y_feature_labels
    ):
        training_count = percent_training * len(self.data[0])
        print(
            "Dividing data into "
            + percent_training
            + "% / "
            + training_count
            + "frames for training"
        )
        x_data = []
        y_data = []

    def _prepare_for_serialization(self):
        for frame in self.data:
            for joint_label in frame.keys():
                # np ndarray's cannot be serialized into json
                #  flatten matrixes. (This is a vector.)
                frame[joint_label]["coordinate"] = frame[joint_label][
                    "coordinate"
                ].tolist()
                frame[joint_label]["matrix"] = None

    def _read_folder(self, folder_path):
        for file in os.listdir(folder_path):
            if file.endswith(".json"):
                self._read_file(folder_path + "\\" + file)

    def _read_file(self, file_path):
        print("Reading: " + file_path, flush=True)
        mocap_rec_data = json.load(open(file_path))
        for frame in mocap_rec_data.values():
            for joint in frame.values():
                joint["coordinate"] = np.array(joint["coordinate"], dtype="float64")
                joint["matrix"] = np.array(joint["matrix"])
            self.data.append(frame)

    def _write_file(self, outfile):
        print("Writing to: {}".format(outfile), flush=True)
        with open(outfile, "w") as fp:
            json.dump(self.data, fp)


ALL_JOINTS = [
    "head",
    "upperneck",
    "lowerneck",
    "lclavicle",
    "lhumerus",
    "lradius",
    "lwrist",
    "lhand",
    "lthumb",
    "lfingers",
    "rclavicle",
    "rhumerus",
    "rradius",
    "rwrist",
    "rhand",
    "rthumb",
    "rfingers",
    "thorax",
    "upperback",
    "lowerback",
    "root",
    "lhipjoint",
    "lfemur",
    "ltibia",
    "lfoot",
    "ltoes",
    "rhipjoint",
    "rfemur",
    "rtibia",
    "rfoot",
    "rtoes",
]

RELEVANT_JOINTS = [
    "thorax",
    "rclavicle",
    "lhumerus",
    "rhumerus",
    "lradius",
    "rradius",
]

if __name__ == "__main__":
    ntsdata = NTSData(["E:/Desktop/Thesis/subject_data/80"], ALL_JOINTS)
    ntsdata.do_all_processing("80_postproc_full.json")

