import numpy as np
import matplotlib.pyplot as plt 
import math
import functools as fct

def main():
	print("begin.")
	coords = gen_data()
	plt.plot(coords[0], coords[1])

	plt.axis([-6, 6, -6, 6])

	plt.title("Title")
	plt.show()

def gen_data():
	upper = 2.5
	fore = 2.0
	hand = 1.0

	shoulder_pose = np.matrix([ [1, 0, 0],
								[0, 1, upper],
								[0, 0, 1]],
								dtype=np.float32)

	elbow_pose = np.matrix([ 	[1, 0, 0],
								[0, 1, fore],
								[0, 0, 1]],
								dtype=np.float32)
	
	wrist_pose = np.matrix([[1, 0, 0],
							[0, 1, hand],
							[0, 0, 1]],
							dtype=np.float32)
	_45 = math.sqrt(2)/2	
	tilt45 = np.matrix([ 	[_45, _45, 0],
							[-_45, _45, 0],
							[0, 0, 1]])

	relative_poses = [np.matmul(tilt45, shoulder_pose), elbow_pose, wrist_pose]
	world_poses = fct.reduce(lambda m1,m2 : np.matmul(m1, m2), relative_poses)
	coords = np.matrix([[pose[0,2] for pose in world_poses],[pose[1,2] for pose in world_poses]], dtype=np.float32)
	return coords


if __name__ == "__main__":
	main()
