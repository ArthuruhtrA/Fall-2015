from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

# Create your views here.

def index(request):

    user = request.user
    pOd = "doctor" if 'auth.doctor' in user.get_all_permissions() else "nurse"
    userobj = Doctor.objects.get(userNameField=user.username) if pOd == "doctor" else Nurse.objects.get(userNameField=user.username)
    #Redirect if not logged in
    if 'auth.doctor' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")




    patientList = Patient.objects.order_by("firstName")

    patients = []

    for patient in patientList:
        patientURL = "/viewpatient/" + str(patient.id)
        patients += [(patient, patientURL)]


    context = {"pOd": pOd, "name": userobj.firstName + " " + userobj.lastName, "messagenum": get_number_of_unread(user),'patients' : patients}
    return render(request, 'patients/listOfPatients.html', context)
