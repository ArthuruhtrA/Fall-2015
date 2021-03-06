from django.shortcuts import render


from django.http import HttpResponse, HttpResponseRedirect

from ..models import *
from datetime import datetime
from django.db.models import Q

def index(request, text):
    user = request.user
    testString = 'auth.patient' in user.get_all_permissions()
    #Authenticates the user
    if not testString:
        return HttpResponseRedirect("/notauthorized")

    patient=Patient.objects.get(userNameField=user.username)
    appointment = Appointment.objects.get(id=text)
    today = datetime.now()

    #Generates all possible hours an appointment can be scheduled
    times = []
    for t in range(0,24):
        times += [str(t)+":00"]

    context = {"messagenum": get_number_of_unread(user), 'name': user.first_name + " " + user.last_name, "doctors" : Doctor.objects.order_by("firstName"),"cancellink" : "/patientdeleteappointment/" + text,"appointment": appointment, "times":times}
    
    if request.method == "POST":
        #Grab all submitted values
        month = request.POST.get('month', '')
        day = request.POST.get('day', '')
        year = request.POST.get('year', '')
        doctorId = request.POST.get('doctor', '')
        time = request.POST.get('time', '')
        
        #If there is a missing field, inform the user and request new information
        if month == '' or day == '' or year == '' or doctorId == '' or time == '':
            context["errortext"]= "Missing Required Field"
            return render(request, 'patients/patientUpdateCancelAppointment.html',context)

        #If there is any bad data in the date field, it will be caught
        try:
            date = datetime.strptime(month + ' ' + day +  ' ' + year + ' ' + time + "00", '%m %d %Y %H:%M%S')
        except ValueError:
            context["errortext"] = "Invalid Day"
            return render(request, 'patients/patientUpdateCancelAppointment.html',context)
                                          
        doctor = Doctor.objects.get(id=doctorId)

        #Grab all existing appointments at time for both the patient & doctor
        #It also excludes the appointment which matches it's ID (AKA, itself)
        patient_existingAppt = Appointment.objects.filter(~Q(id=appointment.id),patient=patient,dateTime=date,hospital=patient.hospital)
        doctor_existingAppt = Appointment.objects.filter(~Q(id=appointment.id),doctor=doctor, dateTime=date)

        #As long as the appointment has not already happened
        if today > appointment.dateTime:
            context["errortext"] = "This appointment has passed"
            return render(request, 'patients/patientUpdateCancelAppointment.html',context)

        #If the appointment is in the past, don't create it either
        elif today > date:
            context["errortext"] = "Must be scheduled for future"
            return render(request, 'patients/patientUpdateCancelAppointment.html',context)

        #If there is an existing appointment, do not create the appointment.
        elif patient_existingAppt.exists() or doctor_existingAppt.exists():
            context["errortext"] = "Appointment Conflict"
            return render(request, 'patients/patientUpdateCancelAppointment.html',context)
        
        #If there's no conflict, and it's not in the past, that time is free
        else:
            appointment.doctor = doctor
            appointment.dateTime = date
            appointment.save()
            #Add a log
            log_add("Patient " + str(patient) + " updated an appointment.")


        return HttpResponseRedirect("/calendar")
    else :        
        return render(request, 'patients/patientUpdateCancelAppointment.html', context)


def cancelAppointment(request, text):
    appointment = Appointment.objects.get(id=text)
    appointment.delete()

    patient=Patient.objects.get(userNameField=request.user.username)
    log_add("Patient " + str(patient) + " cancelled an appointment.")

    return HttpResponseRedirect("/calendar")
