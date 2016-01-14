from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *
from datetime import datetime

# Create your views here.
def index(request, text):
    user = request.user
    userobj = Doctor.objects.get(userNameField=user.username)
    testString = 'auth.doctor' in user.get_all_permissions()

    if not testString:
        return HttpResponseRedirect("/notauthorized")

    doctor=Doctor.objects.get(userNameField=user.username)
    appointment = Appointment.objects.get(id=text)
    if request.method == "POST":
        month = request.POST.get('month', '')
        day = request.POST.get('day', '')
        year = request.POST.get('year', '')
        patient = request.POST.get('patient', '')
        time = request.POST.get('time', '')
        if month == '' or day == '' or year == '' or patient == '' or time == '':
            return render(request, 'patients/doctorUpdateCancelAppointment.html',
                          {"name": userobj.firstName + " " + userobj.lastName, "messagenum": get_number_of_unread(user),"errortext" : "Missing Required Field", "patients" : Patient.objects.order_by("firstName"),
                                                                                "appointment": appointment,
                                                                                "cancellink" : "/doctordeleteappointment/" + text})


        appointment.patient = patient
        appointment.dateTime = datetime.strptime(month + ' ' + day +  ' ' + year + ' ' + time + "00", '%B %d %Y %H:%M%S')

        patient = Patient.objects.get(lastName=patient.split()[1])

        appointment.save()

        log_add("Doctor " + str(doctor) + " edited an appointment.")

        return HttpResponseRedirect("/calendar")

    else :


        return render(request, 'patients/doctorUpdateCancelAppointment.html', {"name": userobj.firstName + " " + userobj.lastName, "messagenum": get_number_of_unread(user),"patients" : Patient.objects.order_by("firstName"),
                                                                                "appointment": appointment,
                                                                                "cancellink" : "/doctordeleteappointment/" + text})



def cancelAppointment(request, text):
    appointment = Appointment.objects.get(id=text)
    appointment.delete()

    doctor=Doctor.objects.get(userNameField=request.user.username)
    log_add("Doctor " + str(doctor) + " cancelled an appointment.")

    return HttpResponseRedirect("/calendar")
