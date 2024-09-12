import face_recognition
import cv2 # an interface for working with image and video processing.
import numpy as np
import csv
from datetime import datetime
video_capture = cv2.VideoCapture(0)

# load known faces
harry_image = face_recognition.load_image_file("faces/harry.jpg")
harry_encoding = face_recognition.face_encodings(harry_image)[0]  # encodings are used so that image be converted into image and these are easy to compare.

hariom_image = face_recognition.load_image_file("faces/hariom.jpg")
hariom_encoding = face_recognition.face_encodings(hariom_image)[0] # encoding return the dimension of image , if 0 is used it means it will return the dimension of 1
# image

ankur_image = face_recognition.load_image_file("faces/ankur.jpg")
ankur_encoding = face_recognition.face_encodings(ankur_image)[0]


abhinav_image = face_recognition.load_image_file("faces/abhinav.jpg")
abhinav_encoding = face_recognition.face_encodings(abhinav_image)[0]

diwakar_image = face_recognition.load_image_file("faces/diwakar.jpg")
diwakar_encoding = face_recognition.face_encodings(diwakar_image)[0]

sandeep_image = face_recognition.load_image_file("faces/sandeep.jpg")
sandeep_encoding = face_recognition.face_encodings(sandeep_image)[0]

manjeet_image = face_recognition.load_image_file("faces/manjeet.jpg")
manjeet_encoding = face_recognition.face_encodings(manjeet_image)[0]

abhishekprabhakarsir_image = face_recognition.load_image_file("faces/abhishekprabhakarsir.jpg")
abhishekprabhakarsir_encoding = face_recognition.face_encodings(abhishekprabhakarsir_image)[0]

known_face_encodings = [harry_encoding, hariom_encoding, ankur_encoding, abhinav_encoding, diwakar_encoding,sandeep_encoding,manjeet_encoding,abhishekprabhakarsir_encoding]
known_face_names = ["Harry","Hariom","Ankur", "Abhinav","Diwakar","Sandeep","Manjeet","Abhishek Prabhakar sir"] #this is used to save the name of the encoding
# list of expected students
students = known_face_names.copy() # this for students that will come to give the attendance.
face_locations = []
face_encodings = []
# get the current date and time
now = datetime.now() # now is here is used to formatting of the time.
current_date = now.strftime("%Y-%m-%d")
f = open(f"{current_date}.csv", "w+", newline="")# this is the csv writer who will write for me in csv writer file
lnWriter = csv.writer(f)  

while True:
    _,  frame = video_capture.read()
    small_frame = cv2.resize(frame, (0, 0), fx=1.0, fy=1.0) # this is used for the resizing of our image.
    rgb_small_frame = cv2.cvtColor(small_frame, cv2.COLOR_BGR2RGB)   # to give color to our frames.

    # recognize faces
    face_locations = face_recognition.face_locations(rgb_small_frame) # this is to get the location of our formed frames.
    face_encodings = face_recognition.face_encodings(rgb_small_frame, face_locations) # encoding of the faces obtained from the web cam.

    for face_encoding in face_encodings:
        matches = face_recognition.compare_faces(known_face_encodings, face_encoding)#  for comparing the faces stored and obtained by the web cam
        face_distance = face_recognition.face_distance(known_face_encodings, face_encoding)#7890
        best_match_index = np.argmin(face_distance) # this will give the extent to which our faces are matched

        if matches[best_match_index]: #when compared faces matches true then i will get their name
            name = known_face_names[best_match_index]

        # Add the text if a person is present
        if name in known_face_names:
            font = cv2.FONT_HERSHEY_SIMPLEX
            bottomLeftCornerOfText = (10, 100)
            fontScale = .5
            fontColor = (255, 0, 0)
            thickness = 1
            lineType = 2
            cv2.putText(frame, name + " Present", bottomLeftCornerOfText, font, fontScale, fontColor, thickness, lineType)

            if name in students:
                students.remove(name) #this is used to remove the student form the expected list if he is present already in ourclass
                current_time = now.strftime("%H-%M-%S")
                lnWriter.writerow([name, current_time])


        cv2.imshow("Attendance", frame)
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break








