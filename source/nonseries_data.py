import random
import os
import json
import math
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

    def __init__(self, folder_list):
        # for testing w/ fake data
        if folder_list != None:
            self._read_folder(folder_list[0])
        
    def shuffle(self):
        random.shuffle(self.data)

    @staticmethod
    def get_frame_shoulder_center(frame: dict):
        assert('lclavicle' in frame.keys() and 'rclavicle' in frame.keys())
        lshoulder_coord = frame['lclavicle']['coordinate']
        rshoulder_coord = frame['rclavicle']['coordinate']  
        
        assert(len(lshoulder_coord) == len(rshoulder_coord))

        midpoint = (lshoulder_coord + rshoulder_coord) / 2
        return midpoint
            

    def normalize_position(self, body_data=None):
        """
            Translates every frame to have its shoulder center 
            be centered at 0, 0, 0. All other joints are translated
            the same amount
        """
        # cannot do this as a default parameter since it is evaluated at runtime or something
        if body_data is None:
            body_data = self.data
            
        #translate to
        shoulder_center_target = np.array([0., 0, 0])

        frame: dict
        for frame in body_data:
            frame_center_actual = NTSData.get_frame_shoulder_center(frame)
            offset = shoulder_center_target - frame_center_actual

            for joint in frame.values():
                joint['coordinate'] += offset

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
        thor  = frame['thorax']['coordinate']
        lclav = frame['lclavicle']['coordinate']
        rclav = frame['rclavicle']['coordinate']

        assert(isinstance(lclav, np.ndarray))

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
        dot_prod = np.dot(a, b)
        mag_prod = np.linalg.norm(a) * np.linalg.norm(b)
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
        if body_data == None:
            body_data = self.data

        desired_forward = np.array([0., 1, 0])

        for frame in body_data:
            midpoint = NTSData.get_frame_shoulder_center(frame)
            
            frame_forward = NTSData._get_forward_dir(frame)
            mid_left = NTSData.get_unit_vector(frame['lclavicle']['coordinate'] - midpoint)
            thor_up = NTSData.get_unit_vector(midpoint - frame['thorax']['coordinate'])

            transform = np.array([mid_left, frame_forward, thor_up])
            print('Transform')
            print(transform)
            
            for joint_key in frame.keys():
                point_vec = frame[joint_key]['coordinate']
                rotated_point = np.matmul(transform, point_vec)

                assert(rotated_point.shape == (3,))
                frame[joint_key]['coordinate'] = rotated_point
        
    
    def normalize_height(self):
        pass

    def normalize_bounding_box(self):
        pass

    def filter_to_labels(self, labels):
        for idx in range(len(self.data)):
            self.data[idx] = {label : self.data[idx][label] for label in labels}
    
    def get_testing_training(self, percent_training, x_feature_labels, y_feature_labels):
        training_count = percent_training * len(self.data[0])
        print("Dividing data into " + percent_training + "% / " + training_count + "frames for training")
        x_data = []
        y_data = []
        
    def _read_folder(self, folder_path):
        for file in os.listdir(folder_path):
            if file.endswith(".json"):
                self._read_file(folder_path + "\\" + file)

    def _read_file(self, file_path):
        print("Reading: " + file_path)
        mocap_rec_data = json.load(open(file_path))
        for frame in mocap_rec_data.values():
            for joint in frame:
                joint['coordinate'] = np.array(joint['coordinate'], dtype='float64')
                joint['matrix'] = np.array(joint['matrix'])
            self.data.append(frame)
    
