#!/usr/bin/python
import sys

class park:
	def __init__(self,floor,slots,regno,color):
		self.floor = floor
		self.slots = slots
		self.regno = regno
		self.color = color

	def getColor(self):
		carData = {}
		try:
			with open('parkingRegister.txt',"r+") as output_file:
				allparking = output_file.read().split('\n')
				counter = 0
				for allprkg in allparking:
					if self.color == allprkg.split(',')[2]:
						carData[str(counter)] = [int(allprkg.split(',')[0]),allprkg.split(',')[1],allprkg.split(',')[2]]
						counter += 1
				return carData
		except:
			return carData


	def getRegno(self):
		carData = {}
		try:
			with open('parkingRegister.txt',"r+") as output_file:
				allparking = output_file.read().split('\n')
				counter = 0
				for allprkg in allparking:
					if self.regno == allprkg.split(',')[1]:
						carData[str(counter)] = [int(allprkg.split(',')[0]),allprkg.split(',')[1],allprkg.split(',')[2]]
						counter += 1
				return carData
		except:
			return carData


	def add(self,x):
		with open('parkingRegister.txt',"a+") as output_file:
			output_file.write('{0}\n'.format(x))

			
	def get(self):
		filledsites = []
		try:
			with open('parkingRegister.txt',"r+") as output_file:
				allparking = output_file.read().split('\n')
				for allprkg in allparking:
					filledsites.append(int(allprkg.split(',')[0]))
				return filledsites
		except:
			return filledsites


	def availParkingList(self,site):
		start = 1
		end = int(self.floor)*int(self.slots)
		return sorted(set(range(start, end + 1)).difference(site))


	def allotParkingBlock(self,site):
		pList = self.availParkingList(site)
		pListCount = len(pList)
		parkingRegister = ''
		if pListCount > 0 :
			#allocate
			parkingRegister += str(pList[0])
			parkingRegister += ','+self.regno
			parkingRegister += ','+self.color
			print('allocate')
			self.add(parkingRegister)
		else:
			#no parking
			print('Parking Full')


def main():
	action = sys.argv[1]
	if action == "add":
		floor = sys.argv[2]
		slots = sys.argv[3]
		userRegnumber = sys.argv[4]
		userColor = sys.argv[5]
		parkObj = park(floor,slots,userRegnumber,userColor)
		site = parkObj.get()
		parkObj.allotParkingBlock(site)
	elif action == "getbycolor":
		color = sys.argv[2]
		parkObj = park(0,0,0,color)
		data = parkObj.getColor()
		print(data)
	elif action == "getbyregno":
		regno = sys.argv[2]
		parkObj = park(0,0,regno,0)
		data = parkObj.getRegno()
		print(data)
	# elif action == "deletebycolor":
		# parkObj = park(0,0,0,0)
		# color = sys.argv[2]
		# parkObj.deleteColor(color)
	# elif action == "deletebyregno":
		# parkObj = park(0,0,0,0)
		# regno = sys.argv[2]
		# parkObj.deleteRegno(regno)
	
if __name__ == '__main__':
	main()