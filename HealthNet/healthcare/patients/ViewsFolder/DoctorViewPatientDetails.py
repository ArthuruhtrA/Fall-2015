from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

import datetime
import patients.ViewsFolder.DoctorAdmitDischargePatient

# Create your views here.

def index(request, patientid):

    user = request.user
    #Redirect if not logged in
    if 'auth.doctor' not in user.get_all_permissions() and 'auth.nurse' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    pOd = "doctor" if 'auth.doctor' in user.get_all_permissions() else "nurse"


    #Get info and direct that info to a different class
    if request.method == "POST":
        return patients.ViewsFolder.DoctorAdmitDischargePatient.index(request, patientid, request.POST.get('reason', ''))

    patientList = Patient.objects.order_by("firstName")

    mainPatient = None

    #Identify patient
    for patient in patientList:
        if str(patient.id) == patientid:
            mainPatient = patient
            break



    visitList = HospitalVisit.objects.order_by("dateAdmitted")

    patientVisitList = []


    #Create visit list
    for visit in visitList:
        if mainPatient.id == visit.patient.id:
            patientVisitList += [(visit.dateAdmitted, visit.dateDischarged, visit.reason)]



    nameToSendBack = mainPatient.__str__()

    admitted = False

    if patient.isAdmitted:
        admitted = True

    patientVisitList.reverse()


    context = {"pOd": pOd, 'name': user.first_name + " " + user.last_name, "messagenum": get_number_of_unread(user),
               'visits': patientVisitList, "patientName": nameToSendBack, "admitted": admitted, "patientID": patientid,
               "isDoctor": pOd == "doctor"}
    return render(request, 'patients/doctorViewPatientDetails.html', context)
