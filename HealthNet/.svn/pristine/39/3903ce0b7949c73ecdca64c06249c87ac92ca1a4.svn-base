from django.shortcuts import render

from ..models import *


from django.http import HttpResponse, HttpResponseRedirect

# Create your views here.

def index(request):
    user = request.user

    if not 'auth.patient' in user.get_all_permissions():
        return HttpResponseRedirect("/notauthorized")

    patient = Patient.objects.get(userNameField=user.username)

    context = {"messagenum": get_number_of_unread(user),'firstName': patient.firstName, 'lastName': patient.lastName, 'email': patient.email,
               'city': patient.city, 'state': patient.state, 'address1': patient.address1,
               'phone': patient.phone, 'insuranceName': patient.insuranceName, 'insuranceID': patient.insuranceID,
               'hospital': patient.hospital,
               'emergencyContactFirstName': patient.emergencyContactFirstName,
               'emergencyContactLastName': patient.emergencyContactLastName,
               'emergencyContactPhone': patient.emergencyContactPhone,
               'emergencyContactEmail': patient.emergencyContactEmail,
               'prescriptions': Prescription.objects.filter(patient=patient).order_by("-dateTime"),
               'tests': PatientTest.objects.filter(patient=patient).order_by("-dateTime")
               }
    return render(request, 'patients/patientViewPatientDetails.html', context)
