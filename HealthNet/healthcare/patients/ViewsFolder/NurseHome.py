from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *

# Create your views here.

def index(request):

    user = request.user
    #Redirect if not logged in
    if 'auth.nurse' not in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    doctorList = Doctor.objects.order_by("firstName")

    doctors = []

    #Match doctors with urls
    for doctor in doctorList:
        doctorURL = "/nursecalendar/" + str(doctor.id)
        doctors += [(doctor, doctorURL)]


    patientList = Patient.objects.order_by("firstName")

    patients = []
    nurse=Nurse.objects.get(userNameField=user.username)

    #Match patients with urls
    for patient in patientList:
        if patient.hospital != nurse.hospital:
            continue
        patientURL = "/nursecalendar/" + str(patient.id)
        patients += [(patient, patientURL)]


    context = {'name': user.first_name + " " + user.last_name, "messagenum": get_number_of_unread(user),'doctors': doctors, 'patients' : patients}
    return render(request, 'patients/nurseHome.html', context)
