from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime
import patients.ViewsFolder.DoctorAdmitDischargePatient

# Create your views here.

def index(request, patientid):

    user = request.user
    userobj = Doctor.objects.get(userNameField=user.username)
    #Redirect if not logged in
    if 'auth.doctor' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    #Get info
    if request.method == "POST":
        details = request.POST.get('details', '')
        name = request.POST.get('name', '')
        patientList = Patient.objects.order_by("firstName")

        mainPatient = None

        #Identify patient
        for patient in patientList:
            if str(patient.id) == patientid:
                mainPatient = patient
                break


        newTest = PatientTest(patient=mainPatient, details=details, dateTime=datetime.datetime.now(),
                                 doctor=userobj, name=name)
        newTest.save()




    patientList = Patient.objects.order_by("firstName")

    mainPatient = None
    #Identify patient
    for patient in patientList:
        if str(patient.id) == patientid:
            mainPatient = patient
            break



    testList = PatientTest.objects.order_by("dateTime")

    patientTestList = []

    #Create test list
    for test in testList:
        if mainPatient.id == test.patient.id:
            patientTestList += [(test.dateTime, test.name, test.details)]



    nameToSendBack = mainPatient.__str__()



    patientTestList.reverse()

    context = {'name': user.first_name + " " + user.last_name, "patientID": patientid, "patientName": nameToSendBack, 'tests': patientTestList,
               "messagenum": get_number_of_unread(user)}
    return render(request, 'patients/doctorReleaseTest.html', context)
