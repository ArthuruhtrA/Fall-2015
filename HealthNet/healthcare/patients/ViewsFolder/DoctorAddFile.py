from django.shortcuts import render
from django.shortcuts import render_to_response
from django.template import RequestContext
from django.core.urlresolvers import reverse
from django.http import HttpResponse, HttpResponseRedirect
from ..forms import DocumentForm
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

    #Get all patients
    patientList = Patient.objects.order_by("firstName")

    mainPatient = None

    for patient in patientList:
        if str(patient.id) == patientid:
            mainPatient = patient
            break

    #Get file from form
    if request.method == 'POST':
        form = DocumentForm(request.POST, request.FILES)



        if form.is_valid():
            newFile = PatientMedicalFile(file = request.FILES['docfile'], patient=mainPatient, doctor=userobj, dateTime=datetime.datetime.now())
            newFile.save()
    else:
        form = DocumentForm()








    fileList = PatientMedicalFile.objects.order_by("dateTime")

    patientFileList = []


    for file in fileList:
        if mainPatient.id == file.patient.id:
            patientFileList += [(file.dateTime, file.file)]



    nameToSendBack = mainPatient.__str__()



    patientFileList.reverse()

    context = {'name': user.first_name + " " + user.last_name, "patientID": patientid, "patientName": nameToSendBack, 'files': patientFileList,
               "messagenum": get_number_of_unread(user), "form": form}
    return render(request, 'patients/doctorAddFile.html', context)
