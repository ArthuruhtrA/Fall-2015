from django.shortcuts import render
from django.http import HttpResponse, HttpResponseRedirect
from django.contrib import auth
from ..models import *
from datetime import datetime

# Edit Details for Patient
def index(request, patientid):
    user = request.user

    if not 'auth.doctor' in user.get_all_permissions()  or 'auth.nurse' in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    #Get the patient from the database
    patientList = Patient.objects.order_by("firstName")

    mainPatient = None

    for patient in patientList:
        if str(patient.id) == patientid:
            mainPatient = patient
            break

    context = {'messagenum': get_number_of_unread(user),
               'patient': mainPatient,
               'name': user.first_name + " " + user.last_name,
               'hospitals' : Hospital.objects.order_by("name")}

    if request.method == "POST":
        #Add message to context in case there are errors with the form
        context['errortext'] = "Missing Required Field"

        #Get all values from the POST
        hospital = request.POST.get('hospital', '')
        medicalInformation = request.POST.get('medicalinformation', '')

        #Validate fields
        if hospital == '' or medicalInformation == '':
            return render(request, 'patients/doctorEditTransferPatient.html', context)

        #Set new values of patient and user
        mainPatient.hospital = Hospital.objects.get(name=hospital)
        mainPatient.medicalInformation = medicalInformation


        patient.save()


        return HttpResponseRedirect("/doctoredittransferpatient/" + patientid)

    else:
        # Using previous context, load the page
        return render(request, 'patients/doctorEditTransferPatient.html', context)
