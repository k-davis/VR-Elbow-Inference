import unittest
import itertools
import copy
import numpy as np
import math
from nonseries_data import NTSData 

class TestNTSDProcessing(unittest.TestCase):

	@staticmethod
	def build_test_frame(lx, ly, lz, rx, ry, rz):
		return {'lclavicle' : {"coordinate": np.array([lx, ly, lz])},
				'rclavicle' : {'coordinate': np.array([rx, ry, rz])}}

	def test_frame_shoulder_center(self):
		test_sets = ( ((0, 0, 0, 0, 0, 0), (0, 0, 0)), )
		for test_inp, test_out in test_sets:
			frame = TestNTSDProcessing.build_test_frame(*test_inp)
			shoulder_center = NTSData.get_frame_shoulder_center(frame)
			self.assertTrue(np.array_equal(shoulder_center, np.array(test_out)))
	
	def test_frame_shoulder_center_autogen(self):
		test_inps = itertools.combinations_with_replacement(np.arange(-5, 5, 1.2), 6)
		for test_inp in test_inps:
			test_inp = np.array(test_inp)
			test_out = (test_inp[0:3] + test_inp[3:6]) / 2
			
			frame = TestNTSDProcessing.build_test_frame(*test_inp)
			shoulder_center = NTSData.get_frame_shoulder_center(frame)
			self.assertTrue(np.array_equal(shoulder_center, test_out))

	def test_normalize_position_no_change(self):
		no_change_mocap_pre = [
			{	
				'lclavicle': {'coordinate': np.array([1, 2, 0], dtype='float64') },
				'rclavicle': {'coordinate': np.array([-1, -2, 0], dtype='float64') },
				'joint1': {'coordinate': np.array([0, -100.5, 63.4], dtype='float64') },
				'joint2': {'coordinate': np.array([75, -32, 84.2], dtype='float64') },
			},
			{	
				'lclavicle': {'coordinate': np.array([1, 1, 0], dtype='float64') },
				'rclavicle': {'coordinate': np.array([-1, -1, 0], dtype='float64') },
				'joint1': {'coordinate': np.array([-1, -0.5, 6.4], dtype='float64') },
				'joint2': {'coordinate': np.array([0, 0, 0], dtype='float64') },
			}
		]

		no_change_mocap_post = copy.deepcopy(no_change_mocap_pre)

		ntsd_proc = NTSData(None)
		ntsd_proc.normalize_position(body_data=no_change_mocap_post)

		for frame_idx in range(len(no_change_mocap_pre)):
			for joint_key in no_change_mocap_pre[frame_idx].keys():
				pre_coord = no_change_mocap_pre[frame_idx][joint_key]['coordinate']
				post_coord = no_change_mocap_post[frame_idx][joint_key]['coordinate']

				self.assertTrue(all(pre_coord == post_coord), 'Comparing f-%i j-\'%s\', coords %r and %r ' % (frame_idx, joint_key, pre_coord, post_coord))

	def test_normalize_position_w_change(self):
		mocap_pre = [
			{	
				'lclavicle': {'coordinate': np.array([2, 2, 3], dtype='float64') },
				'rclavicle': {'coordinate': np.array([0, 2, 3], dtype='float64') },
				'joint1': {'coordinate': np.array([0, -100.5, 63.4], dtype='float64') },
				'joint2': {'coordinate': np.array([75, -32, 84.2], dtype='float64') },
			},
			{	
				'lclavicle': {'coordinate': np.array([1, 2, 3], dtype='float64') },
				'rclavicle': {'coordinate': np.array([-1, -1, 4], dtype='float64') },
				'joint1': {'coordinate': np.array([-1, -0.5, 6.4], dtype='float64') },
				'joint2': {'coordinate': np.array([0, 0, 0], dtype='float64') },
			}
		]
		# mid points
		#  [1,   2,   3]
		#  [0, 0.5, 3.5]
		expected_translations = [
			np.array([-1.0, -2.0, -3.0]),
			np.array([ 0.0, -0.5, -3.5])
		]

		mocap_post = copy.deepcopy(mocap_pre)
		ntsd_proc = NTSData(None)
		ntsd_proc.normalize_position(body_data=mocap_post)

		for frame_idx in range(len(mocap_pre)):
			for joint_key in mocap_pre[frame_idx].keys():
				pre_coord = mocap_pre[frame_idx][joint_key]['coordinate']
				post_coord = mocap_post[frame_idx][joint_key]['coordinate']
				expect_offset = expected_translations[frame_idx]
				expect_post = pre_coord + expect_offset
				self.assertTrue(all(pre_coord + expected_translations[frame_idx] == post_coord), 'Comparing f-%i j-\'%s\',\n\tpre: \t\t%r \n\tactual post: \t%r\n\texpect post: \t%r\n\toffset: \t%r' % (frame_idx, joint_key, pre_coord, post_coord, expect_post, expect_offset))

	@staticmethod
	def build_tgff_frame(lclav, rclav, thor):
		return {
			'lclavicle': 	{'coordinate': np.array(lclav)},
			'rclavicle':	{'coordinate': np.array(rclav)},
			'thorax': 		{'coordinate': np.array(thor)}
		}

	def test_get_frame_forward(self):
		frame = TestNTSDProcessing.build_tgff_frame
		# frame: lclav
		#		 rclav
		#		 thorax
		test_cases = [ 	(frame(	[-1., 0, 1],
								[ 1., 0, 1],
								[ 0., 0, 0]
							),
							np.array([0., 1, 0])
						),

						(frame(	[ 4., 4, 2],
								[ 2., 2, 1],
								[ 3., 3, 1]
							),
							NTSData.get_unit_vector(np.array([2., -2, 0]))
						),

						(frame(	[  4.,  4.0, 2.0],
								[  2., -0.3, 2.4],
								[ -5.,  3.0, 1.0]
							),
							NTSData.get_unit_vector(np.array([4.7, -5.6, -36.7]))
						),

					]

		for idx, (test_frame, expected_forward) in enumerate(test_cases):
			actual_forward = NTSData._get_forward_dir(test_frame)
			self.assertTrue(all(np.isclose(expected_forward, actual_forward)) , 'Test case %i \nExpected forward: \t%r\nshould match actual: \t%r ' % (idx, expected_forward, actual_forward))

	def test_normalize_rotation(self):
		# position is already normalized, ie thorax is [0, 0, 0]
		
		frame = TestNTSDProcessing.build_tgff_frame

		test_cases_pre = [frame([-1., 0, 1],
								[ 1., 0, 1],
								[ 0., 0, 0]	
							),

						frame(	[ 4., 4, 2],
								[ 2., 3, 1],
								[ 0., 0, 0]
							),
							
						frame(	[  4.,  4.0, 2.0],
								[  2., -0.3, 2.4],
								[  0.,  0,   0.0]
							),

						frame( 	[ 0., -1, 1],
								[ 0., 1, 1],
								[ 0., 0, 0]	

							)
					]

		test_cases_post = copy.deepcopy(test_cases_pre)

		ntsdata = NTSData(None)
		ntsdata.normalize_rotation(test_cases_post)

		# post-conditions:
		# !!! the clavicles have the same z !!! not really if the shoulders are different distances from thorax
		# clavicles both have y=0
		# !!!nope!!! clavicle x coords are inverted 
		# thorax still at 0 0 0
		
		# lclav is (1, 0, 0)
		for fr_idx, frame_pre in enumerate(test_cases_pre):
			pre_lclav = frame_pre['lclavicle']['coordinate']
			pre_rclav = frame_pre['rclavicle']['coordinate']
			pre_thor =  frame_pre['thorax']['coordinate']

			post_lclav = test_cases_post[fr_idx]['lclavicle']['coordinate']
			post_rclav = test_cases_post[fr_idx]['rclavicle']['coordinate']
			post_thor =  test_cases_post[fr_idx]['thorax']['coordinate']

			# static assertions
			self.assertTrue(post_lclav[1] == 0)
			self.assertTrue(post_rclav[1] == 0)
			self.assertTrue(all(np.isclose(post_thor, np.array([0., 0, 0]))))

			#relative assertions


			angle_between_pre = NTSData._get_angle_between(pre_lclav, pre_rclav)
			angle_between_post = NTSData._get_angle_between(post_lclav, post_rclav)
			print("Angle pre : {}".format(angle_between_pre))
			print("Angle post: {}".format(angle_between_post) )
			self.assertTrue(math.isclose(angle_between_pre, angle_between_post))

			print(str(np.linalg.norm(pre_lclav)) + "   " +  str(np.linalg.norm(post_lclav)))
			print(f'{pre_lclav}    {post_lclav}')
			self.assertTrue(math.isclose(np.linalg.norm(pre_lclav), np.linalg.norm(post_lclav)))
			self.assertTrue(math.isclose(np.linalg.norm(pre_rclav), np.linalg.norm(post_rclav)))

			





if __name__ == '__main__':
	unittest.main()