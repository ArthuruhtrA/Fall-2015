from django.shortcuts import render
from datetime import date, timedelta
import calendar

from django.http import HttpResponse, HttpResponseRedirect
from django.contrib.auth.models import User
from ..models import *

# Create your views here.

def index(request, cal_year, cal_month, cal_day):
    user = request.user
    #Redirect if not logged in
    if 'auth.nurse' in user.get_all_permissions() and 'auth.patient' in user.get_all_permissions():#superuser
        return HttpResponseRedirect("/administration")
    if 'auth.nurse' in user.get_all_permissions():#nurses have a separate calendar
        return HttpResponseRedirect("/nursecalendar")
    if 'auth.patient' not in user.get_all_permissions() and 'auth.doctor' not in user.get_all_permissions():#needs to be logged in
        return HttpResponseRedirect("/notauthorized")
    #Otherwise display calendar
    pOd = "patient" if 'auth.patient' in user.get_all_permissions() else "doctor"
    userobj = Patient.objects.get(userNameField=user.username) if pOd == "patient" else Doctor.objects.get(userNameField=user.username)
    cal_year = int(cal_year)#Cast all input to int
    cal_month = int(cal_month)
    cal_day = int(cal_day)
    grid = [[None] * 7, [None] * 7, [None] * 7, [None] * 7, [None] * 7, [None] * 7]#Initialize grid
    offset = date(cal_year, cal_month, 1).weekday() + 1#Starting day of week (Python starts on Monday, so fix)
    if offset == 7:
        offset = 0
    cal = calendar.Calendar(6)#initialize calendar
    selectedD = []


    hitFirstDay = False;


    for d in cal.itermonthdates(cal_year, cal_month):

        curr = d.day + offset - 1

        if d.day == 1:
            hitFirstDay = True

        if not hitFirstDay:
            continue

        if grid[curr // 7][curr % 7] != None:
            continue




        #count appointments for user on this date
        #numAppointments = Appointment.objects.filter(patient.userNameField=(user.username)).count() + Appointment.objects.filter(doctor.userNameField=(user.username)).count()
        numAppointments = 0

        appsList = Appointment.objects.order_by("dateTime")

        apps = []

        for app in appsList:
            if d.month == cal_month and app.dateTime.date() == d:
                apps += [app]



        #apps = Appointment.objects.filter(dateTime=d)
        for i in apps:
            if i.patient.userNameField == user.username or i.doctor.userNameField == user.username:
                numAppointments += 1
                if d.day == cal_day:
                    selectedD += [i]#add to day view
        
        if numAppointments == 0:
            numAppointments = ""


        grid[curr // 7][curr % 7] = (d.day, numAppointments)#add to month grid

    #Display schedule for day
    selected = []
    for i in selectedD:
        if pOd == "patient":
            selected += [(i.dateTime.time(), "Dr. " + i.doctor.firstName + " " + i.doctor.lastName, i.id)]
        else:
            selected += [(i.dateTime.time(), i.patient.firstName + " " + i.patient.lastName, i.id)]
    if selected == []:
        selected += [(date(cal_year, cal_month, cal_day), "No Appointments", 0)]
    

    first = date(cal_year, cal_month, 1)
    prev = first - timedelta(days=1)
    nex = first + timedelta(days=32)

    return render(request, 'patients/calendar.html', {"monthName": calendar.month_name[cal_month],"messagenum": get_number_of_unread(user), "pOd": pOd, 'name': user.first_name + " " + user.last_name, "grid": grid, "year": cal_year, "month": cal_month, "day": cal_day, "prev": prev, "nex": nex, "selected": selected, "today": date.today()})
