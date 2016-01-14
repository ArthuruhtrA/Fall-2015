from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *
from datetime import datetime, timedelta
from django.utils import timezone


def index(request):
    user = request.user
    userobj = Patient.objects.get(userNameField=user.username)
    testString = 'auth.patient' in user.get_all_permissions()
    today = datetime.now()
    today += timedelta(hours=1)

    #Generates all of the times for appointments to be scheduled
    times = []
    for t in range(0,24):
        times += [str(t)+":00"]

    context = {"messagenum": get_number_of_unread(user), 'name': user.first_name + " " + user.last_name,"doctors": Doctor.objects.order_by("firstName"),"today":today,"times":times}
    
    #Authenticates the user
    if not testString:
        return HttpResponseRedirect("/notauthorized")
    
    if request.method == "POST":
        #Grabs all fields in the form
        month = request.POST.get('month', '')
        day = request.POST.get('day', '')
        year = request.POST.get('year', '')
        doctorId = request.POST.get('doctor', '')
        time = request.POST.get('time', '')

        #if there an empty input field, inform user
        if month == '' or day == '' or year == '' or doctorId == '' or time == '':
            context["errortext"]= "Missing Required Field"
            return render(request, 'patients/patientCreateAppointment.html',context)

        #Grab the currently logged in patient, and
        #get a doctor that matches the ID of the one in the dropbox
        patient=Patient.objects.get(userNameField=user.username)
        doctor=Doctor.objects.get(id=doctorId)

        #Attempt to construct a date for the appointment by the submitted year, month, day, and time
        try:
            date = datetime.strptime(month + ' ' + day +  ' ' + year + ' ' + time + "00", '%m %d %Y %H:%M%S')
        #The only field that can be invalid is the day field - meaning the user must have input an invalid day
        except ValueError:
            context["errortext"] = "Invalid Day"
            return render(request, 'patients/patientCreateAppointment.html',context)
                                  
        #Grab all existing appointments at time for both the patient & doctor
        patient_existingAppt = Appointment.objects.filter(patient=patient,dateTime=date,hospital=patient.hospital)
        doctor_existingAppt = Appointment.objects.filter(doctor=doctor, dateTime=date)

        #If the appointment is in the past, don't create it either
        if (today-timedelta(hours=1)) > date:
            context["errortext"] = "Must be scheduled for future"
            return render(request, 'patients/patientCreateAppointment.html',context)                    

        #If there is an existing appointment, do not create the appointment.
        elif patient_existingAppt.exists() or doctor_existingAppt.exists():
            context["errortext"] = "Appointment Conflict"
            return render(request, 'patients/patientCreateAppointment.html',context)
        
        #If there's no conflict, and it's not in the past, that time is free
        else:
            appointment = Appointment(doctor=doctor, patient=patient,dateTime=date,hospital=patient.hospital)
            appointment.save()
            log_add("Patient " + str(patient) + " created an appointment.")
            return HttpResponseRedirect("/calendar")

    else :
        return render(request, 'patients/patientCreateAppointment.html', context)
