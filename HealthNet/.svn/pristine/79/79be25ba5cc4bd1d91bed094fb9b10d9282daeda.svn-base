from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime

# Create your views here.

def index(request, patientdoctorid, daynumber):

    user = request.user
    #Redirect if not logged in
    if 'auth.nurse' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    userobj = Nurse.objects.get(userNameField=user.username)

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

    if daynumber > 6 or daynumber < 0:
        return HttpResponseRedirect("/nursecalendar")

    appointmentsToday = []






    for appointment in appointmentList:
        dateDiff = appointment.dateTime.toordinal() - currentDay
        if dateDiff != daynumber:
            continue

        if appointment.hospital != nurse.hospital:
            continue

        if isDoctor:
            if mainDoctor.id == appointment.doctor.id:
                appointmentsToday += [(appointment.dateTime.time(), appointment.patient, appointment.hospital, appointment.id)]

        if isPatient:
            if mainPatient.id == appointment.patient.id:
                appointmentsToday += [(appointment.dateTime.time(), appointment.doctor, appointment.hospital, appointment.id)]



    nameToSendBack = ""

    if isDoctor:
        nameToSendBack += "Doctor " + mainDoctor.__str__()
    else:
        nameToSendBack += "Patient " + mainPatient.__str__()


    context = {"name": userobj.firstName + " " + userobj.lastName, "messagenum": get_number_of_unread(user),'appointments': appointmentsToday, "backURL": "/nursecalendar/" + patientdoctorid,
               "otherName": nameToSendBack, "date": datetime.datetime.fromordinal(datetime.datetime.today().toordinal() + daynumber).date()}
    return render(request, 'patients/nurseDay.html', context)
