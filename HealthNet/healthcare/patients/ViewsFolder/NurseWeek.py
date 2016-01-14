from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime

# Create your views here.

def index(request, patientdoctorid):

    user = request.user
    #Redirect if not logged in
    if 'auth.nurse' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    doctorList = Doctor.objects.order_by("firstName")

    patientList = Patient.objects.order_by("firstName")

    isPatient = False
    mainPatient = None
    isDoctor = False
    mainDoctor = None


    for doctor in doctorList:
        if str(doctor.id) == patientdoctorid:
            isDoctor = True
            mainDoctor = doctor
            break


    for patient in patientList:
        if str(patient.id) == patientdoctorid:
            isPatient = True
            mainPatient = patient
            break

    if not isPatient and not isDoctor:
        return HttpResponseRedirect("/nursecalendar")



    appointmentList = Appointment.objects.order_by("dateTime")


    nurse=Nurse.objects.get(userNameField=user.username)

    currentDay = datetime.datetime.today().toordinal()

    dayList = []
    matchingDates = []
    listOfURLS = []



    for i in range(0, 7):
        dayList += [0]
        matchingDates += [datetime.datetime.fromordinal(currentDay + i).date()]
        listOfURLS += ["/nursecalendar/" + patientdoctorid + "/" + str(i)]




    for appointment in appointmentList:
        dateDiff = appointment.dateTime.toordinal() - currentDay
        if dateDiff > 6 or dateDiff < 0:
            continue

        if appointment.hospital != nurse.hospital:
            continue

        if isDoctor:
            if mainDoctor.id == appointment.doctor.id:
                dayList[dateDiff] += 1

        if isPatient:
            if mainPatient.id == appointment.patient.id:
                dayList[dateDiff] += 1


    finishedTupleList = []


    for i in range(0,7):
        finishedTupleList += [(dayList[i], listOfURLS[i])]

    nameToSendBack = ""

    if isDoctor:
        nameToSendBack += "Doctor " + mainDoctor.__str__()
    else:
        nameToSendBack += "Patient " + mainPatient.__str__()




    context = {'name': user.first_name + " " + user.last_name, "messagenum": get_number_of_unread(user),'dayList': finishedTupleList, 'matchingDates': matchingDates, "otherName": nameToSendBack}
    return render(request, 'patients/nurseWeek.html', context)
