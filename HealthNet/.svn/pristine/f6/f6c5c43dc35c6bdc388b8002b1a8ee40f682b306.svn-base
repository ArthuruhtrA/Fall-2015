from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *
from datetime import datetime

# Create your views here.
def index(request):
    user = request.user
    userobj = Patient.objects.get(userNameField=user.username)
    testString = 'auth.patient' in user.get_all_permissions()

    if not testString:
        return HttpResponseRedirect("/notauthorized")
    if request.method == "POST":
        month = request.POST.get('month', '')
        day = request.POST.get('day', '')
        year = request.POST.get('year', '')
        doctor = request.POST.get('doctor', '')
        time = request.POST.get('time', '')
        if month == '' or day == '' or year == '' or doctor == '' or time == '':
            return render(request, 'patients/patientCreateAppointment.html',
                          {"messagenum": get_number_of_unread(user),"name": userobj.firstName + " " + userobj.lastName, "errortext" : "Missing Required Field", "doctors" : Doctor.objects.order_by("firstName")})


        patient=Patient.objects.get(userNameField=user.username)




        try:
            appointment = Appointment(doctor=Doctor.objects.get(lastName=doctor.split()[1]), patient=patient,
                                      dateTime=datetime.strptime(month + ' ' + day +  ' ' + year + ' ' + time + "00", '%m %d %Y %H:%M%S'),
                                      hospital=patient.hospital)
        except ValueError:
            return render(request, 'patients/patientCreateAppointment.html',
                          {"messagenum": get_number_of_unread(user),"name": userobj.firstName + " " + userobj.lastName, "errortext" : "Invalid Day", "doctors" : Doctor.objects.order_by("firstName")})




        appointment.save()

        log_add("Patient " + str(patient) + " created an appointment.")

        return HttpResponseRedirect("/calendar")

    else :
        today = datetime.now()

        return render(request, 'patients/patientCreateAppointment.html', {"messagenum": get_number_of_unread(user),"name": userobj.firstName + " " + userobj.lastName,  "doctors" : Doctor.objects.order_by("firstName"), "day":today.day})
