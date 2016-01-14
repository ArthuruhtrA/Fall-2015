from django.shortcuts import render

from django.http import HttpResponse, HttpResponseRedirect

from ..models import *
from datetime import datetime, timedelta


def index(request):
    user = request.user
    testString = 'auth.doctor' in user.get_all_permissions()
    today = datetime.now()
    today += timedelta(hours=1)   

    #Generates all of the times for appointments to be scheduled
    times = []
    for t in range(0,24):
        times += [str(t)+":00"]

    #This context variable holds everything we are sending to the HTML.  Please add your desired context here
    context = {'name': user.first_name + " " + user.last_name, "messagenum": get_number_of_unread(user),"patients" : Patient.objects.order_by("firstName"),"date":today,"times":times}

    #Authenticates the user
    if not testString:
        return HttpResponseRedirect("/notauthorized")

    if request.method == "POST":
        #Grabs all submitted values
        month = request.POST.get('month', '')
        day = request.POST.get('day', '')
        year = request.POST.get('year', '')
        patientId = request.POST.get('patient', '')
        time = request.POST.get('time', '')

        #Checks to see if any value was left blank.  If so, throw an error
        if month == '' or day == '' or year == '' or patientId == '' or time == '':
            context['errortext']="Missing Required Field",
            return render(request, 'patients/doctorCreateAppointment.html',context)

        #Get the doctor that is currently logged in, and
        #get the patient whose ID matches that of the patient in the dropbox
        doctor=Doctor.objects.get(userNameField=user.username)
        patient=Patient.objects.get(id = patientId)

        #Attempt to construct a date for the appointment
        try:
            date = datetime.strptime(month + ' ' + day + ' ' + year + ' ' + time + "00", '%m %d %Y %H:%M%S')   
        #The following exception only occurs when the user inputs an erronious day-value
        except ValueError:
            context['errortext']="Invalid Day"
            return render(request, 'patients/doctorCreateAppointment.html',context)

        #Grab all appointments belonging to the patient or doctor at that time
        patient_existingAppt = Appointment.objects.filter(patient=patient,dateTime=date,hospital=patient.hospital)
        doctor_existingAppt = Appointment.objects.filter(doctor=doctor, dateTime=date)

        #If the appointment is scheduled for a past date, throw an error
        if (today-timedelta(hours=1)) > date:
            context['errortext']="Must be scheduled for future"
            return render(request, 'patients/doctorCreateAppointment.html',context)

        #If either the patient or doctor has an existing appointment, throw an error
        elif patient_existingAppt.exists() or doctor_existingAppt.exists():
            context['errortext']= "Appointment Conflict"
            return render(request, 'patients/doctorCreateAppointment.html',context)

        #Otherwise, create the appointment
        else:
            appointment = Appointment(doctor=doctor, patient=patient,dateTime=date,hospital=patient.hospital)
            appointment.save()
            log_add("Doctor " + str(doctor) + " created an appointment.")
            return HttpResponseRedirect("/calendar")

    else :
        return render(request, 'patients/doctorCreateAppointment.html', context)
