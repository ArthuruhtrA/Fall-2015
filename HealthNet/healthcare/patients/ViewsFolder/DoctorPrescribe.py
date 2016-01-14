from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime
import patients.ViewsFolder.DoctorAdmitDischargePatient

# Create your views here.

def index(request, patientid):

    user = request.user
    #Redirect if not logged in
    if 'auth.doctor' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    userobj = Doctor.objects.get(userNameField=user.username)

    #Get new prescription
    if request.method == "POST":
        reason = request.POST.get('reason', '')
        name = request.POST.get('name', '')
        patientList = Patient.objects.order_by("firstName")

        mainPatient = None

        for patient in patientList:
            if str(patient.id) == patientid:
                mainPatient = patient
                break


        newPrescription = Prescription(patient=mainPatient, reason=reason, dateTime=datetime.datetime.now(),
                                 doctor=userobj, name=name)
        newPrescription.save()




    patientList = Patient.objects.order_by("firstName")

    mainPatient = None

    #Identify patient
    for patient in patientList:
        if str(patient.id) == patientid:
            mainPatient = patient
            break



    presriptionList = Prescription.objects.order_by("dateTime")

    patientPrescriptionList = []

    #Create list of prescriptions
    for prescription in presriptionList:
        if mainPatient.id == prescription.patient.id:
            patientPrescriptionList += [(prescription.dateTime, prescription.name, prescription.reason)]



    nameToSendBack = mainPatient.__str__()



    patientPrescriptionList.reverse()

    context = {'name': user.first_name + " " + user.last_name, "patientID": patientid, "patientName": nameToSendBack, 'prescriptions': patientPrescriptionList,
               "messagenum": get_number_of_unread(user)}
    return render(request, 'patients/doctorPrescribe.html', context)
