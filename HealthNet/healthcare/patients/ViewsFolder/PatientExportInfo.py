from django.shortcuts import render
import csv

from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime
import patients.ViewsFolder.DoctorAdmitDischargePatient

# Create your views here.

def index(request):

    user = request.user

    #Redirect if not logged in
    if 'auth.patient' not in user.get_all_permissions() or 'auth.doctor' in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    userobj = Patient.objects.get(userNameField=user.username)







    presriptionList = Prescription.objects.order_by("dateTime")

    patientPrescriptionList = []


    for prescription in presriptionList:
        if userobj.id == prescription.patient.id:
            patientPrescriptionList += [(prescription.dateTime, prescription.name, prescription.reason)]


    testList = PatientTest.objects.order_by("dateTime")

    patientTestList = []


    for test in testList:
        if userobj.id == test.patient.id:
            patientTestList += [(test.dateTime, test.name, test.details)]



    nameToSendBack = userobj.__str__()



    patientPrescriptionList.reverse()

    context = {'name': user.first_name + " " + user.last_name, "patientName": nameToSendBack,
               'prescriptions': patientPrescriptionList,
               'tests': patientTestList,
               "messagenum": get_number_of_unread(user)}




    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="MedicalInformation.csv"'

    writer = csv.writer(response)
    writer.writerow([user.first_name + " " + user.last_name])
    writer.writerow([" "])
    writer.writerow(["Prescriptions:"])
    writer.writerow(["Date", "Name", "Reason"])
    for prescription in patientPrescriptionList:
        writer.writerow([prescription[0], prescription[1], prescription[2]])
    writer.writerow([" "])
    writer.writerow(["Tests:"])
    writer.writerow(["Date", "Name", "Details"])
    for test in patientTestList:
        writer.writerow([test[0], test[1], test[2]])

    return response



